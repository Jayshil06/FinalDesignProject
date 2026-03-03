package com.me.finaldesignproject;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String RESUME_UPLOAD_DIR = "resumes";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String enrollment_no = request.getParameter("enrollment_no");
        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String dob = request.getParameter("dob");
        String branch = request.getParameter("branch");
        String contact = request.getParameter("contact");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");

        Part resumePart = request.getPart("resume");
        String fileName = Paths.get(resumePart.getSubmittedFileName()).getFileName().toString();

        // Prepare upload directory
        String uploadPath = getServletContext().getRealPath("") + File.separator + RESUME_UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String resumePath = RESUME_UPLOAD_DIR + File.separator + enrollment_no + "_" + fileName;
        String fullResumePath = uploadPath + File.separator + enrollment_no + "_" + fileName;
        resumePart.write(fullResumePath);

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "INSERT INTO students (enrollment_no, full_name, email, password, dob, branch, contact, gender, address, resume_path) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, enrollment_no);
            stmt.setString(2, full_name);
            stmt.setString(3, email);
            stmt.setString(4, password);
            stmt.setString(5, dob);
            stmt.setString(6, branch);
            stmt.setString(7, contact);
            stmt.setString(8, gender);
            stmt.setString(9, address);
            stmt.setString(10, resumePath);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("student_login.jsp?registered=success");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("student_register.jsp").forward(request, response);
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("error", "Enrollment No or Email already exists.");
            request.getRequestDispatcher("student_register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("student_register.jsp").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
