package com.me.finaldesignproject;

import com.me.finaldesignproject.util.JwtUtil;
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
            // ✅ Load JDBC driver BEFORE connection
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");
            stmt = conn.prepareStatement("SELECT * FROM students WHERE email = ? AND password = ?");
            stmt.setString(1, email);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
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

        } catch (ClassNotFoundException e) {
            // ✅ Helpful driver error
            e.printStackTrace();
            request.setAttribute("error", "MySQL JDBC Driver not found.");
            RequestDispatcher rd = request.getRequestDispatcher("student_login.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            // ✅ Catch and show SQL error
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("student_login.jsp");
            rd.forward(request, response);
        } finally {
            // ✅ Close resources safely
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
