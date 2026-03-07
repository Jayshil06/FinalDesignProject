<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("company_id") == null) {
        response.sendRedirect("company_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Dashboard</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #fff;
            animation: fadeInBody 0.8s ease;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            background: rgba(44, 62, 80, 0.95);
            backdrop-filter: blur(6px);
            animation: slideDown 0.7s ease;
        }

        .navbar-left, .navbar-right {
            display: flex;
            align-items: center;
        }

        .navbar-left h2 {
            margin: 0;
            margin-right: 30px;
            font-size: 24px;
            color: #f9ca24;
            font-weight: 600;
        }

        .navbar a {
            margin: 0 8px;
            color: #ecf0f1;
            text-decoration: none;
            font-size: 15px;
            padding: 8px 14px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            background-color: #00b894;
            transform: scale(1.04);
        }

        .logout-btn {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #fff;
            border: none;
            font-size: 15px;
            padding: 9px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .logout-btn:hover {
            transform: translateY(-1px) scale(1.03);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.35);
        }

        .welcome-card {
            max-width: 900px;
            margin: 24px auto 14px;
            padding: 22px 26px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
            text-align: center;
            animation: fadeInUp 0.8s ease;
        }

        .welcome-card h3 {
            margin-top: 0;
            color: #f9ca24;
        }

        .content {
            height: calc(100vh - 210px);
            padding: 0 20px 20px;
        }

        iframe {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.03);
        }

        .hidden {
            display: none;
        }

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
    <script>
        function showDashboard(event) {
            if (event) {
                event.preventDefault();
            }
            document.getElementById("welcomeCard").classList.remove("hidden");
            document.getElementById("content").classList.add("hidden");
            document.getElementById("contentFrame").src = "about:blank";
        }

        function openSection(page, event) {
            if (event) {
                event.preventDefault();
            }
            document.getElementById("welcomeCard").classList.add("hidden");
            document.getElementById("content").classList.remove("hidden");
            document.getElementById("contentFrame").src = page;
        }

        function confirmLogout(event) {
            if (!confirm("Are you sure you want to logout?")) {
                event.preventDefault();
            }
        }
    </script>
</head>
<body>
    <div class="navbar">
        <div class="navbar-left">
            <h2>Company Dashboard</h2>
            <a href="#" onclick="showDashboard(event)">Dashboard</a>
            <a href="#" onclick="openSection('post_job.jsp', event)">Post Job Opening</a>
            <a href="#" onclick="openSection('view_applications.jsp', event)">View Applications</a>
            <a href="#" onclick="openSection('filter_students.jsp', event)">Filter Students</a>
        </div>
        <div class="navbar-right">
            <form action="CompanyLogoutServlet" method="get" style="margin: 0;" onsubmit="confirmLogout(event);">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <div class="welcome-card" id="welcomeCard">
        <h3>Welcome <%= session.getAttribute("company_name") %></h3>
        <p>
            Welcome to the Company Dashboard.
            You can post job openings, view student applications, and filter candidates.
        </p>
    </div>

    <div class="content hidden" id="content">
        <iframe id="contentFrame" name="contentFrame" src="about:blank"></iframe>
    </div>
</body>
</html>
