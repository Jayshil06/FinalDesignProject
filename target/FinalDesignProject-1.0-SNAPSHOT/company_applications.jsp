<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*,javax.servlet.http.*,javax.servlet.annotation.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Company Applications</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            padding: 40px;
            text-align: center;
        }

        h2 {
            font-size: 32px;
            color: #f9ca24;
            margin-bottom: 40px;
        }

        h3 {
            font-size: 24px;
            color: #00bcd4;
            margin-top: 40px;
        }

        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 90%;
            background-color: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(4px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.25);
            border-radius: 8px;
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #f0f0f0;
        }

        th {
            background-color: #00bcd4;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: rgba(255, 255, 255, 0.04);
        }

        p {
            font-size: 16px;
            margin-top: 10px;
        }

        form {
            margin-top: 40px;
        }

        input[type="submit"] {
            padding: 10px 25px;
            background-color: #f9ca24;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #f1c40f;
            transform: scale(1.05);
        }

        hr {
            border: 0;
            height: 1px;
            background: rgba(255, 255, 255, 0.2);
            margin: 50px 0;
        }

        .error {
            color: #ff7675;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>📥 Company-wise Applications</h2>

    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String companyQuery = "SELECT * FROM companies";
            ps = conn.prepareStatement(companyQuery);
            rs = ps.executeQuery();

            boolean hasCompanies = false;

            while (rs.next()) {
                hasCompanies = true;
                int companyId = rs.getInt("company_id");
                String companyName = rs.getString("company_name");

                out.println("<hr>");
                out.println("<h3>🏢 " + companyName + "</h3>");

                String appQuery = "SELECT a.enrollment_no, s.full_name, s.email, a.application_date " +
                                  "FROM applications a JOIN students s ON a.enrollment_no = s.enrollment_no " +
                                  "WHERE a.company_id = ?";
                PreparedStatement appPs = conn.prepareStatement(appQuery);
                appPs.setInt(1, companyId);
                ResultSet appRs = appPs.executeQuery();

                int count = 0;
                out.println("<table><tr><th>Enrollment No</th><th>Student Name</th><th>Email</th><th>Applied On</th></tr>");
                while (appRs.next()) {
                    count++;
                    out.println("<tr>");
                    out.println("<td>" + appRs.getString("enrollment_no") + "</td>");
                    out.println("<td>" + appRs.getString("full_name") + "</td>");
                    out.println("<td>" + appRs.getString("email") + "</td>");
                    out.println("<td>" + appRs.getTimestamp("application_date") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                out.println("<p><strong>Total Applications:</strong> " + count + "</p>");

                appRs.close();
                appPs.close();
            }

            if (!hasCompanies) {
                out.println("<p class='error'>❌ No companies registered yet.</p>");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        }
    %>

    <form action="admin_home_content.jsp">
        <input type="submit" value="⬅️ Back to Admin Home">
    </form>
</body>
</html>
