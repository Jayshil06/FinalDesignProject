<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String enrollmentNo = (String) session.getAttribute("enrollment_no");
    String companyId = request.getParameter("company_id");

    if (enrollmentNo == null || companyId == null) {
        response.sendRedirect("student_login.jsp");
        return;
    }

    String fullName = "", email = "", branch = "", contact = "", resumePath = "", companyName = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

        PreparedStatement stuStmt = conn.prepareStatement("SELECT full_name, email, branch, contact, resume_path FROM students WHERE enrollment_no = ?");
        stuStmt.setString(1, enrollmentNo);
        ResultSet stuRs = stuStmt.executeQuery();
        if (stuRs.next()) {
            fullName = stuRs.getString("full_name");
            email = stuRs.getString("email");
            branch = stuRs.getString("branch");
            contact = stuRs.getString("contact");
            resumePath = stuRs.getString("resume_path");
        }

        PreparedStatement compStmt = conn.prepareStatement("SELECT company_name FROM companies WHERE company_id = ?");
        compStmt.setString(1, companyId);
        ResultSet compRs = compStmt.executeQuery();
        if (compRs.next()) {
            companyName = compRs.getString("company_name");
        }

        stuRs.close();
        compRs.close();
        stuStmt.close();
        compStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Apply for Company</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #fff;
            padding: 40px;
        }

        .form-container {
            max-width: 600px;
            margin: auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(8px);
            border-radius: 15px;
            padding: 30px 35px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.4);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #ffdd57;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #ffd700;
        }

        input[type="text"], input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 8px;
            border: none;
            background: rgba(255, 255, 255, 0.9);
            color: #000;
            font-weight: 500;
        }

        input[readonly] {
            background: rgba(255, 255, 255, 0.5);
            color: #333;
        }

        input[type="submit"] {
            background: linear-gradient(45deg, #28a745, #218838);
            color: #fff;
            font-weight: bold;
            margin-top: 25px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background: linear-gradient(45deg, #218838, #1e7e34);
        }

        .back-btn {
            display: block;
            text-align: center;
            margin-top: 20px;
            background: linear-gradient(45deg, #6c757d, #5a6268);
            padding: 10px 20px;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .back-btn:hover {
            background: linear-gradient(45deg, #5a6268, #444b52);
        }
    </style>
    <script>
        function confirmSubmit() {
            return confirm("Are you sure you want to apply for this company?");
        }

        function goBack() {
            window.close();
        }
    </script>
</head>
<body>
    <div class="form-container">
        <h2>Apply for <%= companyName %></h2>
        <form action="ApplyCompanyServlet" method="post" onsubmit="return confirmSubmit();">
            <input type="hidden" name="enrollment_no" value="<%= enrollmentNo %>">
            <input type="hidden" name="company_id" value="<%= companyId %>">

            <label>Full Name</label>
            <input type="text" value="<%= fullName %>" readonly>

            <label>Email</label>
            <input type="text" value="<%= email %>" readonly>

            <label>Branch</label>
            <input type="text" value="<%= branch %>" readonly>

            <label>Contact</label>
            <input type="text" value="<%= contact %>" readonly>

            <label>Resume</label>
            <input type="text" value="<%= resumePath %>" readonly>

            <input type="submit" value="Submit Application">
        </form>
        <a class="back-btn" href="javascript:void(0);" onclick="goBack();">Back</a>
    </div>
</body>
</html>
