package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
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
            conn = DBUtil.getConnection();

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
            getServletContext().log("Error in DeleteCompanyServlet", e);
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        } finally {
            DBUtil.close(null, reorderStmt);
            DBUtil.close(conn, deleteStmt);
        }

        response.sendRedirect("admin_company_details.jsp");
    }
}
