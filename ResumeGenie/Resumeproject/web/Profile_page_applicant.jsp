<%@ page import="java.sql.*, java.io.*, jakarta.servlet.*, jakarta.servlet.http.*, jakarta.servlet.annotation.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>

<%
    HttpSession sessionObj = request.getSession(false);
    String email = (sessionObj != null) ? (String) sessionObj.getAttribute("email") : null;

    if (email == null) {
        response.sendRedirect("Signup.jsp");
        return;
    }

    int uid = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Resume", "root", "");

        PreparedStatement ps = conn.prepareStatement("SELECT uid FROM user WHERE email = ?");
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            uid = rs.getInt("uid");
            sessionObj.setAttribute("uid", uid);
        } else {
            response.sendRedirect("Signup.jsp");
            return;
        }
        rs.close();
        ps.close();

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            request.setCharacterEncoding("UTF-8");

            String fullName = request.getParameter("full_name");
            String contactNo = request.getParameter("contact_no");
            String location = request.getParameter("location");
            String experienceStr = request.getParameter("experience");
            String skills = request.getParameter("skills");
            String education = request.getParameter("education");
            String linkUrl = request.getParameter("link_url");
            String githubUrl = request.getParameter("github_url");

            int experience = (experienceStr != null && !experienceStr.trim().isEmpty())
                ? Integer.parseInt(experienceStr.trim())
                : 0;

            PreparedStatement insertPs = conn.prepareStatement(
                "INSERT INTO user_profile(uid, full_name, contact_no, location, experience, skills, education, linkedin_url, github_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            insertPs.setInt(1, uid);
            insertPs.setString(2, fullName);
            insertPs.setString(3, contactNo);
            insertPs.setString(4, location);
            insertPs.setInt(5, experience);
            insertPs.setString(6, skills);
            insertPs.setString(7, education);
            insertPs.setString(8, linkUrl);
            insertPs.setString(9, githubUrl);
            insertPs.executeUpdate();

            insertPs.close();
            conn.close();

            // Redirect to applicant dashboard
            response.sendRedirect("Signin.jsp");
            return;
        }

    } catch (Exception e) {
        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applicant Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f1f4f9;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .card {
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
            max-width: 600px;
            width: 100%;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 12px;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        input[type="submit"] {
            background-color: #2c7be5;
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            border-radius: 8px;
            margin-top: 20px;
            width: 100%;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #1a5ed9;
        }
    </style>
</head>
<body>

    <div class="card">
        <h2>Complete Your Profile</h2>
        <form action="Profile_page_applicant.jsp" method="POST">
            <label>Full Name:</label>
            <input type="text" name="full_name" required>

            <label>Contact No:</label>
            <input type="text" name="contact_no" required>

            <label>Location:</label>
            <input type="text" name="location" required>

            <label>Experience (Years):</label>
            <input type="number" name="experience" min="0">

            <label>Skills:</label>
            <textarea name="skills" required></textarea>

            <label>Education:</label>
            <input type="text" name="education" required>

            <label>LinkedIn URL:</label>
            <input type="text" name="link_url">

            <label>GitHub URL:</label>
            <input type="text" name="github_url">

            <input type="submit" value="Submit Profile">
        </form>
    </div>

</body>
</html>
