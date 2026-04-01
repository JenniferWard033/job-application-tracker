# Job Application Tracker

A web application to help track job applications during the job search process.

## Features

- **Dashboard** — overview of total applications, jobs, and companies
- **Companies** — add, edit, and delete companies
- **Jobs** — add, edit, and delete job postings
- **Applications** — record application submissions and track their status
- **Contacts** — store contact information
- **Job Match** — enter your skills and see jobs ranked by match percentage

## Technologies Used

- **Backend:** Python 3, Flask
- **Database:** MySQL
- **Frontend:** HTML, CSS, Bootstrap 5

## Setup Instructions

### 1. Clone the repository

```
git clone <your-repo-url>
cd job_tracker
```

### 2. Install Python dependencies

```
pip install -r requirements.txt
```

### 3. Set up the database

- Open MySQL Workbench
- Go to **Server** -> **Data Import**
- Select **Import from Self-Contained File** and browse to `schema.sql`
- Click **Start Import** to create the database and load sample data

### 4. Configure the database connection

Open `database.py` and update the credentials to match your MySQL setup. You will need to update the password with your password (If you do not update with your password the program won't run and access the database):

```python
def get_db():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='your_password_here',
        database='job_tracker',
        cursorclass=pymysql.cursors.DictCursor
    )
```

### 5. Run the application

```
python app.py
```

Then open your browser and go to: `http://127.0.0.1:5000`
