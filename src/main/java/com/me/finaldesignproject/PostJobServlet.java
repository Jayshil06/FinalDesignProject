package com.me.finaldesignproject;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PostJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("company_id") == null) {
            response.sendRedirect("company_login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("company_id");
        String jobRole = request.getParameter("job_role");
        String cgpaRequiredStr = request.getParameter("cgpa_required");
        String jobDescription = request.getParameter("job_description");

        double cgpaRequired;
        try {
            cgpaRequired = Double.parseDouble(cgpaRequiredStr);
        } catch (Exception e) {
            response.sendRedirect("post_job.jsp?error=invalid_cgpa");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "UPDATE companies SET job_role = ?, cgpa_required = ?, job_description = ?, posted_date = NOW() "
                    + "WHERE company_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, jobRole);
            ps.setDouble(2, cgpaRequired);
            ps.setString(3, jobDescription);
            ps.setInt(4, companyId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("post_job.jsp?success=1");
            } else {
                response.sendRedirect("post_job.jsp?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("post_job.jsp?error=db");
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }
    }
}
