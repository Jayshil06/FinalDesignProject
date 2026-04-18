package com.me.finaldesignproject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UpdateStudentProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/design_engineering_portal";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    private static final String RESUME_UPLOAD_DIR = "C:" + File.separator + "placement_resumes";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String sessionEmail = (String) session.getAttribute("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found.", e);
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Map<String, String> currentStudent = loadCurrentStudent(conn, sessionEmail);
            if (currentStudent == null) {
                session.setAttribute("profileError", "Unable to find your profile.");
                response.sendRedirect("StudentProfileServlet");
                return;
            }

            String enrollmentNo = currentStudent.get("enrollment_no");
            String fullName = normalize(request.getParameter("full_name"));
            String email = normalize(request.getParameter("email"));
            String dobValue = normalize(request.getParameter("dob"));
            String branch = normalize(request.getParameter("branch"));
            String contact = normalize(request.getParameter("contact"));
            String cgpaValue = normalize(request.getParameter("cgpa"));
            String gender = normalize(request.getParameter("gender"));
            String address = normalize(request.getParameter("address"));

            String validationError = validateInput(fullName, email, dobValue, branch, contact, cgpaValue, gender, address);
            if (validationError != null) {
                session.setAttribute("profileError", validationError);
                session.setAttribute("profileEditMode", Boolean.TRUE);
                response.sendRedirect("StudentProfileServlet");
                return;
            }

            if (emailExistsForAnotherStudent(conn, email, enrollmentNo)) {
                session.setAttribute("profileError", "That email address is already being used by another student.");
                session.setAttribute("profileEditMode", Boolean.TRUE);
                response.sendRedirect("StudentProfileServlet");
                return;
            }

            String resumePath = currentStudent.get("resume_path");
            Part resumePart = request.getPart("resume");
            String uploadedFileName = getSubmittedFileName(resumePart);
            if (!uploadedFileName.isEmpty()) {
                if (!uploadedFileName.toLowerCase().endsWith(".pdf")) {
                    session.setAttribute("profileError", "Resume must be a PDF file.");
                    session.setAttribute("profileEditMode", Boolean.TRUE);
                    response.sendRedirect("StudentProfileServlet");
                    return;
                }
                resumePath = saveResume(enrollmentNo, uploadedFileName, resumePart);
            }

            String updateSql = "UPDATE students SET full_name = ?, email = ?, dob = ?, branch = ?, "
                    + "contact = ?, cgpa = ?, gender = ?, address = ?, resume_path = ? WHERE enrollment_no = ?";

            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, fullName);
                stmt.setString(2, email);
                stmt.setDate(3, Date.valueOf(dobValue));
                stmt.setString(4, branch);
                stmt.setString(5, contact);
                stmt.setDouble(6, Double.parseDouble(cgpaValue));
                stmt.setString(7, gender);
                stmt.setString(8, address);
                stmt.setString(9, resumePath);
                stmt.setString(10, enrollmentNo);

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    session.setAttribute("email", email);
                    session.setAttribute("full_name", fullName);
                    session.setAttribute("branch", branch);
                    session.setAttribute("profileSuccess", "Profile updated successfully.");
                } else {
                    session.setAttribute("profileError", "No changes were saved.");
                    session.setAttribute("profileEditMode", Boolean.TRUE);
                }
            }

            response.sendRedirect("StudentProfileServlet");
        } catch (SQLIntegrityConstraintViolationException e) {
            session.setAttribute("profileError", "Unable to save profile because some values must be unique.");
            session.setAttribute("profileEditMode", Boolean.TRUE);
            response.sendRedirect("StudentProfileServlet");
        } catch (Exception e) {
            throw new ServletException("Unable to update student profile.", e);
        }
    }

    private Map<String, String> loadCurrentStudent(Connection conn, String email) throws Exception {
        String sql = "SELECT enrollment_no, resume_path FROM students WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Map<String, String> student = new HashMap<>();
                student.put("enrollment_no", rs.getString("enrollment_no"));
                student.put("resume_path", rs.getString("resume_path"));
                return student;
            }
        }
    }

    private boolean emailExistsForAnotherStudent(Connection conn, String email, String enrollmentNo) throws Exception {
        String sql = "SELECT COUNT(*) FROM students WHERE email = ? AND enrollment_no <> ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, enrollmentNo);
            try (ResultSet rs = stmt.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    private String validateInput(String fullName, String email, String dobValue, String branch,
                                 String contact, String cgpaValue, String gender, String address) {
        if (fullName.isEmpty() || email.isEmpty() || dobValue.isEmpty() || branch.isEmpty()
                || contact.isEmpty() || cgpaValue.isEmpty() || gender.isEmpty() || address.isEmpty()) {
            return "Please fill in all profile fields.";
        }

        try {
            double cgpa = Double.parseDouble(cgpaValue);
            if (cgpa < 0 || cgpa > 10) {
                return "CGPA must be between 0 and 10.";
            }
        } catch (NumberFormatException e) {
            return "Please enter a valid numeric CGPA.";
        }

        try {
            Date.valueOf(dobValue);
        } catch (IllegalArgumentException e) {
            return "Please enter a valid date of birth.";
        }

        return null;
    }

    private String saveResume(String enrollmentNo, String originalFileName, Part resumePart) throws IOException {
        File uploadDir = new File(RESUME_UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        if (!uploadDir.exists() || !uploadDir.canWrite()) {
            throw new IOException("Resume folder is not writable: " + uploadDir.getAbsolutePath());
        }

        String sanitizedFileName = originalFileName.replaceAll("[\\\\/:*?\"<>|]", "_");
        String finalFileName = enrollmentNo + "_" + sanitizedFileName;
        Path targetPath = Paths.get(uploadDir.getAbsolutePath(), finalFileName);

        try (InputStream inputStream = resumePart.getInputStream()) {
            Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        return targetPath.toString();
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private String getSubmittedFileName(Part part) {
        if (part == null || part.getSubmittedFileName() == null) {
            return "";
        }
        return Paths.get(part.getSubmittedFileName()).getFileName().toString().trim();
    }
}
