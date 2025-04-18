import sys
import json
from resume_parser_hr import extract_resume_text
from detail_extraction import parse_resume

if __name__ == "__main__":
    file_path = sys.argv[1]  # Get file path from command line

    extracted_text = extract_resume_text(file_path)  # Extract text
    parsed_data = parse_resume(extracted_text)  # Parse resume details

    print(json.dumps({"resume_data": parsed_data}, indent=4))  # Print structured output
