<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Signup Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .divider:after, .divider:before {
            content: "";
            flex: 1;
            height: 1px;
            background: #eee;
        }
        .h-custom {
            height: calc(100% - 73px);
        }
        @media (max-width: 450px) {
            .h-custom {
                height: 100%;
            }
        }
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

    <script>
        function validateForm() {
            var pass = document.forms["signupForm"]["Password_m"].value;
            var confirm = document.forms["signupForm"]["Password_c"].value;
            if (pass !== confirm) {
                alert("Passwords do not match.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

<a href="index.jsp" class="home-button"><i class="fas fa-home"></i> Home</a>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password_m = request.getParameter("Password_m");
        String password_c = request.getParameter("Password_c");
        String role = request.getParameter("role");

        if (!password_m.equals(password_c)) {
            message = "<div class='alert alert-warning'>Passwords do not match.</div>";
        } else {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Resume", "root", "");

                String sql = "INSERT INTO user (fullname, email, Password_m, role) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                stmt.setString(1, fullname);
                stmt.setString(2, email);
                stmt.setString(3, password_m);
                stmt.setString(4, role);

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    rs = stmt.getGeneratedKeys();
                    int uid = -1;
                    if (rs.next()) {
                        uid = rs.getInt(1);
                    }

                    session.setAttribute("uid", uid);
                    session.setAttribute("fullname", fullname);
                    session.setAttribute("email", email);
                    session.setAttribute("role", role);

                    if ("Applicant".equalsIgnoreCase(role)) {
                        response.sendRedirect("Profile_page_applicant.jsp");
                    } else {
                        response.sendRedirect("Profile_page_hr.jsp");
                    }
                    return;
                } else {
                    message = "<div class='alert alert-danger'>Failed to register. Try again.</div>";
                }
            } catch (SQLIntegrityConstraintViolationException e) {
                message = "<div class='alert alert-warning'>Email already exists.</div>";
            } catch (Exception e) {
                message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    }
%>

<section class="vh-100">
    <div class="container-fluid h-custom">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <!-- Left image panel -->
            <div class="col-md-9 col-lg-6 col-xl-5">
                <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp"
                     class="img-fluid" alt="Sample image">
            </div>

            <!-- Right form panel -->
            <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                <%= message %>

                <form name="signupForm" method="post" onsubmit="return validateForm();">
                    <h3 class="text-center mb-4">Create Account</h3>

                    <div class="form-outline mb-3">
                        <input type="text" name="fullname" class="form-control form-control-lg" placeholder="Full Name" required />
                        <label class="form-label">Full Name</label>
                    </div>

                    <div class="form-outline mb-3">
                        <input type="email" name="email" class="form-control form-control-lg" placeholder="Email Address" required />
                        <label class="form-label">Email</label>
                    </div>

                    <div class="form-outline mb-3">
                        <input type="password" name="Password_m" class="form-control form-control-lg" placeholder="Password" required />
                        <label class="form-label">Password</label>
                    </div>

                    <div class="form-outline mb-3">
                        <input type="password" name="Password_c" class="form-control form-control-lg" placeholder="Confirm Password" required />
                        <label class="form-label">Confirm Password</label>
                    </div>

                    <div class="form-outline mb-3">
                        <select name="role" class="form-select form-select-lg" required>
                            <option value="">Select Role</option>
                            <option value="Applicant">Applicant</option>
                            <option value="HR">HR</option>
                        </select>
                        <label class="form-label">Role</label>
                    </div>

                    <div class="text-center text-lg-start mt-4 pt-2">
                        <button type="submit" class="btn btn-primary btn-lg"
                                style="padding-left: 2.5rem; padding-right: 2.5rem;">Sign Up</button>
                        <p class="small fw-bold mt-2 pt-1 mb-0">Already have an account?
                            <a href="Signin.jsp" class="link-danger">Login</a>
                        </p>
                    </div>
                </form>

            </div>
        </div>
    </div>
</section>

</body>
</html>
