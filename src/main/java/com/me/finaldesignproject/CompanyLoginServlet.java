package com.me.finaldesignproject;

import com.me.finaldesignproject.util.JwtUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CompanyLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "SELECT company_id, company_name, email FROM companies WHERE email = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                int companyId = rs.getInt("company_id");
                String companyName = rs.getString("company_name");
                String companyEmail = rs.getString("email");

                // Create JWT token
                Map<String, Object> claims = new HashMap<>();
                claims.put("role", "company");
                claims.put("user_id", companyId);
                claims.put("name", companyName);

                String token = JwtUtil.generateToken(email, claims);

                // Set token in response header
                response.setHeader("Authorization", "Bearer " + token);

                // Also set in session for backward compatibility
                HttpSession session = request.getSession();
                session.setAttribute("company_id", companyId);
                session.setAttribute("company_name", companyName);
                session.setAttribute("company_email", companyEmail);
                session.setAttribute("jwt_token", token);

                response.sendRedirect("company_home.jsp");
            } else {
                request.setAttribute("error", "Invalid email or password.");
                RequestDispatcher rd = request.getRequestDispatcher("company_login.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("company_login.jsp");
            rd.forward(request, response);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }
    }
}
