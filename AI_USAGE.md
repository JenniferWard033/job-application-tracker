# AI Usage Documentation

## Tools Used

- Claude — used throughout development for code generation and review and troubleshooting
- Google Stitch — used to generate UI designs for the dashboard and all data pages

## Key Prompts

1. "Write Flask routes and HTML templates for a job application tracker with CRUD functionality for companies, jobs, applications, and contacts."
2. "Write a skill matching algorithm that takes a user's skills as input and ranks jobs by match percentage."
3. "Generate realistic job requirements in JSON format for a variety of job titles."
4. "Design a dashboard page for a job application tracker web app with statistics cards, application status breakdown, and recent applications. Uses Bootstrap 5 and a dark navbar." (Google Stitch)
5. "Design a data table page for a job tracker app showing company records with avatar initials, industry pills, and icon-only edit/delete buttons." (Google Stitch)
6. "The contacts table in my schema uses first_name and last_name but my Flask routes and templates use contact_name — what changes do I need to make to fix this mismatch?"

## What Worked Well

- AI quickly generated the HTML templates with Bootstrap modals for add and edit forms
- The job match algorithm logic — calculating match percentage, sorting results, and displaying matched vs. missing skills — was well structured from the start
- AI-generated routes followed a consistent pattern across all four tables
- Google Stitch produced detailed, professional UI designs that translated well into working HTML and CSS

## What I Modified

- Started with the basic Flask app structure provided in the course materials and expanded from there
- Reviewed the project requirements against the actual database schema and made corrections to align column names, data types, and missing fields (such as adding the `requirements` JSON column to the jobs table that was not listed in previous assignments)
- Adjusted form field names in templates and routes to match the finalized database schema
- Added some sample requirements data to job records so the Job Match feature would return meaningful results

## Lessons Learned

- AI is excellent for generating boilerplate code quickly, but you still need to carefully compare it against your actual database schema because column names and data types may not always match
- Always test AI-generated code against real data; the Job Match feature needed requirements data in the database before it would return any results
- Reviewing the project specification in detail and comparing it to what was already built is an important step before finalizing the project
- Google Stitch generates designs using Tailwind CSS and when adapting to a Bootstrap project, the design needs to be reimplemented using the existing CSS framework rather than copied directly
