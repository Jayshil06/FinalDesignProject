package com.me.finaldesignproject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;

public class ApplyCompanyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");
        String companyIdStr = request.getParameter("company_id");
        String cgpaStr = request.getParameter("cgpa");

        if (enrollmentNo == null || companyIdStr == null || enrollmentNo.isEmpty() || companyIdStr.isEmpty()) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        int companyId = Integer.parseInt(companyIdStr);
        double cgpa;
        try {
            cgpa = Double.parseDouble(cgpaStr);
            if (cgpa < 0 || cgpa > 10) {
                throw new NumberFormatException("Invalid CGPA range");
            }
        } catch (Exception e) {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<html><head><script>");
            out.println("alert('Please enter a valid CGPA between 0 and 10.');");
            out.println("window.history.back();");
            out.println("</script></head><body></body></html>");
            return;
        }

        boolean isSuccess = false;
        boolean isDuplicate = false;
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            PreparedStatement updateStudent = conn.prepareStatement(
                    "UPDATE students SET cgpa = ? WHERE enrollment_no = ?");
            updateStudent.setDouble(1, cgpa);
            updateStudent.setString(2, enrollmentNo);
            updateStudent.executeUpdate();
            updateStudent.close();

            PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO applications (enrollment_no, company_id, application_date) VALUES (?, ?, ?)");
            pstmt.setString(1, enrollmentNo);
            pstmt.setInt(2, companyId);
            pstmt.setDate(3, Date.valueOf(LocalDate.now()));

            int rows = pstmt.executeUpdate();
            isSuccess = rows > 0;

            pstmt.close();
        } catch (SQLIntegrityConstraintViolationException dup) {
            isDuplicate = true;
        } catch (Exception e) {
            isSuccess = false;
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><script>");

        if (isDuplicate) {
            out.println("alert('⚠️ You have already applied to this company.');");
        } else if (isSuccess) {
            out.println("alert('✅ Application submitted successfully!');");
        } else {
            out.println("alert('❌ Failed to submit application.');");
        }

        // Close two tabs: the apply form tab and the company details tab (parent of opener)
        out.println("if (window.opener && window.opener.opener) {");
        out.println("    window.opener.opener.location.reload();"); // refresh grandparent
        out.println("    window.opener.close();"); // close company_details.jsp
        out.println("}");
        out.println("window.close();"); // close apply_form.jsp

        out.println("</script></head><body></body></html>");
    }
}
