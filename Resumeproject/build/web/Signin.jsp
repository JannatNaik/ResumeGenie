<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String msg = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String inputRole = request.getParameter("role").trim();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Resume", "root", "");

            // Join user and user_profile based on uid
            String sql = "SELECT u.uid, u.fullname AS name, u.email, u.role, " +
                         "up.profile_id, up.full_name, up.contact_no, up.location, up.experience, " +
                         "up.skills, up.education, up.linkedin_url, up.github_url " +
                         "FROM user u " +
                         "LEFT JOIN user_profile up ON u.uid = up.uid " +
                         "WHERE u.email = ? AND u.Password_m = ? AND u.role = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.setString(3, inputRole);

            rs = stmt.executeQuery();

            if (rs.next()) {
                // From user table
                int uid = rs.getInt("uid");
                String fullname = rs.getString("name");
                String role = rs.getString("role");

                // From user_profile table
                String profile_fullname = rs.getString("full_name");
                String contact_no = rs.getString("contact_no");
                String location = rs.getString("location");
                int experience = rs.getInt("experience");
                String skills = rs.getString("skills");
                String education = rs.getString("education");
                String linkedin = rs.getString("linkedin_url");
                String github = rs.getString("github_url");

                // Store all values in session
                session.setAttribute("uid", uid);
                session.setAttribute("fullname", fullname);
                session.setAttribute("email", email);
                session.setAttribute("role", role);
                session.setAttribute("profile_fullname", profile_fullname);
                session.setAttribute("contact_no", contact_no);
                session.setAttribute("location", location);
                session.setAttribute("experience", experience);
                session.setAttribute("skills", skills);
                session.setAttribute("education", education);
                session.setAttribute("linkedin", linkedin);
                session.setAttribute("github", github);

                // Redirect based on role
                if ("Admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("Admin_dashboard.jsp");
                } else if ("HR".equalsIgnoreCase(role)) {
                    response.sendRedirect("Hr_Dashboard.jsp");
                } else if ("Applicant".equalsIgnoreCase(role)) {
                    response.sendRedirect("Applicant_dashboard.jsp");
                } else {
                    msg = "<div class='alert alert-danger'>Unknown role found in database.</div>";
                }
                return;
            } else {
                msg = "<div class='alert alert-danger'>Invalid email, password, or role.</div>";
            }

        } catch (Exception e) {
            msg = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign In</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .home-button {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 24px;
            color: #007bff;
            text-decoration: none;
            transition: 0.3s;
        }

        .home-button:hover {
            color: #0056b3;
        }
    </style>
</head>
<body>

<a href="index.jsp" class="home-button"><i class="fas fa-home"></i> Home</a>

<section class="vh-100">
    <div class="container-fluid h-100">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-md-9 col-lg-6 col-xl-5">
                <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp"
                     class="img-fluid" alt="Sample image">
            </div>
            <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">

                <!-- Display any message -->
                <%= msg %>

                <!-- Login Form -->
                <form method="post">
                    <h3 class="text-center mb-4">Sign In</h3>

                    <!-- Email -->
                    <div class="form-outline mb-4">
                        <input type="email" name="email" class="form-control form-control-lg"
                               placeholder="Enter a valid email address" required />
                        <label class="form-label">Email address</label>
                    </div>

                    <!-- Password -->
                    <div class="form-outline mb-3">
                        <input type="password" name="password" class="form-control form-control-lg"
                               placeholder="Enter password" required />
                        <label class="form-label">Password</label>
                    </div>

                    <!-- Role -->
                    <div class="form-outline mb-3">
                        <select name="role" class="form-select form-select-lg" required>
                            <option value="">Select Role</option>
                            <option value="Applicant">Applicant</option>
                            <option value="HR">HR</option>
                            <option value="Admin">Admin</option>
                        </select>
                        <label class="form-label">Role</label>
                    </div>

                    <!-- Remember Me & Forgot -->
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="form-check mb-0">
                            <input class="form-check-input me-2" type="checkbox" />
                            <label class="form-check-label">Remember me</label>
                        </div>
                        <a href="#" class="text-body">Forgot password?</a>
                    </div>

                    <!-- Submit -->
                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary btn-lg px-5">Login</button>
                        <p class="small fw-bold mt-2 pt-1 mb-0">Don't have an account?
                            <a href="Signup.jsp" class="link-danger">Register</a>
                        </p>
                    </div>
                </form>

            </div>
        </div>
    </div>
</section>

</body>
</html>
