import json

from flask import Flask, render_template, request, redirect
from database import get_db

app = Flask(__name__)

@app.route('/')
def dashboard():
    conn = get_db()
    cursor = conn.cursor()

    cursor.execute('SELECT COUNT(*) as count FROM applications')
    app_count = cursor.fetchone()['count']

    cursor.execute('SELECT COUNT(*) as count FROM jobs')
    job_count = cursor.fetchone()['count']

    cursor.execute('SELECT COUNT(*) as count FROM companies')
    company_count = cursor.fetchone()['count']

    cursor.execute('SELECT status, COUNT(*) as count FROM applications GROUP BY status')
    status_counts = {row['status']: row['count'] for row in cursor.fetchall()}

    cursor.execute('''
        SELECT a.application_date, a.status, j.job_title, c.company_name
        FROM applications a
        LEFT JOIN jobs j ON a.job_id = j.job_id
        LEFT JOIN companies c ON j.company_id = c.company_id
        ORDER BY a.application_date DESC
        LIMIT 5
    ''')
    recent = cursor.fetchall()

    conn.close()

    stats = {
        'applications': app_count,
        'jobs': job_count,
        'companies': company_count
    }

    return render_template('dashboard.html', stats=stats, status_counts=status_counts, recent=recent)

# ─── COMPANIES ───────────────────────────────────────────

@app.route('/companies')
def companies():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM companies ORDER BY company_name')
    all_companies = cursor.fetchall()
    conn.close()
    return render_template('companies.html', companies=all_companies)

@app.route('/companies/add', methods=['POST'])
def add_company():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO companies (company_name, industry, website, city, state, notes)
        VALUES (%s, %s, %s, %s, %s, %s)
    ''', (
        request.form['company_name'],
        request.form['industry'],
        request.form['website'],
        request.form['city'],
        request.form['state'],
        request.form['notes']
    ))
    conn.commit()
    conn.close()
    return redirect('/companies')

@app.route('/companies/edit/<int:id>', methods=['POST'])
def edit_company(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE companies
        SET company_name=%s, industry=%s, website=%s, city=%s, state=%s, notes=%s
        WHERE company_id=%s
    ''', (
        request.form['company_name'],
        request.form['industry'],
        request.form['website'],
        request.form['city'],
        request.form['state'],
        request.form['notes'],
        id
    ))
    conn.commit()
    conn.close()
    return redirect('/companies')

@app.route('/companies/delete/<int:id>')
def delete_company(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM companies WHERE company_id = %s', (id,))
    conn.commit()
    conn.close()
    return redirect('/companies')

# ─── JOBS ────────────────────────────────────────────────

@app.route('/jobs')
def jobs():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        SELECT j.*, c.company_name 
        FROM jobs j
        LEFT JOIN companies c ON j.company_id = c.company_id
        ORDER BY j.date_posted DESC
    ''')
    all_jobs = cursor.fetchall()
    cursor.execute('SELECT company_id, company_name FROM companies ORDER BY company_name')
    companies = cursor.fetchall()
    conn.close()
    return render_template('jobs.html', jobs=all_jobs, companies=companies)

@app.route('/jobs/add', methods=['POST'])
def add_job():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO jobs (company_id, job_title, job_type, salary_min, salary_max, job_url, date_posted)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    ''', (
        request.form['company_id'],
        request.form['job_title'],
        request.form['job_type'] or None,
        request.form['salary_min'] or None,
        request.form['salary_max'] or None,
        request.form['job_url'] or None,
        request.form['date_posted'] or None
    ))
    conn.commit()
    conn.close()
    return redirect('/jobs')

@app.route('/jobs/edit/<int:id>', methods=['POST'])
def edit_job(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE jobs
        SET company_id=%s, job_title=%s, job_type=%s,
            salary_min=%s, salary_max=%s, job_url=%s, date_posted=%s
        WHERE job_id=%s
    ''', (
        request.form['company_id'],
        request.form['job_title'],
        request.form['job_type'] or None,
        request.form['salary_min'] or None,
        request.form['salary_max'] or None,
        request.form['job_url'] or None,
        request.form['date_posted'] or None,
        id
    ))
    conn.commit()
    conn.close()
    return redirect('/jobs')

@app.route('/jobs/delete/<int:id>')
def delete_job(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM jobs WHERE job_id = %s', (id,))
    conn.commit()
    conn.close()
    return redirect('/jobs')

# ─── APPLICATIONS ────────────────────────────────────────

@app.route('/applications')
def applications():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        SELECT a.*, j.job_title, c.company_name
        FROM applications a
        LEFT JOIN jobs j ON a.job_id = j.job_id
        LEFT JOIN companies c ON j.company_id = c.company_id
        ORDER BY a.application_date DESC
    ''')
    all_applications = cursor.fetchall()
    cursor.execute('''
        SELECT j.job_id, j.job_title, c.company_name
        FROM jobs j
        LEFT JOIN companies c ON j.company_id = c.company_id
        ORDER BY c.company_name
    ''')
    jobs = cursor.fetchall()
    conn.close()
    return render_template('applications.html', applications=all_applications, jobs=jobs)

