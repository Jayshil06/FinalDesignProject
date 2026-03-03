package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "INSERT INTO companies (company_name, email, job_description, details, posted_date) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, jobDescription);
            ps.setString(4, details);

            int rowsInserted = ps.executeUpdate();
            ps.close();
            conn.close();

            if (rowsInserted > 0) {
                session.setAttribute("message", "✅ Company added successfully.");
            } else {
                session.setAttribute("message", "❌ Failed to add company.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
