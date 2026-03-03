<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Companies</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f5f5f5;
            padding: 40px;
        }

        h3 {
            text-align: center;
            color: #ffdd57;
            margin-bottom: 25px;
        }

        .table-container {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(6px);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.3);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background-color: rgba(255, 255, 255, 0.05);
        }

        th, td {
            padding: 14px 18px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            background-color: rgba(255, 255, 255, 0.1);
            color: #ffdd57;
        }

        tr:nth-child(even) {
            background-color: rgba(255, 255, 255, 0.03);
        }

        a {
            color: #1e90ff;
            font-weight: bold;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .error-msg {
            color: #ff6b6b;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>

<h3>Available Companies</h3>
<div class="table-container">
<table>
    <tr>
        <th>ID</th>
        <th>Company Name</th>
        <th>Job Description</th>
        <th>Details</th>
    </tr>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/design_engineering_portal", 
            "root", 
            "root"
        );
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM companies ORDER BY company_id ASC");

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("company_id") %></td>
        <td><%= rs.getString("company_name") %></td>
        <td><%= rs.getString("job_description") %></td>
        <td><a href="company_details.jsp?id=<%= rs.getInt("company_id") %>" target="_blank">View Details</a></td>
    </tr>
<%
        }
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
%>
    <tr><td colspan="4" class="error-msg"> Error: <%= e.getMessage() %></td></tr>
<%
    }
%>
</table>
</div>

</body>
</html>
