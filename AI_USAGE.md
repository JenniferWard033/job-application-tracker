# AI Usage Documentation

## Tools Used

- Claude: used for code generation, debugging help, and troubleshooting throughout development
- Google Stitch: used to generate UI designs for the dashboard and all data pages

## Key Prompts

1. How should I organize Flask routes and HTML templates for a job tracker app with add, edit, and delete functionality?
2. How do I calculate a match percentage between a user's skills and a list of job requirements?
3. What format should job requirements be stored in in order to do skill matching?
4. I prompted Google Stitch with: Design a dashboard page for a job application tracker web app with statistics cards, application status breakdown, and recent applications. (Google Stitch)
5. I prompted Google Stitch with: Design a data table page for a job tracker app showing company records with buttons to edit or delete each one. (Google Stitch)
6. How do I debug a Flask route that isn't returning the expected results from the database?
7. Multiple follow-up prompts troubleshooting the job match algorithm, getting the JSON requirements field to parse correctly and results to rank by match percentage took several attempts.

## What Worked Well

- HTML templates with Bootstrap modals for add and edit forms were straightforward to build and worked well across all pages.
- Routes followed a consistent pattern across all four tables, which made them easy to implement, review and understand
- Google Stitch produced detailed UI designs that gave a clear target to work toward
- Using AI as a debugging aid, describing what was broken and getting pointed in the right direction saved a lot of time

## What I Had to Fix

- The job match feature didn't return any results at first. The algorithm wasn't correctly reading the `requirements` JSON column, and the jobs in the database didn't have requirements data populated. I worked through both issues by fixing the parsing logic, adding sample data, and testing through multiple rounds.
- Google Stitch outputs Tailwind CSS, but this project uses Bootstrap. The designs couldn't be used directly and had to be reimplemented using Bootstrap classes and layout patterns.
- Reviewed all routes and templates against the actual schema to catch column name and data type mismatches.

## Lessons Learned

- Code needs to be tested against real data before assuming it works, the job match issue only showed up at runtime.
- When something breaks, reading the error carefully and tracing it back to the source (in this case, a schema mismatch) is faster than just re-prompting and hoping for a different result
- For anything that involves parsing or logic, expect to go back and forth a few times before getting it right.
- Google Stitch is useful for design direction but the output isn't drop-in ready if your project uses a different CSS framework
