<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Placement Analytics</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #fff;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
            color: #f9ca24;
            margin-bottom: 30px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .card {
            background: rgba(44, 62, 80, 0.95);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(6px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-10px);
        }
        .card h3 {
            margin: 0;
            font-size: 18px;
            color: #ecf0f1;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .card .value {
            font-size: 36px;
            font-weight: bold;
            color: #00b894;
            margin: 15px 0;
        }
        .trends-section {
            background: rgba(44, 62, 80, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(6px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .trends-section h2 {
            color: #f9ca24;
            margin-bottom: 20px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        th {
            background-color: rgba(0, 184, 148, 0.2);
            color: #00b894;
            font-weight: 600;
        }
        tr:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }
        .error-msg {
            background: #eb4d4b;
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Placement Analytics Dashboard</h1>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="stats-grid">
            <div class="card">
                <h3>Placement Rate</h3>
                <div class="value"><%= String.format("%.2f%%", (Double)request.getAttribute("placementRate")) %></div>
                <p>Percentage of students placed</p>
            </div>
            <div class="card">
                <h3>Avg. Package</h3>
                <div class="value"><%= String.format("₹ %.2f LPA", (Double)request.getAttribute("averageSalary")) %></div>
                <p>Average salary of placed candidates</p>
            </div>
        </div>

        <div class="trends-section">
            <h2>📈 Recruiter Trends (Placements by Company)</h2>
            <table>
                <thead>
                    <tr>
                        <th>Company Name</th>
                        <th>Students Placed</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, Object>> trends = (List<Map<String, Object>>)request.getAttribute("recruiterTrends");
                        if (trends != null && !trends.isEmpty()) {
                            for (Map<String, Object> trend : trends) {
                    %>
                        <tr>
                            <td><%= trend.get("company_name") %></td>
                            <td><%= trend.get("placed_count") %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="2" style="text-align:center;">No placement data available.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
