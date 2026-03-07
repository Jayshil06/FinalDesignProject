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
    <title>Filter Students</title>
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
            max-width: 1050px;
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

        .search-row {
            display: flex;
            gap: 10px;
            align-items: end;
            justify-content: center;
            margin-bottom: 16px;
        }

        .search-row input {
            padding: 10px;
            border: none;
            border-radius: 8px;
            width: 220px;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        .search-row input:focus {
            box-shadow: 0 0 0 2px rgba(0, 188, 212, 0.45);
            transform: translateY(-1px);
        }

        .search-row button {
            padding: 10px 14px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #fff;
            cursor: pointer;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .search-row button:hover {
            transform: translateY(-2px) scale(1.01);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.35);
        }

        table {
            width: 100%;
            border-collapse: collapse;
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
        <h2>Filter Students by CGPA</h2>

        <form method="get" class="search-row">
            <input type="number" name="min_cgpa" step="0.01" min="0" max="10" placeholder="Minimum CGPA" required>
            <button type="submit">Filter Students</button>
        </form>

        <%
            String minCgpaParam = request.getParameter("min_cgpa");
            if (minCgpaParam != null && !minCgpaParam.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                PreparedStatement cgpaPs = null;
                ResultSet cgpaRs = null;
                boolean hasRows = false;

                try {
                    double minCgpa = Double.parseDouble(minCgpaParam);

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

                    boolean cgpaColumnExists = false;
                    cgpaPs = conn.prepareStatement("SHOW COLUMNS FROM students LIKE 'cgpa'");
                    cgpaRs = cgpaPs.executeQuery();
                    if (cgpaRs.next()) {
                        cgpaColumnExists = true;
                    }

                    if (!cgpaColumnExists) {
                        out.println("<p class='error'>CGPA column not found in students table.</p>");
                    } else {
                        String sql = "SELECT full_name, enrollment_no, branch, cgpa, resume_path "
                                + "FROM students WHERE cgpa >= ? ORDER BY cgpa DESC";
                        ps = conn.prepareStatement(sql);
                        ps.setDouble(1, minCgpa);
                        rs = ps.executeQuery();
        %>
        <table>
            <tr>
                <th>Name</th>
                <th>Enrollment</th>
                <th>Branch</th>
                <th>CGPA</th>
                <th>Download Resume</th>
            </tr>
            <%
                while (rs.next()) {
                    hasRows = true;
            %>
            <tr>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("enrollment_no") %></td>
                <td><%= rs.getString("branch") %></td>
                <td><%= rs.getString("cgpa") %></td>
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
            </tr>
            <% } %>
        </table>
        <%
                        if (!hasRows) {
                            out.println("<p class='error'>No students found for CGPA >= " + minCgpa + ".</p>");
                        }
                    }
                } catch (NumberFormatException e) {
                    out.println("<p class='error'>Please enter a valid CGPA value.</p>");
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                    try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                    try { if (cgpaRs != null) cgpaRs.close(); } catch (Exception ignored) {}
                    try { if (cgpaPs != null) cgpaPs.close(); } catch (Exception ignored) {}
                    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
                }
            }
        %>
    </div>
</body>
</html>
