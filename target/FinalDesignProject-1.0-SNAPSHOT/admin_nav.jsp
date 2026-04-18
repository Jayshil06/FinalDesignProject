<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Navigation</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #fff;
            animation: fadeInBody 0.7s ease;
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
            margin-right: 40px;
            font-size: 24px;
            color: #f9ca24;
            font-weight: 600;
        }

        .navbar a {
            margin: 0 12px;
            color: #ecf0f1;
            text-decoration: none;
            font-size: 16px;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .navbar a:hover {
            background-color: #00b894;
            color: #fff;
            transform: scale(1.05);
        }

     .logout-btn {
    background: linear-gradient(135deg, #1e3c72, #2a5298);
    color: #f1f1f1;
    border: none;
    font-size: 15px;
    padding: 9px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    transition: background 0.3s ease, transform 0.2s ease;
}

.logout-btn:hover {
    background: linear-gradient(135deg, #163357, #244a7c);
    transform: scale(1.05);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.4);
}

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-18px); }
            to { opacity: 1; transform: translateY(0); }
        }


        @media screen and (max-width: 768px) {
            .navbar {
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
            }

            .navbar-left, .navbar-right {
                flex-direction: column;
                align-items: flex-start;
            }

            .navbar-left h2 {
                margin-bottom: 15px;
            }

            .navbar a, .logout-btn {
                margin-bottom: 10px;
                width: 100%;
                text-align: left;
            }
        }
    </style>

    <script>
        function confirmLogout(event) {
            if (!confirm("Are you sure you want to logout?")) {
                event.preventDefault();
            }
        }

        function loadSection(url, event) {
            event.preventDefault();
            try {
                var frame = parent.document.getElementsByName("contentFrame")[0];
                frame.src = url;
            } catch (e) {
                parent.frames["contentFrame"].location.href = url;
            }
        }
    </script>
</head>
<body>
    <div class="navbar">
        <div class="navbar-left">
            <h2>👨‍💼 Admin Panel</h2>
            <a href="#" onclick="loadSection('admin_home_content.jsp', event)">Dashboard</a>
            <a href="#" onclick="loadSection('AdminAnalyticsServlet', event)">Analytics</a>
            <a href="#" onclick="loadSection('admin_student_details.jsp', event)">Student Details</a>
            <a href="#" onclick="loadSection('admin_company_details.jsp', event)">Company Details</a>
            <a href="#" onclick="loadSection('company_applications.jsp', event)">Applications</a>
        </div>
        <div class="navbar-right">
            <form action="AdminLogoutServlet" method="get" style="margin: 0;" onsubmit="confirmLogout(event);">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
</body>
</html>
