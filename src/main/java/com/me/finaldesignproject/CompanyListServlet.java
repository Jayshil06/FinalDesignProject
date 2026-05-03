package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class CompanyListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            conn = DBUtil.getConnection();

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
            getServletContext().log("Error in CompanyListServlet", e);
            request.setAttribute("errorMessage", "Error fetching company list.");
            request.getRequestDispatcher("student_home.jsp").forward(request, response);
        } finally {
            DBUtil.close(conn, stmt, rs);
        }
    }
}
