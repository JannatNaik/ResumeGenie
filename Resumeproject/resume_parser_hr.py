# resume_parser.py

import re
import PyPDF2
import docx2txt
import os

def clean_text(text):
    """Removes unnecessary spaces, line breaks, and special characters."""
    text = re.sub(r'\n+', ' ', text)  # Remove excessive newlines
    text = re.sub(r'\s+', ' ', text)  # Remove extra spaces
    return text.strip()

def extract_text_from_pdf(pdf_path):
    """Extracts text from a PDF file."""
    text = ""
    with open(pdf_path, "rb") as file:
        reader = PyPDF2.PdfReader(file)
        for page in reader.pages:
            extracted = page.extract_text()
            if extracted:
                text += extracted + " "
    return clean_text(text)

def extract_text_from_docx(docx_path):
    """Extracts text from a DOCX file."""
    return clean_text(docx2txt.process(docx_path))

def extract_resume_text(file_path):
    """
    Detects file type and extracts text from a single resume file (PDF/DOCX).
    Returns clean text or an error string.
    """
    file_extension = os.path.splitext(file_path)[1].lower()
    if file_extension == ".pdf":
        return extract_text_from_pdf(file_path)
    elif file_extension == ".docx":
        return extract_text_from_docx(file_path)
    else:
        return "Unsupported file format. Please upload a PDF or DOCX file."

def batch_extract_text(file_paths):
    """
    Processes a list of resume file paths and returns a dictionary:
    { filename: extracted_text or error_message }
    """
    results = {}
    for file_path in file_paths:
        text = extract_resume_text(file_path)
        results[file_path] = text
    return results
