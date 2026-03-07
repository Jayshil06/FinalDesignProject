package com.me.finaldesignproject;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class CompanyListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/design_engineering_portal";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("enrollment_no") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Map<String, String>> companies = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "SELECT * FROM companies ORDER BY posted_date DESC";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Map<String, String> company = new HashMap<>();
                company.put("company_id", rs.getString("company_id"));
                company.put("company_name", rs.getString("company_name"));
                company.put("email", rs.getString("email"));
                company.put("job_description", rs.getString("job_description"));
                // No need for "position" if it's not in your DB
                companies.add(company);
            }

            request.setAttribute("companyList", companies);
            RequestDispatcher dispatcher = request.getRequestDispatcher("student_home.jsp?page=companylist");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching company list.");
            request.getRequestDispatcher("student_home.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
