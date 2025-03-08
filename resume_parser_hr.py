import PyPDF2
import docx2txt
import sys
import json
import os

def extract_text_from_pdf(pdf_path):
    """Extracts text from a PDF file."""
    text = ""
    with open(pdf_path, "rb") as file:
        reader = PyPDF2.PdfReader(file)
        for page in reader.pages:
            text += page.extract_text() + "\n"
    return text.strip()

def extract_text_from_docx(docx_path):
    """Extracts text from a DOCX file."""
    return docx2txt.process(docx_path).strip()

if __name__ == "__main__":
    file_paths = sys.argv[1:]  # Receive multiple file paths from Java

    extracted_data = {}  # Dictionary to store extracted text for each file

    for file_path in file_paths:
        file_extension = os.path.splitext(file_path)[1].lower()

        if file_extension == ".pdf":
            extracted_text = extract_text_from_pdf(file_path)
        elif file_extension == ".docx":
            extracted_text = extract_text_from_docx(file_path)
        else:
            extracted_text = "Unsupported file format. Please upload a PDF or DOCX file."

        extracted_data[file_path] = extracted_text  # Store extracted text in dictionary

    # Return extracted text for all resumes in JSON format
    print(json.dumps({"resumes": extracted_data}, indent=4))
