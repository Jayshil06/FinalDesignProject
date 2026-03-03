package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

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
                HttpSession session = request.getSession();
                session.setAttribute("admin_id", rs.getInt("admin_id"));
                session.setAttribute("admin_name", rs.getString("name"));
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
