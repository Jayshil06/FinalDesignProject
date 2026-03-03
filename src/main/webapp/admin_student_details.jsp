<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.servlet.annotation.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Student Details</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            margin: 0;
            padding: 40px 30px;
        }

        h2 {
            color: #f9ca24;
            text-align: center;
            font-size: 34px;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(8px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.4);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            background-color: rgba(0, 188, 212, 0.2);
            color: #ffffff;
        }

        td {
            color: #e0e0e0;
        }

        a {
            color: #00bcd4;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .btn {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: white;
            padding: 8px 16px;
            margin: 3px 2px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .btn:hover {
            background: linear-gradient(135deg, #163357, #244a7c);
            transform: scale(1.03);
        }

        .form-section {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 25px;
            border-radius: 12px;
            margin: 30px auto;
            max-width: 700px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.35);
        }

        .form-section h3 {
            color: #f9ca24;
            margin-bottom: 20px;
        }

        .form-section input, 
        .form-section textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0 15px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            outline: none;
        }

        .form-section textarea {
            resize: vertical;
        }

        form {
            display: inline;
        }

        @media screen and (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }

            th {
                background-color: transparent;
                color: #f9ca24;
                font-weight: 600;
            }

            td {
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>

<h2>Student Details</h2>

<%
    String dbURL = "jdbc:mysql://localhost:3306/design_engineering_portal";
    String dbUser = "root";
    String dbPass = "root";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM students");
%>

<table>
    <tr>
        <th>Enrollment No</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>DOB</th>
        <th>Branch</th>
        <th>Contact</th>
        <th>Gender</th>
        <th>Address</th>
        <th>Resume</th>
        <th>Actions</th>
    </tr>
<%
    while(rs.next()){
%>
    <tr>
        <td><%= rs.getString("enrollment_no") %></td>
        <td><%= rs.getString("full_name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getDate("dob") %></td>
        <td><%= rs.getString("branch") %></td>
        <td><%= rs.getString("contact") %></td>
        <td><%= rs.getString("gender") %></td>
        <td><%= rs.getString("address") %></td>
        <td>
            <%
                String resumePath = rs.getString("resume_path");
                if (resumePath != null && !resumePath.trim().isEmpty()) {
            %>
                <a href="DownloadResumeServlet?enrollment_no=<%= rs.getString("enrollment_no") %>" target="_blank">Download</a>
            <%
                } else {
                    out.print("No Resume");
                }
            %>
        </td>
        <td>
            <form method="post">
                <input type="hidden" name="selected_enroll" value="<%= rs.getString("enrollment_no") %>">
                <input type="submit" name="action" value="Update" class="btn">
                <input type="submit" name="action" value="Delete" class="btn">
            </form>
        </td>
    </tr>
<%
    }
%>
</table>

<form method="get" action="admin_home_content.jsp">
    <input type="submit" value="Back to Admin Home" class="btn">
</form>

<%
    String selectedEnroll = request.getParameter("selected_enroll");
    String action = request.getParameter("action");

    if ("Update".equals(action)) {
%>
<div class="form-section">
    <h3>Update Student Details (Enrollment: <%= selectedEnroll %>)</h3>
    <form method="post" action="UpdateStudentServlet">
        <input type="hidden" name="enrollment_no" value="<%= selectedEnroll %>">
        Full Name: <input type="text" name="full_name"><br>
        Email: <input type="email" name="email"><br>
        DOB: <input type="date" name="dob"><br>
        Branch: <input type="text" name="branch"><br>
        Contact: <input type="text" name="contact"><br>
        Gender: <input type="text" name="gender"><br>
        Address: <textarea name="address"></textarea><br>
        <input type="submit" value="Update Student" class="btn">
    </form>
</div>
<%
    } else if ("Delete".equals(action)) {
%>
<div class="form-section">
    <h3>Confirm Delete for Enrollment: <%= selectedEnroll %></h3>
    <form method="post" action="DeleteStudentServlet">
        <input type="hidden" name="enrollment_no" value="<%= selectedEnroll %>">
        <input type="submit" value="Delete Student" class="btn" onclick="return confirm('Are you sure you want to delete this student?');">
    </form>
</div>
<%
    }

    rs.close();
    stmt.close();
    conn.close();
} catch(Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}
%>

</body>
</html>
