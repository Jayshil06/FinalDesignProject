package com.me.finaldesignproject;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class StudentProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");

        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM students WHERE email = ?")) {

            Class.forName("com.mysql.cj.jdbc.Driver");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("student", rs);
                RequestDispatcher dispatcher = request.getRequestDispatcher("view_profile.jsp");
                dispatcher.forward(request, response);
            } else {
                response.getWriter().println("No student record found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
