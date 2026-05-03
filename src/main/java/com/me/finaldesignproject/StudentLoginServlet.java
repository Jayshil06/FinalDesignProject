package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import com.me.finaldesignproject.util.JwtUtil;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM students WHERE email = ?");
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                boolean passwordMatch = false;

                try {
                    // Try BCrypt check
                    passwordMatch = BCrypt.checkpw(password, storedPassword);
                } catch (IllegalArgumentException e) {
                    // Fallback to plain text check for legacy passwords
                    passwordMatch = password.equals(storedPassword);
                }

                if (passwordMatch) {
                    int studentId = rs.getInt("student_id");
                    String fullName = rs.getString("full_name");
                    String enrollmentNo = rs.getString("enrollment_no");
                    String branch = rs.getString("branch");

                    // Create JWT token
                    Map<String, Object> claims = new HashMap<>();
                    claims.put("role", "student");
                    claims.put("user_id", studentId);
                    claims.put("name", fullName);
                    claims.put("enrollment_no", enrollmentNo);
                    claims.put("branch", branch);

                    String token = JwtUtil.generateToken(email, claims);

                    // Set token in response header
                    response.setHeader("Authorization", "Bearer " + token);

                    // Also set in session for backward compatibility
                    HttpSession session = request.getSession();
                    session.setAttribute("student_id", studentId);
                    session.setAttribute("email", email);
                    session.setAttribute("full_name", fullName);
                    session.setAttribute("enrollment_no", enrollmentNo);
                    session.setAttribute("branch", branch);
                    session.setAttribute("jwt_token", token);

                    response.sendRedirect("student_home.jsp");
                } else {
                    request.setAttribute("error", "Invalid Email or Password");
                    RequestDispatcher rd = request.getRequestDispatcher("student_login.jsp");
                    rd.forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid Email or Password");
                RequestDispatcher rd = request.getRequestDispatcher("student_login.jsp");
                rd.forward(request, response);
            }

        } catch (SQLException e) {
            getServletContext().log("Database error in StudentLoginServlet", e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("student_login.jsp");
            rd.forward(request, response);
        } finally {
            DBUtil.close(conn, stmt, rs);
        }
    }
}
