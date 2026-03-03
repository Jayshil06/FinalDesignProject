package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String selectSql = "SELECT * FROM companies WHERE company_id = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setInt(1, companyId);
            ResultSet rs = selectStmt.executeQuery();

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

                rs.close();
                selectStmt.close();

                String updateSql = "UPDATE companies SET company_name = ?, email = ?, job_description = ?, details = ? WHERE company_id = ?";
                PreparedStatement ps = conn.prepareStatement(updateSql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, jobDescription);
                ps.setString(4, details);
                ps.setInt(5, companyId);

                int rowsUpdated = ps.executeUpdate();
                ps.close();
                conn.close();

                if (rowsUpdated > 0) {
                    session.setAttribute("message", "✅ Company updated successfully.");
                } else {
                    session.setAttribute("message", "❌ Company update failed.");
                }
            } else {
                session.setAttribute("message", "❌ Company ID not found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
