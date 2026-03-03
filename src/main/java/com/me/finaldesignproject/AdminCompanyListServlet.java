package com.me.finaldesignproject;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class AdminCompanyListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> companyList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/design_engineering_portal", "root", "root");

            String sql = "SELECT * FROM companies";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> company = new HashMap<>();
                company.put("company_id", rs.getString("company_id"));
                company.put("company_name", rs.getString("company_name"));
                company.put("position", rs.getString("position"));
                company.put("description", rs.getString("description"));
                company.put("requirements", rs.getString("requirements"));
                company.put("location", rs.getString("location"));
                company.put("salary", rs.getString("salary"));
                companyList.add(company);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching company data: " + e.getMessage());
        }

        request.setAttribute("companyList", companyList);
        RequestDispatcher rd = request.getRequestDispatcher("admin_company_list.jsp");
        rd.forward(request, response);
    }
}
