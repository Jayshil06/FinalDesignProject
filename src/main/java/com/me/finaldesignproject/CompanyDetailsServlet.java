package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class CompanyDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("enrollment_no") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        String companyId = request.getParameter("company_id");

        if (companyId == null || companyId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid company ID.");
            request.getRequestDispatcher("student_home.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "SELECT * FROM companies WHERE company_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(companyId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, String> companyDetails = new HashMap<>();
                companyDetails.put("company_id", rs.getString("company_id"));
                companyDetails.put("company_name", rs.getString("company_name"));
                companyDetails.put("email", rs.getString("email"));
                companyDetails.put("job_description", rs.getString("job_description"));
                companyDetails.put("details", rs.getString("details"));
                companyDetails.put("posted_date", rs.getString("posted_date"));

                request.setAttribute("companyDetails", companyDetails);
                request.getRequestDispatcher("student_home.jsp?page=companydetails").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Company not found.");
                request.getRequestDispatcher("student_home.jsp").forward(request, response);
            }

        } catch (Exception e) {
            getServletContext().log("Error in CompanyDetailsServlet", e);
            request.setAttribute("errorMessage", "Error retrieving company details.");
            request.getRequestDispatcher("student_home.jsp").forward(request, response);
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
}
