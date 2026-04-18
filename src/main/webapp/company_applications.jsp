<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*,jakarta.servlet.http.*,jakarta.servlet.annotation.*" %>
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
            animation: fadeInBody 0.7s ease;
        }

        h2 {
            font-size: 32px;
            color: #f9ca24;
            margin-bottom: 40px;
            animation: slideDown 0.7s ease;
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
            animation: fadeInUp 0.8s ease;
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

        tr:hover td {
            background-color: rgba(255, 255, 255, 0.06);
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

                String appQuery = "SELECT a.enrollment_no, s.full_name, s.email, a.application_date, a.status " +
                                   "FROM applications a JOIN students s ON a.enrollment_no = s.enrollment_no " +
                                   "WHERE a.company_id = ?";
                PreparedStatement appPs = conn.prepareStatement(appQuery);
                appPs.setInt(1, companyId);
                ResultSet appRs = appPs.executeQuery();

                int count = 0;
                out.println("<table><tr><th>Enrollment No</th><th>Student Name</th><th>Email</th><th>Applied On</th><th>Status</th><th>Action</th></tr>");
                while (appRs.next()) {
                    count++;
                    String enrollment = appRs.getString("enrollment_no");
                    String status = appRs.getString("status");
                    if (status == null) status = "Applied";
                    
                    out.println("<tr>");
                    out.println("<td>" + enrollment + "</td>");
                    out.println("<td>" + appRs.getString("full_name") + "</td>");
                    out.println("<td>" + appRs.getString("email") + "</td>");
                    out.println("<td>" + appRs.getTimestamp("application_date") + "</td>");
                    out.println("<td>" + status + "</td>");
                    out.println("<td>");
                    out.println("<form action='UpdateApplicationStatusServlet' method='post' style='display:inline; margin:0;'>");
                    out.println("<input type='hidden' name='enrollment_no' value='" + enrollment + "'>");
                    out.println("<input type='hidden' name='company_id' value='" + companyId + "'>");
                    out.println("<select name='status' style='padding:5px; border-radius:4px;'>");
                    out.println("<option value='Applied' " + (status.equals("Applied") ? "selected" : "") + ">Applied</option>");
                    out.println("<option value='Shortlisted' " + (status.equals("Shortlisted") ? "selected" : "") + ">Shortlisted</option>");
                    out.println("<option value='Placed' " + (status.equals("Placed") ? "selected" : "") + ">Placed</option>");
                    out.println("<option value='Rejected' " + (status.equals("Rejected") ? "selected" : "") + ">Rejected</option>");
                    out.println("</select>");
                    out.println("<input type='number' name='salary_offered' placeholder='Salary' style='width:80px; padding:5px; border-radius:4px;'>");
                    out.println("<input type='submit' value='Update' style='padding:5px 10px; background:#00b894; color:white; border:none; border-radius:4px; cursor:pointer;'>");
                    out.println("</form>");
                    out.println("</td>");
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
