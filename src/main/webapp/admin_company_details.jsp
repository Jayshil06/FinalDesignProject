<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
            padding: 24px;
            animation: fadeInBody 0.7s ease;
        }

        h2 {
            text-align: center;
            color: #ffdd57;
            margin-bottom: 30px;
            animation: slideDown 0.7s ease;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(6px);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            animation: fadeInUp 0.8s ease;
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: left;
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
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .btn:hover {
            background-color: #187bcd;
            transform: translateY(-1px) scale(1.02);
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
            margin-top: 12px;
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        @media (max-width: 768px) {
            body {
                padding: 12px;
            }
        }

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-18px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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


<hr>
<div style="text-align:center;">
    <form action="admin_home_content.jsp" style="display:inline;">
        <input type="submit" value="Back" class="btn">
    </form>
</div>

</body>
</html>
