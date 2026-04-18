package com.me.finaldesignproject;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class AdminAnalyticsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        double placementRate = 0.0;
        double averageSalary = 0.0;
        List<Map<String, Object>> recruiterTrends = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            // 1. Calculate Placement Rate
            String rateSql = "SELECT (SELECT COUNT(DISTINCT enrollment_no) FROM applications WHERE status = 'Placed') * 100.0 / " +
                             "(SELECT COUNT(*) FROM students) as rate";
            Statement stmtRate = conn.createStatement();
            ResultSet rsRate = stmtRate.executeQuery(rateSql);
            if (rsRate.next()) {
                placementRate = rsRate.getDouble("rate");
            }
            rsRate.close();
            stmtRate.close();

            // 2. Calculate Average Salary
            String salarySql = "SELECT AVG(salary_offered) as avg_salary FROM applications WHERE status = 'Placed'";
            Statement stmtSalary = conn.createStatement();
            ResultSet rsSalary = stmtSalary.executeQuery(salarySql);
            if (rsSalary.next()) {
                averageSalary = rsSalary.getDouble("avg_salary");
            }
            rsSalary.close();
            stmtSalary.close();

            // 3. Recruiter Trends (Placements per company)
            String trendsSql = "SELECT c.company_name, COUNT(a.enrollment_no) as placed_count " +
                               "FROM companies c JOIN applications a ON c.company_id = a.company_id " +
                               "WHERE a.status = 'Placed' " +
                               "GROUP BY c.company_id, c.company_name " +
                               "ORDER BY placed_count DESC";
            Statement stmtTrends = conn.createStatement();
            ResultSet rsTrends = stmtTrends.executeQuery(trendsSql);
            while (rsTrends.next()) {
                Map<String, Object> trend = new HashMap<>();
                trend.put("company_name", rsTrends.getString("company_name"));
                trend.put("placed_count", rsTrends.getInt("placed_count"));
                recruiterTrends.add(trend);
            }
            rsTrends.close();
            stmtTrends.close();

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error calculating analytics: " + e.getMessage());
        }

        request.setAttribute("placementRate", placementRate);
        request.setAttribute("averageSalary", averageSalary);
        request.setAttribute("recruiterTrends", recruiterTrends);
        RequestDispatcher rd = request.getRequestDispatcher("admin_analytics.jsp");
        rd.forward(request, response);
    }
}
