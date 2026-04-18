package com.me.finaldesignproject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class DatabaseInitializerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            Statement stmt = conn.createStatement();

            // Add status column to applications
            try {
                stmt.execute("ALTER TABLE applications ADD COLUMN status VARCHAR(20) DEFAULT 'Applied'");
                out.println("<p>✅ Column 'status' added to applications table.</p>");
            } catch (SQLException e) {
                out.println("<p>ℹ️ Column 'status' already exists or could not be added: " + e.getMessage() + "</p>");
            }

            // Add salary_offered column to applications
            try {
                stmt.execute("ALTER TABLE applications ADD COLUMN salary_offered DOUBLE DEFAULT 0.0");
                out.println("<p>✅ Column 'salary_offered' added to applications table.</p>");
            } catch (SQLException e) {
                out.println("<p>ℹ️ Column 'salary_offered' already exists or could not be added: " + e.getMessage() + "</p>");
            }

            stmt.close();
            conn.close();
            out.println("<h2>Database initialization complete! You can now use the Analytics Dashboard.</h2>");
            out.println("<a href='admin_home.jsp'>Return to Admin Home</a>");

        } catch (Exception e) {
            out.println("<p class='error'>❌ Error initializing database: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }
}
