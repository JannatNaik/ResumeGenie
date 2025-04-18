create database resume_genie ;
use resume_genie;
 
CREATE TABLE users (
    uid INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'HR', 'Applicant') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profile (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    uid INT NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    contact_no VARCHAR(20),
    location VARCHAR(255),
    experience INT DEFAULT 0,  -- 0 for freshers
    skills TEXT,
    education TEXT,
    linkedin_url VARCHAR(255),
    github_url VARCHAR(255),
    role ENUM('Applicant', 'HR') NOT NULL,  -- Defines user type
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);
CREATE TABLE User_profile_img (
    img_id INT AUTO_INCREMENT PRIMARY KEY,
    uid INT,
    profile_id INT,
    img VARCHAR(255),
    FOREIGN KEY (uid) REFERENCES users(uid), 
    FOREIGN KEY (profile_id) REFERENCES user_profile(profile_id)
);



CREATE TABLE resumes_deatils (
    resume_id INT AUTO_INCREMENT PRIMARY KEY,
    uid INT NOT NULL,
    profile_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    image_path VARCHAR(255),
    designation VARCHAR(100),
    address TEXT,
    phone_no VARCHAR(20),
    summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE,
    FOREIGN KEY (profile_id) REFERENCES user_profile(profile_id) ON DELETE CASCADE
);

CREATE TABLE achievements (
    achievement_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INT,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE experiences (
    experience_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    organization VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    start_date DATE,
    end_date DATE,
    description TEXT,
    display_order INT,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE education (
    education_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    school VARCHAR(100) NOT NULL,
    degree VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    start_date DATE,
    graduation_date DATE,
    description TEXT,
    display_order INT,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    link VARCHAR(255),
    description TEXT,
    display_order INT,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE ai_resume_analysis (
    analysis_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    uid INT NOT NULL,
    extracted_name VARCHAR(255),
    extracted_email VARCHAR(255),
    extracted_skills TEXT,
    extracted_experience_years INT DEFAULT 0,
    ats_score INT,  -- AI ranking score
    improvement_tips TEXT,
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE ai_resume_analysis_history (
    uid INT,
    profile_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    skills TEXT,
    experience_years FLOAT,
    archived_at DATETIME
);


CREATE TABLE hr_jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    hr_id INT NOT NULL,
    job_title VARCHAR(255) NOT NULL,
    required_skills TEXT NOT NULL,
    min_experience INT DEFAULT 0,
    min_resume_score INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hr_id) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE matched_resumes (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    resume_id INT NOT NULL,
    uid INT NOT NULL,
    match_score INT NOT NULL,
    matched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES hr_jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE hr_dashboard (
    analysis_id INT AUTO_INCREMENT PRIMARY KEY,
    hr_id INT NOT NULL,
    resume_id INT NOT NULL,
    notes TEXT,
    shortlisted BOOLEAN DEFAULT FALSE,
    reviewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hr_id) REFERENCES users(uid) ON DELETE CASCADE,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    uid INT NOT NULL,
    action_type VARCHAR(255) NOT NULL,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);

CREATE TABLE admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL UNIQUE,
    company_email VARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255) UNIQUE,
    registration_number VARCHAR(100) UNIQUE,  -- For legal verification
    industry VARCHAR(100),
    location VARCHAR(255),
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    document_name VARCHAR(255),  -- Name of the verification document
    document_path VARCHAR(255),  -- File path for stored document
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE hr_verification (
    hr_id INT NOT NULL PRIMARY KEY, -- No AUTO_INCREMENT
    company_id INT NOT NULL,  
    designation VARCHAR(100),
    contact_number VARCHAR(20),
    linkedin_url VARCHAR(255),
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hr_id) REFERENCES users(uid) ON DELETE CASCADE, -- hr_id = uid
    FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE
);

CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    display_order INT,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id) ON DELETE CASCADE
);

CREATE TABLE user_skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    uid INT NOT NULL,
    skill_name VARCHAR(255) NOT NULL,  -- Users enter skills manually
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uid) REFERENCES users(uid) ON DELETE CASCADE
);


CREATE TABLE job_skills (
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES hr_jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);



SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'hr_jobs';

ALTER TABLE hr_jobs 
MODIFY COLUMN hr_id INT NOT NULL,
ADD FOREIGN KEY (hr_id) REFERENCES hr_verification(hr_id) ON DELETE CASCADE;

ALTER TABLE hr_jobs 
DROP FOREIGN KEY hr_jobs_ibfk_1,  -- Drop old FK if exists
ADD FOREIGN KEY (hr_id) REFERENCES hr_verification(hr_id) ON DELETE CASCADE;



-- Remove skills from user_profile (no longer needed)
ALTER TABLE user_profile DROP COLUMN skills;

-- Remove extracted_skills from ai_resume_analysis
ALTER TABLE ai_resume_analysis DROP COLUMN extracted_skills;

-- Remove required_skills from hr_jobs
ALTER TABLE hr_jobs DROP COLUMN required_skills;


SHOW TABLES;


drop table skills;

INSERT INTO users (uid, fullname, email, password_hash, role)
VALUES (101, 'Test User', 'test@example.com', 'dummyhashedpassword', 'Applicant');

INSERT INTO user_profile (
    profile_id,
    uid,
    full_name,
    contact_no,
    location,
    experience,
    skills,
    education,
    linkedin_url,
    github_url,
    role
)
VALUES (
    200, -- profile_id
    101, -- uid (foreign key)
    'Test User',
    '9876543210',
    'Mumbai, India',
    2, -- experience in years
    'Python, Java, SQL',
    'B.Sc Computer Science from XYZ University',
    'https://linkedin.com/in/testuser',
    'https://github.com/testuser',
    'Applicant'
);

DESCRIBE user_profile;
ALTER TABLE user_profile
ADD skills TEXT;

CREATE USER 'resumegenie'@'localhost' IDENTIFIED BY 'genie123';
GRANT ALL PRIVILEGES ON resume_genie.* TO 'resumegenie'@'localhost';
FLUSH PRIVILEGES;

