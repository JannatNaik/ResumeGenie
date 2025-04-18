import mysql.connector
from datetime import datetime

def compare_with_user_profile(uid, resume_data):
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="your_password",
        database="resume_genie"
    )
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM user_profile WHERE uid = %s", (uid,))
    profile = cursor.fetchone()
    suggestions = []

    if profile:
        if profile.get("experience", 0) < resume_data["experience"]["experience_years"]:
            suggestions.append("Update your profile experience based on your resume.")
        
        if profile.get("education") is None or profile.get("education") == "":
            suggestions.append("Add education details in your profile.")

        if not profile.get("location"):
            suggestions.append("Add your location for better job recommendations.")
        
        if profile.get("skills"):
            profile_skills = set(profile["skills"].lower().split(","))
            resume_skills = set(map(str.lower, resume_data["skills"]))
            unmatched_skills = resume_skills - profile_skills
            if unmatched_skills:
                suggestions.append(f"Add missing skills to your profile: {', '.join(unmatched_skills)}")
        else:
            suggestions.append("Add skills to your profile.")

    return suggestions



def store_analysis(uid, resume_id, resume_data, suggestions):
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Jannat@2002",
        database="resume_genie"
    )
    cursor = conn.cursor()

    sql = """
    INSERT INTO ai_resume_analysis (
        resume_id, uid, extracted_name, extracted_email, 
        extracted_experience_years, ats_score, improvement_tips, analyzed_at
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    values = (
        resume_id,
        uid,
        resume_data["name"],
        resume_data["email"],
        resume_data["experience"]["experience_years"],
        75,  # Dummy ATS score for now
        "\n".join(suggestions),
        datetime.now()
    )

    cursor.execute(sql, values)
    conn.commit()
    cursor.close()
    conn.close()
