<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f5f5f5;
            padding: 40px;
        }

        .profile-container {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(6px);
            padding: 30px;
            border-radius: 15px;
            max-width: 600px;
            margin: auto;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.3);
        }

        h3 {
            text-align: center;
            color: #ffdd57;
            margin-bottom: 25px;
        }

        p {
            font-size: 16px;
            margin: 10px 0;
            padding: 10px;
            border-radius: 8px;
            background-color: rgba(255, 255, 255, 0.05);
        }

        strong {
            color: #ffdd57;
        }

        a {
            color: #1e90ff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .no-data {
            text-align: center;
            padding: 20px;
            background-color: rgba(255, 0, 0, 0.1);
            color: #ff6b6b;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="profile-container">
<%
    ResultSet rs = (ResultSet) request.getAttribute("student");
    if (rs != null) {
%>
        <h3>🎓 Your Profile</h3>
        <p><strong>Enrollment No:</strong> <%= rs.getString("enrollment_no") %></p>
        <p><strong>Full Name:</strong> <%= rs.getString("full_name") %></p>
        <p><strong>Email:</strong> <%= rs.getString("email") %></p>
        <p><strong>DOB:</strong> <%= rs.getDate("dob") %></p>
        <p><strong>Branch:</strong> <%= rs.getString("branch") %></p>
        <p><strong>Contact:</strong> <%= rs.getString("contact") %></p>
        <p><strong>Gender:</strong> <%= rs.getString("gender") %></p>
        <p><strong>Address:</strong> <%= rs.getString("address") %></p>
        <a href="DownloadResumeServlet?enrollment_no=<%= rs.getString("enrollment_no") %>">
          Download Resume
        </a>

<%
    } else {
%>
        <div class="no-data">❌ No profile data available.</div>
<%
    }
%>
    </div>
</body>
</html>
