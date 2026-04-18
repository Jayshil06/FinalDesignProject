package com.me.finaldesignproject;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class StudentProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/design_engineering_portal";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found.", e);
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM students WHERE email = ?")) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    session.setAttribute("profileError", "No student record found.");
                    response.sendRedirect("student_home.jsp");
                    return;
                }

                request.setAttribute("student", buildStudentMap(rs));
                moveFlashAttribute(session, request, "profileSuccess", "success");
                moveFlashAttribute(session, request, "profileError", "error");
                moveFlashAttribute(session, request, "profileEditMode", "editMode");

                RequestDispatcher dispatcher = request.getRequestDispatcher("view_profile.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Unable to load student profile.", e);
        }
    }

    private Map<String, Object> buildStudentMap(ResultSet rs) throws Exception {
        Map<String, Object> student = new LinkedHashMap<>();
        student.put("enrollment_no", rs.getString("enrollment_no"));
        student.put("full_name", rs.getString("full_name"));
        student.put("email", rs.getString("email"));

        Date dob = rs.getDate("dob");
        student.put("dob", dob != null ? dob.toString() : "");

        student.put("branch", rs.getString("branch"));
        student.put("contact", rs.getString("contact"));
        student.put("cgpa", rs.getBigDecimal("cgpa"));
        student.put("gender", rs.getString("gender"));
        student.put("address", rs.getString("address"));
        student.put("resume_path", rs.getString("resume_path"));
        return student;
    }

    private void moveFlashAttribute(HttpSession session, HttpServletRequest request,
                                    String sessionKey, String requestKey) {
        Object value = session.getAttribute(sessionKey);
        if (value != null) {
            request.setAttribute(requestKey, value);
            session.removeAttribute(sessionKey);
        }
    }
}
