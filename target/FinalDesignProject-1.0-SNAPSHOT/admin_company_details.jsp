<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String formType = request.getParameter("form");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Company Details</title>
    <link rel="stylesheet" href="index.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f5f5f5;
            padding: 40px;
        }

        h2 {
            text-align: center;
            color: #ffdd57;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(6px);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            background-color: rgba(0, 0, 0, 0.2);
            color: #ffdd57;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        .btn {
            background-color: #1e90ff;
            color: white;
            padding: 10px 18px;
            margin: 8px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background-color: #187bcd;
        }

        .form-section {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(6px);
            padding: 25px;
            margin-top: 30px;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.2);
        }

        .form-section h3 {
            color: #ffdd57;
            margin-bottom: 15px;
        }

        .form-section input, .form-section textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 10px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .form-nav {
            text-align: center;
            margin: 30px 0;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: #00ff88;
            background: rgba(0, 0, 0, 0.2);
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        p[style*="color:red"] {
            text-align: center;
            background: rgba(255, 0, 0, 0.1);
            padding: 12px;
            border-radius: 10px;
        }

        hr {
            margin-top: 40px;
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }
    </style>
</head>
<body>

<%
    String msg = (String) session.getAttribute("message");
    if (msg != null) {
%>
    <div class="message"><%= msg %></div>
<%
        session.removeAttribute("message");
    }
%>

<h2>📋 Registered Companies</h2>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM companies ORDER BY company_id ASC");

        if (!rs.isBeforeFirst()) {
%>
    <p style="color:red;">❌ No company registered yet by admin.</p>
<%
        } else {
%>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Job Description</th>
            <th>Details</th>
            <th>Posted Date</th>
        </tr>
<%
            while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("company_id") %></td>
            <td><%= rs.getString("company_name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("job_description") %></td>
            <td><%= rs.getString("details") %></td>
            <td><%= rs.getTimestamp("posted_date") %></td>
        </tr>
<%
            }
%>
    </table>
<%
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!-- Buttons always visible -->
<div class="form-nav">
    <form method="get" style="display:inline;">
        <input type="hidden" name="form" value="add">
        <input type="submit" value="➕ Add New Company" class="btn">
    </form>
    <form method="get" style="display:inline;">
        <input type="hidden" name="form" value="update">
        <input type="submit" value="🔁 Update Company" class="btn">
    </form>
    <form method="get" style="display:inline;">
        <input type="hidden" name="form" value="delete">
        <input type="submit" value="❌ Delete Company" class="btn">
    </form>
</div>

<% if ("add".equals(formType)) { %>
    <div class="form-section">
        <h3>➕ Add New Company</h3>
        <form action="AddCompanyServlet" method="post">
            Name: <input type="text" name="company_name" required><br>
            Email: <input type="email" name="email"><br>
            Job Description: <textarea name="job_description"></textarea><br>
            Details: <textarea name="details"></textarea><br>
            <input type="submit" value="Add Company" class="btn">
        </form>
        <form method="get">
            <input type="submit" value="❌ Close Form" class="btn">
        </form>
    </div>
<% } else if ("update".equals(formType)) { %>
    <div class="form-section">
        <h3>🔁 Update Company</h3>
        <form action="UpdateCompanyServlet" method="post">
            Company ID (to update): <input type="number" name="company_id" required><br>
            Name: <input type="text" name="company_name"><br>
            Email: <input type="email" name="email"><br>
            Job Description: <textarea name="job_description"></textarea><br>
            Details: <textarea name="details"></textarea><br>
            <input type="submit" value="Update Company" class="btn">
        </form>
        <form method="get">
            <input type="submit" value="❌ Close Form" class="btn">
        </form>
    </div>
<% } else if ("delete".equals(formType)) { %>
    <div class="form-section">
        <h3>❌ Delete Company</h3>
        <form action="DeleteCompanyServlet" method="post">
            Company ID (to delete): <input type="number" name="company_id" required><br>
            <input type="submit" value="Delete Company" class="btn" onclick="return confirm('Are you sure you want to delete this company?');">
        </form>
        <form method="get">
            <input type="submit" value="❌ Close Form" class="btn">
        </form>
    </div>
<% } %>

<hr>
<div style="text-align:center;">
    <form action="admin_home_content.jsp" style="display:inline;">
        <input type="submit" value="Back" class="btn">
    </form>
</div>

</body>
</html>
