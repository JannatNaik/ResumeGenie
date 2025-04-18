# match_score.py

import difflib

def match_skills(user_skills, job_skills):
    matched_skills = 0
    total_weight = 0

    for job_skill in job_skills:
        best_match = difflib.get_close_matches(job_skill.lower(), [s.lower() for s in user_skills], n=1, cutoff=0.7)
        if best_match:
            matched_skills += 1
            total_weight += 1 if job_skill.lower() == best_match[0] else 0.75  # fuzzy match weight

    score = (total_weight / len(job_skills)) * 100 if job_skills else 0
    return round(score, 2)
