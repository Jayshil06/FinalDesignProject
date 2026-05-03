package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
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

        Connection conn = null;
        Statement stmtRate = null;
        ResultSet rsRate = null;
        Statement stmtSalary = null;
        ResultSet rsSalary = null;
        Statement stmtTrends = null;
        ResultSet rsTrends = null;

        try {
            conn = DBUtil.getConnection();

            // 1. Calculate Placement Rate
            String rateSql = "SELECT (SELECT COUNT(DISTINCT enrollment_no) FROM applications WHERE status = 'Placed') * 100.0 / " +
                             "(SELECT COUNT(*) FROM students) as rate";
            stmtRate = conn.createStatement();
            rsRate = stmtRate.executeQuery(rateSql);
            if (rsRate.next()) {
                placementRate = rsRate.getDouble("rate");
            }

            // 2. Calculate Average Salary
            String salarySql = "SELECT AVG(salary_offered) as avg_salary FROM applications WHERE status = 'Placed'";
            stmtSalary = conn.createStatement();
            rsSalary = stmtSalary.executeQuery(salarySql);
            if (rsSalary.next()) {
                averageSalary = rsSalary.getDouble("avg_salary");
            }

            // 3. Recruiter Trends (Placements per company)
            String trendsSql = "SELECT c.company_name, COUNT(a.enrollment_no) as placed_count " +
                               "FROM companies c JOIN applications a ON c.company_id = a.company_id " +
                               "WHERE a.status = 'Placed' " +
                               "GROUP BY c.company_id, c.company_name " +
                               "ORDER BY placed_count DESC";
            stmtTrends = conn.createStatement();
            rsTrends = stmtTrends.executeQuery(trendsSql);
            while (rsTrends.next()) {
                Map<String, Object> trend = new HashMap<>();
                trend.put("company_name", rsTrends.getString("company_name"));
                trend.put("placed_count", rsTrends.getInt("placed_count"));
                recruiterTrends.add(trend);
            }

        } catch (Exception e) {
            getServletContext().log("Error in AdminAnalyticsServlet", e);
            request.setAttribute("error", "Error calculating analytics: " + e.getMessage());
        } finally {
            DBUtil.close(null, stmtRate, rsRate);
            DBUtil.close(null, stmtSalary, rsSalary);
            DBUtil.close(conn, stmtTrends, rsTrends);
        }

        request.setAttribute("placementRate", placementRate);
        request.setAttribute("averageSalary", averageSalary);
        request.setAttribute("recruiterTrends", recruiterTrends);
        RequestDispatcher rd = request.getRequestDispatcher("admin_analytics.jsp");
        rd.forward(request, response);
    }
}
