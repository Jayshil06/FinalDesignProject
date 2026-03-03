package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class CompanyApplicationsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int companyId = Integer.parseInt(request.getParameter("id"));

        List<Map<String, String>> applications = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "SELECT a.*, s.name, s.email, s.contact_no, s.branch, s.semester " +
                         "FROM applications a " +
                         "JOIN students s ON a.enrollment_no = s.enrollment_no " +
                         "WHERE a.company_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, companyId);
            ResultSet rs = ps.executeQuery();

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

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        }

        request.setAttribute("applications", applications);
        RequestDispatcher rd = request.getRequestDispatcher("company_applications.jsp");
        rd.forward(request, response);
    }
}
