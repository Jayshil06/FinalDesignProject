package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CompanyRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String companyName = request.getParameter("company_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String jobRole = request.getParameter("job_role");
        String cgpaRequiredStr = request.getParameter("cgpa_required");
        String jobDescription = request.getParameter("job_description");

        double cgpaRequired;
        try {
            cgpaRequired = Double.parseDouble(cgpaRequiredStr);
        } catch (Exception e) {
            request.setAttribute("error", "Please enter a valid CGPA value.");
            RequestDispatcher rd = request.getRequestDispatcher("company_register.jsp");
            rd.forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "INSERT INTO companies (company_name, email, password, job_role, cgpa_required, job_description, posted_date) "
                    + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            ps = conn.prepareStatement(sql);
            ps.setString(1, companyName);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, jobRole);
            ps.setDouble(5, cgpaRequired);
            ps.setString(6, jobDescription);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("company_login.jsp?registered=success");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                RequestDispatcher rd = request.getRequestDispatcher("company_register.jsp");
                rd.forward(request, response);
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("error", "Email already exists. Please use a different email.");
            RequestDispatcher rd = request.getRequestDispatcher("company_register.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Database error in CompanyRegisterServlet", e);
            request.setAttribute("error", "Error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("company_register.jsp");
            rd.forward(request, response);
        } finally {
            DBUtil.close(conn, ps);
        }
    }
}
