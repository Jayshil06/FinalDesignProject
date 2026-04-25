package com.me.finaldesignproject;

import com.me.finaldesignproject.util.JwtUtil;
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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

           String sql = "SELECT * FROM admins WHERE email = ? AND password = ?";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
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
                // Failed login
                request.setAttribute("error", "Invalid email or password");
                RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
                rd.forward(request, response);
            }

            rs.close();
            pstmt.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
            rd.forward(request, response);
        }
    }
}
