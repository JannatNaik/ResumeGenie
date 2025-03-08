# ResumeGenie
A combination of resume screening and job portal web application
The objective of ResumeGenie is to streamline and enhance the resume screening process using AI-powered analysis, helping both HR professionals and job seekers by providing automated resume evaluation, intelligent matching, and data-driven insights.
Key Goals:
  For HR Professionals:
    Automate Resume Screening & Parsing: AI extracts key details (Name, Skills, Experience, Education) from multiple resumes.
    Intelligent Resume Ranking & Filtering: AI scores and ranks resumes based on job criteria, allowing HR to filter by skills, 
    experience, and education.
    Enhanced Recruitment Efficiency: Reduces hiring time with automated screening and AI-driven recommendations.
    Resume Shortlisting & Reports: Generates detailed reports of top-matching candidates in PDF format for easy decision-making.
  
  For Job Seekers (Applicants):
    AI-Powered Resume Evaluation: Analyzes resume quality, ATS compatibility, and keyword strength, providing a score (0-100%).
    AI-Driven Resume Optimization:  Suggests missing skills, improves formatting, and enhances ATS ranking.
    Job Matching System:  Matches resumes with job roles based on skills, experience, and education.
    AI-Generated Resume Enhancement: Creates an optimized, ATS-friendly resume with a PDF download option.
    Social Profile & Portfolio Analysis: Evaluates LinkedIn, GitHub, and portfolio completeness, suggesting improvements for better 
    recruiter visibility.

FUNCTIONAL REQUIREMENTS:-
  User Authentication Module:
     Login and Registration:
       Secure authentication for HR & applicants.
       Password encryption and session management.
     User profile Management:
       HR: Manage company details, job roles, and preferences.
       Applicant: Update personal details, upload resumes, and track application status.
  
  HR Module:
    Dashboard: Overview of all uploaded resumes
    Resume Upload & Parsing:
      Upload multiple resumes (PDF/DOCX).
      AI-powered parsing extracts: Skills, Experience, Education, etc.
      Store parsed data in MySQL.
    AI-Powered Resume Scoring & Ranking:
      AI assigns scores (0-100%) based on: Keyword matching with job criteria, Skill relevance, Experience level.
      Rank resumes in order of best match.
    Resume Filtering:
      Filter resumes by: skills, experience, education, keyword.
      Save shortlisted resumes for further review.
    Generate PDF Reports for Shortlisted Candidates:
      HR can generate detailed reports of top-matching resumes.
      Download reports for internal hiring decisions.
  
  Applicant Module:
    Dashboard:View uploaded resumes, AI analysis results, and job recommendations.
    Resume Upload and AI Analysis:
      Upload resumes (PDF/DOCX).
      AI extracts user details (name, contact, skills, education, etc.).
      AI generates a resume quality score (0-100%) based on: Formatting consistency, ATS compatibility.
      Use of industry-relevant keywords.
    Resume Improvement & Optimization:
       AI suggests missing skills based on job industry trends.
       AI recommends formatting improvements (font, readability, structure).
       AI optimizes keywords for better job match and ATS ranking.
    Job Matching System:
      Matches applicant's resume with job roles.
      Provides personalized suggestions for increasing hiring chances.
    Social Profile & Portfolio Analysis:
      AI evaluates: LinkedIn  profile completeness, GitHub repositories (for developers), Personal portfolios.
    AI-Generated Resume Optimization & Download:
      Generates an improved, ATS-friendly version of the resume.
      Allows users to download the optimized resume in PDF format.
  
  
  Admin Module:
    User Management:
       Manage HR and applicant accounts.
       Handle account activation and deactivation.
    System Monitoring & Logs:
      Track AI-based resume processing logs.
      Monitor performance and system usage statistics.
    Security & Compliance:
      Data encryption and secure user authentication.
      Ensure GDPR compliance for user privacy and data protection.

Software requirements:
  Frontend:
    HTML5, CSS3, JavaScript – For UI design and responsiveness.
    JSP (JavaServer Pages) – For dynamic content rendering.
  Backend:
    Servlets & JDBC (Java Database Connectivity) – Handles business logic and database operations.
    MySQL – Stores user profiles, resumes, job listings, and rankings.
    Python (AI/ML Module) – Implements resume parsing, scoring, and job-matching algorithms.
  AI/ML Libraries for Resume Processing:
    spaCy– NLP-based text extraction and keyword analysis.
    PyPDF2, docx2txt – Extract text from PDFs and DOCX resumes.
  Other Requirements:
    Apache Tomcat Server – For deploying JSP/Servlet applications.
    NetBeans, Visual Studio code – IDE for Java development.
    GitHub – Version control.


