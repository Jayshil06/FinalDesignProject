package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class DeleteStudentServlet extends HttpServlet {

    // Change this from doGet to doPost
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "DELETE FROM students WHERE enrollment_no = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, enrollmentNo);

            int result = ps.executeUpdate();

            if (result > 0) {
                request.setAttribute("message", "Student deleted successfully.");
            } else {
                request.setAttribute("message", "Student not found or could not be deleted.");
            }

        } catch (Exception e) {
            getServletContext().log("Error in DeleteStudentServlet", e);
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            DBUtil.close(conn, ps);
        }

        RequestDispatcher rd = request.getRequestDispatcher("admin_student_details.jsp");
        rd.forward(request, response);
    }
}
