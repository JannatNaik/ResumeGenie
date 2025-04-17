<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation Bar</title>
    <!-- Font Awesome CDN for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .navbar {
            background-color: #333;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
        }
        .navbar a:hover {
            background-color: #575757;
            border-radius: 5px;
        }
        .navbar a i {
            margin-right: 8px;
        }
        .nav-links {
            display: flex;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
    <div class="nav-links">
        <a href="Signin.jsp"><i class="fas fa-sign-in-alt"></i> Sign In</a>
        <a href="Signup.jsp"><i class="fas fa-user-plus"></i> Sign Up</a>
        <a href="about.jsp"><i class="fas fa-info-circle"></i> About Us</a>
    </div>
</div>

</body>
</html>
