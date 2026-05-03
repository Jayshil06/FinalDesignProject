package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import com.me.finaldesignproject.util.JwtUtil;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
            conn = DBUtil.getConnection();

            String sql = "SELECT * FROM companies WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

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
            } else {
                request.setAttribute("error", "Invalid email or password.");
                RequestDispatcher rd = request.getRequestDispatcher("company_login.jsp");
                rd.forward(request, response);
            }

        } catch (SQLException e) {
            getServletContext().log("Database error in CompanyLoginServlet", e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("company_login.jsp");
            rd.forward(request, response);
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }
}
