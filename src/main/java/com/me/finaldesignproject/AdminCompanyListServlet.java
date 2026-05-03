package com.me.finaldesignproject;

import com.me.finaldesignproject.util.DBUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class AdminCompanyListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, String>> companyList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "SELECT * FROM companies";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

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

        } catch (Exception e) {
            getServletContext().log("Error in AdminCompanyListServlet", e);
            request.setAttribute("error", "Error fetching company data: " + e.getMessage());
        } finally {
            DBUtil.close(conn, ps, rs);
        }

        request.setAttribute("companyList", companyList);
        RequestDispatcher rd = request.getRequestDispatcher("admin_company_list.jsp");
        rd.forward(request, response);
    }
}
