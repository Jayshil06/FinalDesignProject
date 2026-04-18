package com.me.finaldesignproject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdateApplicationStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");
        int companyId = Integer.parseInt(request.getParameter("company_id"));
        String status = request.getParameter("status");
        String salaryOfferedStr = request.getParameter("salary_offered");
        double salaryOffered = 0.0;

        if (salaryOfferedStr != null && !salaryOfferedStr.isEmpty()) {
            try {
                salaryOffered = Double.parseDouble(salaryOfferedStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("company_applications.jsp?error=Invalid salary");
                return;
            }
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "UPDATE applications SET status = ?, salary_offered = ? WHERE enrollment_no = ? AND company_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setDouble(2, salaryOffered);
            pstmt.setString(3, enrollmentNo);
            pstmt.setInt(4, companyId);

            int rows = pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            if (rows > 0) {
                response.sendRedirect("CompanyApplicationsServlet?id=" + companyId + "&success=updated");
            } else {
                response.sendRedirect("CompanyApplicationsServlet?id=" + companyId + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CompanyApplicationsServlet?id=" + companyId + "&error=" + e.getMessage());
        }
    }
}
