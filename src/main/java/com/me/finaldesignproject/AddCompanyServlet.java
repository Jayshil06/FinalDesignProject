package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class AddCompanyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("company_name");
        String email = request.getParameter("email");
        String jobDescription = request.getParameter("job_description");
        String details = request.getParameter("details");

        HttpSession session = request.getSession();

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "INSERT INTO companies (company_name, email, job_description, details, posted_date) VALUES (?, ?, ?, ?, NOW())";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, jobDescription);
            ps.setString(4, details);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                session.setAttribute("message", "✅ Company added successfully.");
            } else {
                session.setAttribute("message", "❌ Failed to add company.");
            }

        } catch (Exception e) {
            getServletContext().log("Error in AddCompanyServlet", e);
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        } finally {
            DBUtil.close(conn, ps);
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
