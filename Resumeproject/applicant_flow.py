# applicant_flow.py

import sys
import mysql.connector
import datetime

from resume_parser_hr import extract_resume_text
from detail_extraction import parse_resume
from store_resume_data import insert_resume_data
from generate_ai_suggestions import compare_with_user_profile

def archive_or_update_analysis(cursor, conn, uid, profile_id, new_data):
    # Check if existing resume analysis exists
    cursor.execute("SELECT * FROM ai_resume_analysis WHERE uid=%s AND profile_id=%s", (uid, profile_id))
    old_data = cursor.fetchone()

    if old_data:
        # Archive old data
        cursor.execute("""
            INSERT INTO ai_resume_analysis_history (uid, profile_id, name, email, skills, experience_years, archived_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            old_data[0], old_data[1], old_data[2], old_data[3],
            old_data[4], old_data[5], datetime.datetime.now()
        ))

        # Update current entry
        cursor.execute("""
            UPDATE ai_resume_analysis
            SET name=%s, email=%s, skills=%s, experience_years=%s
            WHERE uid=%s AND profile_id=%s
        """, (
            new_data['name'], new_data['email'], new_data['skills'], new_data['experience_years'],
            uid, profile_id
        ))
    else:
        # Insert fresh data
        cursor.execute("""
            INSERT INTO ai_resume_analysis (uid, profile_id, name, email, skills, experience_years)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            uid, profile_id, new_data['name'], new_data['email'],
            new_data['skills'], new_data['experience_years']
        ))

    conn.commit()

def main():
    if len(sys.argv) != 4:
        print("Usage: python applicant_flow.py <file_path> <uid> <profile_id>")
        sys.exit(1)

    file_path = sys.argv[1]
    uid = int(sys.argv[2])
    profile_id = int(sys.argv[3])

    print(f"[INFO] Processing resume for UID: {uid}, Profile ID: {profile_id}")

    try:
        extracted_text = extract_resume_text(file_path)
        if extracted_text.startswith("Unsupported"):
            print(f"[ERROR] {extracted_text}")
            return

        parsed_resume_data = parse_resume(extracted_text)

        # Save resume content into `resumes_details` or similar
        resume_id = insert_resume_data(parsed_resume_data, uid, profile_id)

        # Generate AI suggestions based on profile + resume data
        suggestions = compare_with_user_profile(uid, parsed_resume_data)

        # Connect to DB
        conn = mysql.connector.connect(
            host="localhost",
            user="your_user",
            password="your_pass",
            database="your_db"
        )
        cursor = conn.cursor()

        # Merge resume data + AI suggestion (optional)
        new_data = {
            "name": parsed_resume_data.get("name", ""),
            "email": parsed_resume_data.get("email", ""),
            "skills": ",".join(parsed_resume_data.get("skills", [])),
            "experience_years": parsed_resume_data.get("experience", 0)
        }

        archive_or_update_analysis(cursor, conn, uid, profile_id, new_data)

        cursor.close()
        conn.close()

        print("[SUCCESS] Resume processed and analysis stored/updated.")

    except Exception as e:
        print(f"[ERROR] Failed to process resume: {str(e)}")

if __name__ == "__main__":
    main()
