package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MyApplicationsServlet extends HttpServlet {

    public static class Application {
        public int applicationId;
        public String companyName;
        public String position;
        public Date applyDate;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("student_id");

        List<Application> applications = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "");

            String sql = "SELECT a.application_id, a.apply_date, c.company_name, c.position " +
                         "FROM applications a " +
                         "JOIN companies c ON a.company_id = c.company_id " +
                         "WHERE a.student_id = ?";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Application app = new Application();
                app.applicationId = rs.getInt("application_id");
                app.companyName = rs.getString("company_name");
                app.position = rs.getString("position");
                app.applyDate = rs.getDate("apply_date");
                applications.add(app);
            }

            rs.close();
            pstmt.close();
            conn.close();

        } catch (Exception e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("applications", applications);
        request.getRequestDispatcher("my_applications.jsp").forward(request, response);
    }
}
