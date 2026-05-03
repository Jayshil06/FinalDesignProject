package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import com.me.finaldesignproject.util.JwtUtil;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "SELECT * FROM admins WHERE email = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            rs = pstmt.executeQuery();

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
                    // Successful login
                    int adminId = rs.getInt("admin_id");
                    String adminName = rs.getString("name");

                    // Create JWT token
                    Map<String, Object> claims = new HashMap<>();
                    claims.put("role", "admin");
                    claims.put("user_id", adminId);
                    claims.put("name", adminName);

                    String token = JwtUtil.generateToken(email, claims);

                    // Set token in response header
                    response.setHeader("Authorization", "Bearer " + token);

                    // Also set in session for backward compatibility
                    HttpSession session = request.getSession();
                    session.setAttribute("admin_id", adminId);
                    session.setAttribute("admin_name", adminName);
                    session.setAttribute("jwt_token", token);

                    response.sendRedirect("admin_home.jsp");
                } else {
                    request.setAttribute("error", "Invalid email or password");
                    RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
                    rd.forward(request, response);
                }
            } else {
                // Failed login
                request.setAttribute("error", "Invalid email or password");
                RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
                rd.forward(request, response);
            }

        } catch (SQLException e) {
            getServletContext().log("Database error in AdminLoginServlet", e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
            rd.forward(request, response);
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
}
