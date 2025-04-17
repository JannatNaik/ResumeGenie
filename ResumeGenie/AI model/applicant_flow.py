import sys
import json
from resume_parser_hr import extract_resume_text
from detail_extraction import parse_resume
from store_resume_data import insert_resume_data
from generate_ai_suggestions import compare_with_user_profile, store_analysis

if __name__ == "__main__":
    file_path = sys.argv[1]
    uid = int(sys.argv[2])         # Applicant user ID
    profile_id = int(sys.argv[3])  # Applicant's profile ID

    extracted_text = extract_resume_text(file_path)
    parsed_resume_data = parse_resume(extracted_text)

    resume_id = insert_resume_data(parsed_resume_data, uid, profile_id)
    suggestions = compare_with_user_profile(uid, parsed_resume_data)
    store_analysis(uid, resume_id, parsed_resume_data, suggestions)

    print("Resume processed and stored successfully.")
