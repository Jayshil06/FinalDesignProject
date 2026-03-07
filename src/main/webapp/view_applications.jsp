<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("company_id") == null) {
        response.sendRedirect("company_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Applications</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            margin: 0;
            padding: 30px 20px;
            animation: fadeInBody 0.7s ease;
        }

        .card {
            max-width: 1100px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(8px);
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
            overflow-x: auto;
            animation: fadeInUp 0.8s ease;
        }

        h2 {
            text-align: center;
            color: #f9ca24;
            margin-top: 0;
            animation: slideDown 0.7s ease;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        th, td {
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 10px;
            text-align: left;
            transition: background-color 0.25s ease;
        }

        th {
            background: rgba(0, 188, 212, 0.24);
        }

        tr:hover td {
            background-color: rgba(255, 255, 255, 0.06);
        }

        a {
            color: #7ed6ff;
            text-decoration: none;
        }

        .error {
            color: #ff8f8f;
            text-align: center;
            font-weight: 600;
        }

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Student Applications</h2>

        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            ResultSet statusRs = null;
            PreparedStatement statusPs = null;
            boolean hasRows = false;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

                boolean hasStatusColumn = false;
                statusPs = conn.prepareStatement("SHOW COLUMNS FROM applications LIKE 'status'");
                statusRs = statusPs.executeQuery();
                if (statusRs.next()) {
                    hasStatusColumn = true;
                }

                String sql;
                if (hasStatusColumn) {
                    sql = "SELECT s.full_name, s.enrollment_no, s.branch, s.cgpa, s.resume_path, a.status "
                        + "FROM applications a "
                        + "JOIN students s ON s.enrollment_no = a.enrollment_no "
                        + "WHERE a.company_id = ? "
                        + "ORDER BY a.application_date DESC";
                } else {
                    sql = "SELECT s.full_name, s.enrollment_no, s.branch, s.cgpa, s.resume_path, 'Pending' AS status "
                        + "FROM applications a "
                        + "JOIN students s ON s.enrollment_no = a.enrollment_no "
                        + "WHERE a.company_id = ? "
                        + "ORDER BY a.application_date DESC";
                }

                ps = conn.prepareStatement(sql);
                ps.setInt(1, (Integer) session.getAttribute("company_id"));
                rs = ps.executeQuery();
        %>
        <table>
            <tr>
                <th>Student Name</th>
                <th>Enrollment No</th>
                <th>Branch</th>
                <th>CGPA</th>
                <th>Resume</th>
            </tr>
            <%
                while (rs.next()) {
                    hasRows = true;
                    String cgpaValue = rs.getString("cgpa");
                    if (cgpaValue == null || cgpaValue.trim().isEmpty()) {
                        cgpaValue = "Not Provided";
                    }
            %>
            <tr>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("enrollment_no") %></td>
                <td><%= rs.getString("branch") %></td>
                <td><%= cgpaValue %></td>
                <td>
                    <%
                        String resumePath = rs.getString("resume_path");
                        if (resumePath != null && !resumePath.trim().isEmpty()) {
                    %>
                        <a href="DownloadResumeServlet?enrollment_no=<%= rs.getString("enrollment_no") %>" target="_blank">Download Resume</a>
                    <%
                        } else {
                            out.print("No Resume");
                        }
                    %>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <%
                if (!hasRows) {
                    out.println("<p class='error'>No applications found for your company.</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (statusRs != null) statusRs.close(); } catch (Exception ignored) {}
                try { if (statusPs != null) statusPs.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            }
        %>
    </div>
</body>
</html>
