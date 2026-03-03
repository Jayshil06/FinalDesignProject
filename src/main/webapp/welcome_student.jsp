<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String studentEmail = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
    <style>
        body {
            margin: 0;
            padding: 40px;
            font-family: 'Poppins', sans-serif;
            background-color: transparent;
            color: #ecf0f1;
        }
        .welcome-box {
            background: rgba(255, 255, 255, 0.05);
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            margin: auto;
        }
        .welcome-box h1 {
            font-size: 28px;
            color: #00cec9;
        }
        .welcome-box p {
            font-size: 18px;
            color: #dfe6e9;
        }
    </style>
</head>
<body>
    <div class="welcome-box">
        <h1>Welcome to the Student Dashboard 🎓</h1>
        <p>Hello, <strong><%= studentEmail %></strong>!</p>
        <p>You can view your profile, explore companies, and track your applications from here.</p>
        <p>Use the navigation menu above to get started.</p>
    </div>
</body>
</html>
