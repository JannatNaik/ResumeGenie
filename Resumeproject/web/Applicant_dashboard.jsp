<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="java.sql.*, java.io.*, jakarta.servlet.*, jakarta.servlet.http.*, jakarta.servlet.annotation.*" %>

<%
    // Check if user is logged in by verifying session
    if (session == null || session.getAttribute("fullname") == null) {
        response.sendRedirect("Signin.jsp");
        return;
    }

    // Handle logout request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("logout") != null) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
// Retrieve session attributes
    String fullName = (String) session.getAttribute("fullname");
    String contactNo = (String) session.getAttribute("contact_no");
    String location = (String) session.getAttribute("location");
    Integer experience = (Integer) session.getAttribute("experience");
    String skills = (String) session.getAttribute("skills");
    String education = (String) session.getAttribute("education");
    String linkedinUrl = (String) session.getAttribute("linkedin");
    String githubUrl = (String) session.getAttribute("github");
    String profileImageUrl = (String) session.getAttribute("profile_image_url");

    // Provide default values if data is missing
    if (profileImageUrl == null || profileImageUrl.trim().isEmpty()) {
        profileImageUrl = "https://i.imgur.com/G1pXs7D.jpg";  // Placeholder image
    }

    // Print session data for debugging purposes
    System.out.println("Full Name: " + fullName);
    System.out.println("Contact No: " + contactNo);
    System.out.println("Location: " + location);
    System.out.println("Experience: " + experience);
    System.out.println("Skills: " + skills);
    System.out.println("Education: " + education);
    System.out.println("LinkedIn URL: " + linkedinUrl);
    System.out.println("GitHub URL: " + githubUrl);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Profile Card</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
        }

        .profile-container {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            height: 100vh;
            width: 100%;
        }

        .profile-card {
            background-color: #fff;
            width: 400px;
            height: 95%;
            border-radius: 0 15px 15px 0;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            overflow-y: auto;
        }

        .profile-card img {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            border: 3px solid grey;
            margin-top: 0px;
        }

        .namediv {
            height: 40px;
            width: 200px;
            background-color: black;
            margin: 10px auto;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 6px;
        }

        .namediv h2 {
            font-size: 18px;
            margin: 0;
            color: white;
        }

        .detail {
            display: flex;
            align-items: center;
            margin-top: 25px;
            margin-left: 20px;
            font-size: 20px;
            color: #555;
        }
        .detail a {
    text-decoration: none;
    color: #2c7be5;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    display: block; /* Make it block-level to apply ellipsis properly */
    width: 100%; /* Ensure the link respects the container width */
    max-width: 300px; /* Optional: restrict width if needed */
}


        .detail1 {
            display: flex;
            align-items: center;
            margin-top: 40px;
            margin-left: 20px;
            font-size: 20px;
            color: #555;
        }

        .detail1 i,
        .detail i {
            margin-right: 10px;
            color: #2c7be5;
            width: 20px;
            text-align: center;
        }

        .profile-card a {
            color: black;
            text-decoration: none;
        }

        .buttons {
            margin-top: 55px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

       
        .buttons {
            margin-top: 45px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .action-button {
    color: #2c7be5; /* Icon and text color */
    text-decoration: none;
    padding: 10px 15px; /* Reduced padding */
    border-radius: 50px; /* Rounded edges */
    font-size: 17px;
    display: flex;
    align-items: center;
    background-color: transparent; /* Remove background color */
    justify-content: flex-start;
    border: 2px solid #2c7be5; /* Add border */
    transition: color 0.3s ease, border-color 0.3s ease;
}

.action-button:hover {
    color: #1a5ed9; /* Change text and icon color on hover */
    border-color: #1a5ed9; /* Change border color on hover */
}

.action-button i {
    margin-right: 10px; /* Smaller margin between icon and text */
    font-size: 22px;
}

.logout-button {
    border-color: #e74c3c; /* Logout button border color */
    color: #e74c3c; /* Logout button text and icon color */
}

.logout-button:hover {
    color: #c0392b; /* Change logout button color on hover */
    border-color: #c0392b; /* Change logout button border color on hover */
}
.link-ellipsis {
    display: block;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    max-width: 100%; /* Ensures the text is confined to the container width */
}


    </style>
</head>
<body>


<div class="profile-container">
    <div class="profile-card">
        <img src="<%= profileImageUrl %>" alt="User Profile">
        <div class="namediv">
            <h2><%= fullName != null ? fullName : "Full Name Not Set" %></h2>
        </div>

        <div class="detail1"><i class="fas fa-briefcase"></i> <%= experience != null ? experience + " years" : "Experience Not Set" %></div>
        <div class="detail"><i class="fas fa-phone-alt"></i> <%= contactNo != null ? contactNo : "Contact Not Set" %></div>
        <div class="detail"><i class="fas fa-map-marker-alt"></i> <%= location != null ? location : "Location Not Set" %></div>
        <div class="detail"><i class="fas fa-code"></i> <%= skills != null ? skills : "Skills Not Set" %></div>
        <div class="detail"><i class="fas fa-graduation-cap"></i> <%= education != null ? education : "Education Not Set" %></div>

        <div class="detail">
            <i class="fab fa-linkedin"></i>
            <a href="<%= linkedinUrl != null ? linkedinUrl : "#" %>" target="_blank" class="link-ellipsis" title="<%= linkedinUrl != null ? linkedinUrl : "No LinkedIn URL Provided" %>">
                <%= linkedinUrl != null ? linkedinUrl : "No LinkedIn URL Provided" %>
            </a>
        </div>

        <div class="detail">
            <i class="fab fa-github"></i>
            <a href="<%= githubUrl != null ? githubUrl : "#" %>" target="_blank" class="link-ellipsis" title="<%= githubUrl != null ? githubUrl : "No GitHub URL Provided" %>">
                <%= githubUrl != null ? githubUrl : "No GitHub URL Provided" %>
            </a>
        </div>

        <div class="buttons">
            <a href="Resume_making.jsp" class="action-button"><i class="fas fa-file-alt"></i> Create Resume</a>
            <a href="Profile_page_applicant.jsp" class="action-button"><i class="fas fa-user-edit"></i> Edit Profile</a>
            <form method="post" style="width: 100%; display: flex; justify-content: center;">
                <button type="submit" name="logout" class="action-button logout-button">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