@app.route('/applications/add', methods=['POST'])
def add_application():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO applications (job_id, application_date, status, resume_version, cover_letter_sent)
        VALUES (%s, %s, %s, %s, %s)
    ''', (
        request.form['job_id'],
        request.form['application_date'],
        request.form['status'],
        request.form['resume_version'] or None,
        1 if request.form.get('cover_letter_sent') else 0
    ))
    conn.commit()
    conn.close()
    return redirect('/applications')

@app.route('/applications/edit/<int:id>', methods=['POST'])
def edit_application(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE applications
        SET job_id=%s, application_date=%s, status=%s,
            resume_version=%s, cover_letter_sent=%s
        WHERE application_id=%s
    ''', (
        request.form['job_id'],
        request.form['application_date'],
        request.form['status'],
        request.form['resume_version'] or None,
        1 if request.form.get('cover_letter_sent') else 0,
        id
    ))
    conn.commit()
    conn.close()
    return redirect('/applications')

@app.route('/applications/delete/<int:id>')
def delete_application(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM applications WHERE application_id = %s', (id,))
    conn.commit()
    conn.close()
    return redirect('/applications')

# ─── CONTACTS ────────────────────────────────────────────

@app.route('/contacts')
def contacts():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        SELECT ct.*, c.company_name
        FROM contacts ct
        LEFT JOIN companies c ON ct.company_id = c.company_id
        ORDER BY ct.contact_name
    ''')
    all_contacts = cursor.fetchall()
    cursor.execute('SELECT company_id, company_name FROM companies ORDER BY company_name')
    companies = cursor.fetchall()
    conn.close()
    return render_template('contacts.html', contacts=all_contacts, companies=companies)

@app.route('/contacts/add', methods=['POST'])
def add_contact():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO contacts (company_id, contact_name, job_title, email, phone, linkedin_url, notes)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    ''', (
        request.form['company_id'],
        request.form['contact_name'],
        request.form['job_title'],
        request.form['email'],
        request.form['phone'],
        request.form['linkedin_url'],
        request.form['notes']
    ))
    conn.commit()
    conn.close()
    return redirect('/contacts')

@app.route('/contacts/edit/<int:id>', methods=['POST'])
def edit_contact(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        UPDATE contacts
        SET company_id=%s, contact_name=%s, job_title=%s,
            email=%s, phone=%s, linkedin_url=%s, notes=%s
        WHERE contact_id=%s
    ''', (
        request.form['company_id'],
        request.form['contact_name'],
        request.form['job_title'],
        request.form['email'],
        request.form['phone'],
        request.form['linkedin_url'],
        request.form['notes'],
        id
    ))
    conn.commit()
    conn.close()
    return redirect('/contacts')

@app.route('/contacts/delete/<int:id>')
def delete_contact(id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM contacts WHERE contact_id = %s', (id,))
    conn.commit()
    conn.close()
    return redirect('/contacts')

# ─── JOB MATCH ───────────────────────────────────────────

@app.route('/job-match', methods=['GET', 'POST'])
def job_match():
    results = []
    user_skills = ''
    if request.method == 'POST':
        user_skills = request.form['skills']
        skill_list = [s.strip().lower() for s in user_skills.split(',') if s.strip()]

        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('''
            SELECT j.job_id, j.job_title, j.requirements, c.company_name
            FROM jobs j
            LEFT JOIN companies c ON j.company_id = c.company_id
            WHERE j.requirements IS NOT NULL
        ''')
        jobs = cursor.fetchall()
        conn.close()

        for job in jobs:
            reqs = job['requirements']
            if isinstance(reqs, str):
                try:
                    reqs = json.loads(reqs)
                except (json.JSONDecodeError, ValueError):
                    reqs = []
            if not reqs:
                continue

            req_lower = [r.strip().lower() for r in reqs]
            matched = [s for s in skill_list if s in req_lower]
            missing = [r for r in req_lower if r not in skill_list]
            total = len(req_lower)
            percent = round((len(matched) / total) * 100) if total > 0 else 0

            results.append({
                'job_title': job['job_title'],
                'company_name': job['company_name'],
                'percent': percent,
                'matched': matched,
                'missing': missing,
                'total': total
            })

        results.sort(key=lambda x: x['percent'], reverse=True)

    return render_template('job_match.html', results=results, user_skills=user_skills)

if __name__ == '__main__':
    app.run(debug=True)