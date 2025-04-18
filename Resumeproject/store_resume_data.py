import mysql.connector
import json
import sys
from datetime import datetime

def insert_resume_data(data, uid, profile_id):
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Jannat@2002",
        database="resume_genie"
    )
    cursor = conn.cursor()

    sql = """
    INSERT INTO resumes_deatils 
    (uid, profile_id, first_name, middle_name, last_name, phone_no, summary, created_at, updated_at) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    values = (
        uid,
        profile_id,
        data['name'].split()[0],
        data['name'].split()[1] if len(data['name'].split()) > 2 else "",
        data['name'].split()[-1],
        data.get('phone'),
        "Resume Summary Placeholder",
        datetime.now(),
        datetime.now()
    )

    cursor.execute(sql, values)
    resume_id = cursor.lastrowid
    conn.commit()
    cursor.close()
    conn.close()
    return resume_id
