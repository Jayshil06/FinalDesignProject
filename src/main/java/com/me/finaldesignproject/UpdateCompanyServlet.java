package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdateCompanyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        int companyId = Integer.parseInt(request.getParameter("company_id"));
        String name = request.getParameter("company_name");
        String email = request.getParameter("email");
        String jobDescription = request.getParameter("job_description");
        String details = request.getParameter("details");

        Connection conn = null;
        PreparedStatement selectStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            String selectSql = "SELECT * FROM companies WHERE company_id = ?";
            selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setInt(1, companyId);
            rs = selectStmt.executeQuery();

            if (rs.next()) {
                if (name == null || name.trim().isEmpty()) {
                    name = rs.getString("company_name");
                }
                if (email == null || email.trim().isEmpty()) {
                    email = rs.getString("email");
                }
                if (jobDescription == null || jobDescription.trim().isEmpty()) {
                    jobDescription = rs.getString("job_description");
                }
                if (details == null || details.trim().isEmpty()) {
                    details = rs.getString("details");
                }

                String updateSql = "UPDATE companies SET company_name = ?, email = ?, job_description = ?, details = ? WHERE company_id = ?";
                updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, name);
                updateStmt.setString(2, email);
                updateStmt.setString(3, jobDescription);
                updateStmt.setString(4, details);
                updateStmt.setInt(5, companyId);

                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    session.setAttribute("message", "✅ Company updated successfully.");
                } else {
                    session.setAttribute("message", "❌ Company update failed.");
                }
            } else {
                session.setAttribute("message", "❌ Company ID not found.");
            }

        } catch (Exception e) {
            getServletContext().log("Error in UpdateCompanyServlet", e);
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        } finally {
            DBUtil.close(null, selectStmt, rs);
            DBUtil.close(conn, updateStmt);
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
