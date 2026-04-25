package com.me.finaldesignproject;

import com.me.finaldesignproject.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminStudentListServlet extends HttpServlet {

    public class Student {
        public int id;
        public String name;
        public String email;
        public String enrollment;
        public String contact;
        public String branch;
    }

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

            if (!"admin".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
                return;
            }

            List<Student> studentList = new ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

                String sql = "SELECT * FROM students";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    Student s = new Student();
                    s.id = rs.getInt("student_id");
                    s.name = rs.getString("name");
                    s.email = rs.getString("email");
                    s.enrollment = rs.getString("enrollment_no");
                    s.contact = rs.getString("contact_no");
                    s.branch = rs.getString("branch");
                    studentList.add(s);
                }

                rs.close();
                stmt.close();
                conn.close();

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
            }

            request.setAttribute("students", studentList);
            RequestDispatcher rd = request.getRequestDispatcher("admin_student_list.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid or expired token");
        }
    }
}
