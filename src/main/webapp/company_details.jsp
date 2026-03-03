<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String companyId = request.getParameter("id");
    if (companyId == null) {
        out.println("<p>No company selected.</p>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Details</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #fff;
            padding: 40px;
        }

        .container {
            max-width: 800px;
            margin: auto;
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(8px);
            border-radius: 15px;
            padding: 30px 40px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.4);
        }

        h2 {
            color: #ffdd57;
            font-size: 28px;
            margin-bottom: 20px;
        }

        p {
            line-height: 1.8;
            margin-bottom: 15px;
        }

        strong {
            color: #ffd700;
        }

        .button-group {
            margin-top: 30px;
            display: flex;
            gap: 15px;
        }

        .apply-btn, .back-btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .apply-btn {
            background: linear-gradient(45deg, #28a745, #218838);
            color: white;
        }

        .apply-btn:hover {
            background: linear-gradient(45deg, #218838, #1e7e34);
        }

        .back-btn {
            background: linear-gradient(45deg, #6c757d, #5a6268);
            color: white;
        }

        .back-btn:hover {
            background: linear-gradient(45deg, #5a6268, #444b52);
        }
    </style>
    <script>
        function openApplyForm(companyId) {
            window.open("apply_form.jsp?company_id=" + companyId, "_blank", "width=800,height=700");
        }
    </script>
</head>
<body>
    <div class="container">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM companies WHERE company_id = ?");
        stmt.setString(1, companyId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
%>
    <h2><%= rs.getString("company_name") %></h2>
    <p><strong>Email:</strong> <%= rs.getString("email") %></p>
    <p><strong>Posted On:</strong> <%= rs.getTimestamp("posted_date") %></p>
    <p><strong>Job Description:</strong><br><%= rs.getString("job_description").replaceAll("\n", "<br>") %></p>
    <p><strong>Other Details:</strong><br><%= rs.getString("details").replaceAll("\n", "<br>") %></p>

    <div class="button-group">
        <a class="apply-btn" href="javascript:void(0);" onclick="openApplyForm('<%= rs.getString("company_id") %>')">Apply Now</a>
        <a class="back-btn" href="#" onclick="window.close(); return false;">Back</a>
    </div>
<%
        } else {
%>
        <p style="color: #ff6b6b;">Company not found.</p>
<%
        }
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
%>
        <p style="color: #ff6b6b;">Error: <%= e.getMessage() %></p>
<%
    }
%>
    </div>
</body>
</html>
