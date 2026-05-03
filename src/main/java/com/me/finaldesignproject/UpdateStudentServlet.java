package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdateStudentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");
        String name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String dob = request.getParameter("dob");
        String contact = request.getParameter("contact");
        String branch = request.getParameter("branch");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        Connection conn = null;
        PreparedStatement selectPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Step 1: Get current data for the student
            String selectSql = "SELECT * FROM students WHERE enrollment_no = ?";
            selectPs = conn.prepareStatement(selectSql);
            selectPs.setString(1, enrollmentNo);
            rs = selectPs.executeQuery();

            if (rs.next()) {
                if (name == null || name.trim().isEmpty()) {
                    name = rs.getString("full_name");
                }
                if (email == null || email.trim().isEmpty()) {
                    email = rs.getString("email");
                }
                if (dob == null || dob.trim().isEmpty()) {
                    dob = rs.getString("dob");
                }
                if (contact == null || contact.trim().isEmpty()) {
                    contact = rs.getString("contact");
                }
                if (branch == null || branch.trim().isEmpty()) {
                    branch = rs.getString("branch");
                }
                if (gender == null || gender.trim().isEmpty()) {
                    gender = rs.getString("gender");
                }
                if (address == null || address.trim().isEmpty()) {
                    address = rs.getString("address");
                }

                // Step 2: Update the student with filled or preserved values
                String updateSql = "UPDATE students SET full_name=?, email=?, dob=?, contact=?, branch=?, gender=?, address=? WHERE enrollment_no=?";
                updatePs = conn.prepareStatement(updateSql);
                updatePs.setString(1, name);
                updatePs.setString(2, email);
                updatePs.setString(3, dob);
                updatePs.setString(4, contact);
                updatePs.setString(5, branch);
                updatePs.setString(6, gender);
                updatePs.setString(7, address);
                updatePs.setString(8, enrollmentNo);

                int rowsUpdated = updatePs.executeUpdate();

                if (rowsUpdated > 0) {
                    request.setAttribute("message", "Profile updated successfully!");
                } else {
                    request.setAttribute("message", "No changes were made.");
                }
            } else {
                request.setAttribute("message", "Student not found.");
            }

        } catch (Exception e) {
            getServletContext().log("Error in UpdateStudentServlet", e);
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            DBUtil.close(null, selectPs, rs);
            DBUtil.close(conn, updatePs);
        }

        RequestDispatcher rd = request.getRequestDispatcher("admin_student_details.jsp");
        rd.forward(request, response);
    }
}
