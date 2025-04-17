import re

def extract_name(text):
    """Extracts name (assuming it appears at the top)."""
    words = text.split()
    return words[0] + " " + words[1] if len(words) > 1 else words[0]

def extract_email(text):
    """Extracts email using regex."""
    email_pattern = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
    emails = re.findall(email_pattern, text)
    return emails[0] if emails else None

def extract_phone(text):
    """Extracts phone number using regex."""
    phone_pattern = r"\+?\d{1,4}?[-.\s]?\(?\d{1,3}?\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}"
    phones = re.findall(phone_pattern, text)
    return phones[0] if phones else None

def extract_experience(text):
    """Extracts years of experience and multiple experience categories correctly."""
    
    # Improved regex to ensure "experience" context is considered
    exp_pattern = r"(\d+)\s*(?:years|yrs|year|yr)\s*(?:of experience|experience)?"
    matches = re.findall(exp_pattern, text, re.IGNORECASE)

    # Extract highest numeric experience (ignores unrelated numbers)
    experience_years = max(map(int, matches)) if matches else 0  

    # Keywords for categorical experience levels
    experience_categories = {
        "Fresher": r"\b(fresher|no experience|recent graduate)\b",
        "Intern": r"\b(intern(ship)?|intern at|intern experience)\b",
        "Entry-level": r"\b(entry[-\s]?level|beginner role)\b",
        "Junior": r"\b(junior|jr\.|junior role)\b",
        "Mid-level": r"\b(mid[-\s]?level|mid-senior)\b",
        "Senior": r"\b(senior|sr\.|senior role)\b",
        "Lead": r"\b(lead|leadership experience)\b",
        "Manager": r"\b(manager|team manager|management experience)\b",
        "Expert": r"\b(expert|advanced professional)\b",
        "Freelancer": r"\b(freelance|self[-\s]?employed|independent consultant)\b",
        "Volunteer": r"\b(volunteer|non[-\s]?profit work|community service)\b",
        "Class Projects": r"\bclass[-\s]?project(s)?\b",
        "Jobs": r"\bjob(s)?\b",
        "Military Experience": r"\bmilitary[-\s]?experience\b",
        "Professional Training": r"\bprofessional[-\s]?training\b",
        "Non-Profit Work": r"\bnon[-\s]?profit\b",
        "Community Leadership": r"\bcommunity[-\s]?leadership\b",
        "Mentorship": r"\bmentorship\b",
        "Open-Source Contributions": r"\bopen[-\s]?source\b",
        "Personal Projects": r"\bpersonal[-\s]?project(s)?\b",
        "Hackathons & Competitions": r"\bhackathon(s)?|competition(s)?\b",
        "Research Assistant": r"\bresearch[-\s]?assistant\b",
        "PhD / Postdoctoral Research": r"\b(phd|postdoctoral)\b",
        "Publications & Conferences": r"\bpublication(s)?|conference(s)?\b",
        "Freelance Work": r"\bfreelance\b",
        "Self-Employed": r"\bself[-\s]?employed\b",
        "Consultant Roles": r"\bconsultant\b",
        "Apprenticeship": r"\bapprenticeship\b",
        "Trainee Roles": r"\btrainee\b",
        "Years of Experience": r"(\d+)\s*(?:years|yrs|year|yr)\s*(?:of experience|experience)?",
        "Job Titles": r"\b(job[-\s]?title(s)?)\b",
        "Industry Experience": r"\bindustry[-\s]?experience\b",
        "Company Names": r"\b(company|organization|firm|corporation)\b",
        "Software Engineer": r"\bsoftware[-\s]?engineer\b",
        "Junior Developer": r"\bjunior[-\s]?developer\b",
        "WebInnovate": r"\bwebinnovate\b"
    }

    detected_categories = []  # List to store all matched categories
    for category, pattern in experience_categories.items():
        if re.search(pattern, text, re.IGNORECASE):
            detected_categories.append(category)

    return {
        "experience_years": experience_years,
        "experience_categories": detected_categories if detected_categories else ["Unknown"]
    }

def extract_skills(text, predefined_skills):
    """Extracts skills from resume text using predefined skill set."""
    found_skills = [skill for skill in predefined_skills if skill.lower() in text.lower()]
    return found_skills

# Example Predefined Skills List
predefined_skills = ["Python", "Java", "SQL", "Machine Learning", "Data Science", "Deep Learning", "C++", "HTML", "CSS", "JavaScript"]

def parse_resume(text):
    """Parses resume text and extracts structured data."""
    parsed_data = {
        "name": extract_name(text),
        "email": extract_email(text),
        "phone": extract_phone(text),
        "experience": extract_experience(text),
        "skills": extract_skills(text, predefined_skills),
    }
    return parsed_data
