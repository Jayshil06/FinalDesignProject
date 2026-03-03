package com.me.finaldesignproject;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DownloadResumeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");

        if (enrollmentNo == null || enrollmentNo.trim().isEmpty()) {
            response.getWriter().write("Enrollment number is missing.");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal",
                "root",
                "root"
            );

            String sql = "SELECT resume_path FROM students WHERE enrollment_no = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, enrollmentNo);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                String resumePath = rs.getString("resume_path");

                if (resumePath == null || resumePath.trim().isEmpty()) {
                    response.getWriter().write("Resume path not found in database.");
                    return;
                }

                // 🔥 IMPORTANT: Use DB path directly
                File file = new File(resumePath);

                if (!file.exists()) {
                    response.getWriter().write("Resume file not found at: " + resumePath);
                    return;
                }

                // Set response headers
                response.setContentType("application/octet-stream");
                response.setHeader(
                        "Content-Disposition",
                        "attachment; filename=\"" + file.getName() + "\""
                );

                // Stream file to browser
                FileInputStream fis = new FileInputStream(file);
                OutputStream os = response.getOutputStream();

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }

                fis.close();
                os.close();
            } else {
                response.getWriter().write("No student found for this enrollment number.");
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
