<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Selection - Online Placement Management System</title>
    <style>
        body {
            position: relative;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0c0c36, #123456, #1c5d82);
            color: #f0f0f0;
            text-align: center;
            padding: 60px 20px;
            min-height: 100vh;
            overflow: hidden;
            animation: fadeInBody 1.2s ease-in-out;
            justify-content: center;
        }

        @keyframes fadeInBody {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        body::before {
            content: "";
            position: fixed;
            top: 50%;
            left: 50%;
            width: 600px;
            height: 600px;
            background: url('images/handshake-logo.jpg') no-repeat center center;
            background-size: cover;
            border-radius: 50%;
            opacity: 0.10;
            transform: translate(-50%, -50%) scale(1);
            z-index: 0;
            pointer-events: none;
            animation: pulse 8s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: translate(-50%, -50%) scale(1);
            }
            50% {
                transform: translate(-50%, -50%) scale(1.05);
            }
        }

        h2, .role-box {
            position: relative;
            z-index: 1;
        }

        h2 {
            font-size: 36px;
            color: #ffcc80;
            margin-bottom: 40px;
            animation: slideDown 1s ease forwards;
        }

        @keyframes slideDown {
            0% { opacity: 0; transform: translateY(-30px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .role-box {
            margin-top: 30px;
            animation: fadeInRoles 1.2s ease-in-out;
        }

        @keyframes fadeInRoles {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .btn {
            position: relative;
            padding: 14px 32px;
            font-size: 18px;
            margin: 15px;
            text-decoration: none;
            color: #fff;
            border-radius: 8px;
            display: inline-block;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
            overflow: visible;
        }

        .btn::after {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%) translateY(0);
            top: 100%;
            opacity: 0;
            font-size: 50px;  /* Increased size of the emoji */
            color: #ffeaa7;
            transition: all 0.4s ease;
            margin-top: 6px;
            white-space: nowrap;
        }

        .admin-btn::after {
            content: "👨‍💼";
        }

        .student-btn::after {
            content: "🎓";
        }

        .btn:hover::after {
            opacity: 1;
            transform: translateX(-50%) translateY(10px);
        }

        .admin-btn {
            background: #2196f3;
        }

        .student-btn {
            background: #43a047;
        }

        .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }

        @media (max-width: 600px) {
            h2 {
                font-size: 28px;
            }

            .btn {
                padding: 12px 24px;
                font-size: 16px;
            }

            body::before {
                width: 200px;
                height: 200px;
            }

            .btn::after {
                font-size: 24px;  /* Slightly reduced on smaller screens */
            }
        }
    </style>
</head>
<body>

    <h2>Select Login Role</h2>
    
    <div class="role-box">
        <a href="admin_login.jsp" class="btn admin-btn">Admin Login</a>
        <a href="student_login.jsp" class="btn student-btn">Student Login</a>
    </div>

</body>
</html>