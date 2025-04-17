import sys
import json
from resume_parser import parse_resume
from matcher import match_resumes_to_job

job_id = int(sys.argv[1])

# Fetch job description from DB
job_desc = fetch_job_description_from_db(job_id)

# Parse all resumes in temp folder
resumes = parse_all_resumes("uploads/temp")

# Match resumes to job desc using custom NER + ML model
matched = match_resumes_to_job(resumes, job_desc)

# Insert matched scores into MySQL or write to JSON to be picked up by Java
print(json.dumps(matched))  # Java reads this output
