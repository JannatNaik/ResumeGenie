<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%
    String hrId = (String) session.getAttribute("uid");
    if (hrId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>HR Dashboard</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .form-section { margin-bottom: 30px; }
        label { display: block; margin-top: 10px; }
    </style>
</head>
<body>
    <h2>Welcome, HR</h2>

    <!-- Form to enter Job Description -->
    <div class="form-section">
        <h3>Enter Job Description</h3>
        <form action="SaveJobDescriptionServlet" method="post">
            <label>Job Title: <input type="text" name="job_title" required /></label>
            <label>Required Skills (comma-separated): <input type="text" name="required_skills" required /></label>
            <label>Minimum Experience (years): <input type="number" name="min_experience" required /></label>
            <label>Minimum Resume Score (optional): <input type="number" name="min_resume_score" /></label>
            <input type="submit" value="Save Job Description" />
        </form>
    </div>

    <!-- Form to Upload Multiple Resumes -->
    <div class="form-section">
        <h3>Upload Resumes</h3>
        <form action="UploadResumesServlet" method="post" enctype="multipart/form-data">
            <input type="file" name="resumes" multiple required />
            <input type="submit" value="Upload & Analyze" />
        </form>
    </div>

    <!-- Show Results -->
    <div class="form-section">
        <h3>Best Matching Resumes</h3>
        <%
            List<Map<String, String>> matchedResumes = (List<Map<String, String>>) request.getAttribute("matchedResumes");
            if (matchedResumes != null) {
                for (Map<String, String> resume : matchedResumes) {
        %>
            <div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
                <strong>Name:</strong> <%= resume.get("name") %><br>
                <strong>Email:</strong> <%= resume.get("email") %><br>
                <strong>Score:</strong> <%= resume.get("score") %><br>
                <strong>Skills:</strong> <%= resume.get("skills") %>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>
