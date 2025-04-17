<%@ page import="java.sql.*, java.io.*, jakarta.servlet.http.*, jakarta.servlet.annotation.*, java.nio.file.Paths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="jakarta.servlet.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    HttpSession sessionObj = request.getSession(false);
    String email = (sessionObj != null) ? (String) sessionObj.getAttribute("email") : null;

    int uid = 0;
    int profile_id = 0;
    String errorMessage = null;

    if (email == null) {
        response.sendRedirect("Signup.jsp");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Resume", "root", "");

        // Get UID
        PreparedStatement ps = conn.prepareStatement("SELECT uid FROM user WHERE email = ?");
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            uid = rs.getInt("uid");
            sessionObj.setAttribute("uid", uid);
        } else {
            errorMessage = "User not found.";
        }
        rs.close();
        ps.close();

        // Get profile_id
        PreparedStatement psProfile = conn.prepareStatement("SELECT profile_id FROM user_profile WHERE uid = ?");
        psProfile.setInt(1, uid);
        ResultSet rsProfile = psProfile.executeQuery();
        if (rsProfile.next()) {
            profile_id = rsProfile.getInt("profile_id");
        } else {
            errorMessage = "User profile not found.";
        }
        rsProfile.close();
        psProfile.close();

        // Only proceed if POST method
        if (errorMessage == null && "POST".equalsIgnoreCase(request.getMethod())) {
            Part imagePart = request.getPart("profile_img");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = application.getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String filePath = uploadPath + File.separator + fileName;
            imagePart.write(filePath);

            String relativePath = "uploads/" + fileName;

            // Insert into database
            PreparedStatement insertPs = conn.prepareStatement("INSERT INTO User_profile_img (uid, profile_id, img) VALUES (?, ?, ?)");
            insertPs.setInt(1, uid);
            insertPs.setInt(2, profile_id);
            insertPs.setString(3, relativePath);
            int result = insertPs.executeUpdate();
            insertPs.close();

            if (result > 0) {
                response.sendRedirect("Applicant_dashboard.jsp");
                return;
            } else {
                errorMessage = "Failed to save image to database.";
            }
        }

        conn.close();
    } catch (Exception e) {
        errorMessage = "Error: " + e.getMessage();
        e.printStackTrace(new PrintWriter(out));
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Profile Image</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f1f4f9;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
        }

        .card {
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        .card img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }

        input[type="file"] {
            display: none;
        }

        label {
            display: inline-block;
            padding: 10px 20px;
            background-color: #2c7be5;
            color: white;
            border-radius: 50px;
            cursor: pointer;
            margin-bottom: 20px;
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

        .error {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="card">
    <h2>Upload Your Profile Image</h2>

    <% if (errorMessage != null) { %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

    <form action="Profile_img.jsp" method="POST" enctype="multipart/form-data">
        <div>
            <img id="preview" src="uploads/default-avatar.jpg" alt="Profile Image">
        </div>

        <label for="profile_img">Choose an Image</label>
        <input type="file" name="profile_img" id="profile_img" accept="image/*" onchange="previewImage(event)" required>

        <input type="submit" value="Upload Image">
    </form>
</div>

<script>
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function () {
            document.getElementById('preview').src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>

</body>
</html>
