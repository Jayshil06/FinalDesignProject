package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import com.me.finaldesignproject.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class CompanyApplicationsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check JWT authentication
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authorization token required");
            return;
        }

        String token = authHeader.substring(7);
        try {
            // Validate token and extract user info
            String role = JwtUtil.extractClaim(token, "role");
            int companyId = JwtUtil.extractClaimAsInt(token, "user_id");

            if (!"company".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Company role required.");
                return;
            }

            List<Map<String, String>> applications = new ArrayList<>();
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBUtil.getConnection();

                String sql = "SELECT a.*, s.name, s.email, s.contact_no, s.branch, s.semester " +
                             "FROM applications a " +
                             "JOIN students s ON a.enrollment_no = s.enrollment_no " +
                             "WHERE a.company_id = ?";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, companyId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    Map<String, String> app = new HashMap<>();
                    app.put("enrollment_no", rs.getString("enrollment_no"));
                    app.put("name", rs.getString("name"));
                    app.put("email", rs.getString("email"));
                    app.put("contact_no", rs.getString("contact_no"));
                    app.put("branch", rs.getString("branch"));
                    app.put("semester", rs.getString("semester"));
                    app.put("apply_date", rs.getString("apply_date"));
                    applications.add(app);
                }

            } catch (Exception e) {
                getServletContext().log("Error in CompanyApplicationsServlet", e);
                request.setAttribute("message", "Error: " + e.getMessage());
            } finally {
                DBUtil.close(conn, ps, rs);
            }

            request.setAttribute("applications", applications);
            RequestDispatcher rd = request.getRequestDispatcher("company_applications.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid or expired token");
        }
    }
}
