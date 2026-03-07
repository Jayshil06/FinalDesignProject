package com.me.finaldesignproject;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;

public class DeleteCompanyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        int companyId = Integer.parseInt(request.getParameter("company_id"));

        Connection conn = null;
        PreparedStatement deleteStmt = null;
        Statement reorderStmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            // Step 1: Delete the selected company
            String deleteSQL = "DELETE FROM companies WHERE company_id = ?";
            deleteStmt = conn.prepareStatement(deleteSQL);
            deleteStmt.setInt(1, companyId);
            int rowsDeleted = deleteStmt.executeUpdate();

            // Step 2: Reorder IDs if deletion was successful
            if (rowsDeleted > 0) {
                reorderStmt = conn.createStatement();
                reorderStmt.execute("SET @count = 0");
                reorderStmt.execute("UPDATE companies SET company_id = (@count := @count + 1)");
                reorderStmt.execute("ALTER TABLE companies AUTO_INCREMENT = 1");
                session.setAttribute("message", "✅ Company deleted and IDs reordered.");
            } else {
                session.setAttribute("message", "❌ Company deletion failed.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        } finally {
            try { if (deleteStmt != null) deleteStmt.close(); } catch (Exception e) {}
            try { if (reorderStmt != null) reorderStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
