package com.me.finaldesignproject;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

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
                HttpSession session = request.getSession();
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setAttribute("enrollment_no", rs.getString("enrollment_no"));
                session.setAttribute("branch", rs.getString("branch"));

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
