package com.me.finaldesignproject;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DownloadResumeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");

        if (enrollmentNo == null || enrollmentNo.trim().isEmpty()) {
            response.getWriter().write("Enrollment number is missing.");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/design_engineering_portal",
                "root",
                "root"
            );

            String sql = "SELECT resume_path FROM students WHERE enrollment_no = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, enrollmentNo);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String resumePath = rs.getString("resume_path");

                if (resumePath == null || resumePath.trim().isEmpty()) {
                    response.getWriter().write("Resume path not found in database.");
                    return;
                }

                File file = new File(resumePath);

                // Support relative paths stored in DB, e.g. resumes\file.pdf
                if (!file.isAbsolute()) {
                    String appRoot = getServletContext().getRealPath("");
                    String normalizedPath = resumePath.replace("\\", File.separator).replace("/", File.separator);
                    file = new File(appRoot, normalizedPath);
                }

                // Fallback to deployed resumes folder when DB path contains different separators
                if (!file.exists()) {
                    String appRoot = getServletContext().getRealPath("");
                    String fileNameOnly = new File(resumePath).getName();
                    File fallbackFile = new File(appRoot + File.separator + "resumes", fileNameOnly);
                    if (fallbackFile.exists()) {
                        file = fallbackFile;
                    } else {
                        File stableFolderFile = new File(System.getProperty("user.home")
                                + File.separator + "placement_resumes", fileNameOnly);
                        if (stableFolderFile.exists()) {
                            file = stableFolderFile;
                        } else {
                            File cDriveFolderFile = new File("C:" + File.separator + "placement_resumes", fileNameOnly);
                            if (cDriveFolderFile.exists()) {
                                file = cDriveFolderFile;
                            } else {
                                response.getWriter().write("Resume file not found at: " + resumePath);
                                return;
                            }
                        }
                    }
                }

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

                try (FileInputStream fis = new FileInputStream(file);
                     OutputStream os = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fis.read(buffer)) != -1) {
                        os.write(buffer, 0, bytesRead);
                    }
                }
            } else {
                response.getWriter().write("No student found for this enrollment number.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
