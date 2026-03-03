<%@ page import="java.sql.*, javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications</title>
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
            background-color: rgba(255, 255, 255, 0.05);
            margin-top: 10px;
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

        .no-data {
            text-align: center;
            padding: 20px;
            color: #ccc;
        }
    </style>
</head>
<body>

<h3> My Applications</h3>

<div class="table-container">
<table>
    <tr>
        <th>Company Name</th>
        <th>Job Description</th>
        <th>Application Date</th>
    </tr>
<%
    String enrollmentNo = (String) session.getAttribute("enrollment_no");

    if (enrollmentNo == null) {
%>
    <tr><td colspan='3' class="error-msg">You are not logged in. Please <a href='student_login.jsp'>login</a>.</td></tr>
<%
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String query = "SELECT c.company_name, c.job_description, a.application_date " +
                           "FROM applications a " +
                           "JOIN companies c ON a.company_id = c.company_id " +
                           "WHERE a.enrollment_no = ?";

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, enrollmentNo);
            ResultSet rs = stmt.executeQuery();

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
%>
    <tr>
        <td><%= rs.getString("company_name") %></td>
        <td><%= rs.getString("job_description") %></td>
        <td><%= rs.getTimestamp("application_date") %></td>
    </tr>
<%
            }
            if (!hasData) {
%>
    <tr><td colspan='3' class="no-data">No applications found.</td></tr>
<%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
%>
    <tr><td colspan='3' class="error-msg"> Error: <%= e.getMessage() %></td></tr>
<%
        }
    }
%>
</table>
</div>

</body>
</html>
