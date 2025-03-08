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
    file_path = sys.argv[1]  # Receive file path from Java

    # Check the file extension and extract text accordingly
    file_extension = os.path.splitext(file_path)[1].lower()

    if file_extension == ".pdf":
        extracted_text = extract_text_from_pdf(file_path)
    elif file_extension == ".docx":
        extracted_text = extract_text_from_docx(file_path)
    else:
        extracted_text = "Unsupported file format. Please upload a PDF or DOCX file."

    # Return the extracted text in JSON format
    print(json.dumps({"resume_text": extracted_text}))
