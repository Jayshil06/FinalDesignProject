package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;

public class ApplyCompanyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String enrollmentNo = request.getParameter("enrollment_no");
        String companyIdStr = request.getParameter("company_id");

        if (enrollmentNo == null || companyIdStr == null || enrollmentNo.isEmpty() || companyIdStr.isEmpty()) {
            response.sendRedirect("student_login.jsp");
            return;
        }

        int companyId = Integer.parseInt(companyIdStr);
        boolean isSuccess = false;
        boolean isDuplicate = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO applications (enrollment_no, company_id, application_date) VALUES (?, ?, ?)");
            pstmt.setString(1, enrollmentNo);
            pstmt.setInt(2, companyId);
            pstmt.setDate(3, Date.valueOf(LocalDate.now()));

            int rows = pstmt.executeUpdate();
            isSuccess = rows > 0;

            pstmt.close();
            conn.close();
        } catch (SQLIntegrityConstraintViolationException dup) {
            isDuplicate = true;
        } catch (Exception e) {
            isSuccess = false;
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
