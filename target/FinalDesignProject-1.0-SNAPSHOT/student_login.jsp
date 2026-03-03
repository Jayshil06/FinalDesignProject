<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Login</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0c0c36, #123456, #1c5d82);
            color: #f0f0f0;
            margin: 0;
            min-height: 100vh;
            padding: 60px 20px;
            text-align: center;
            overflow: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            top: 50%;
            left: 50%;
            width: 600px;
            height: 600px;
            background: url('handshake-logo.jpeg') no-repeat center center;
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

        h2 {
            font-size: 36px;
            color: #f9ca24;
            margin-bottom: 30px;
            animation: slideDown 1s ease forwards;
        }

        @keyframes slideDown {
            0% { opacity: 0; transform: translateY(-30px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        form {
            display: inline-block;
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.35);
            position: relative;
            z-index: 1;
            animation: fadeIn 1.2s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .input-group {
            position: relative;
            margin: 15px 0;
        }

        .input-group i {
            position: absolute;
            top: 50%;
            left: 12px;
            transform: translateY(-50%);
            color: #ccc;
        }

        input[type="email"], input[type="password"] {
            width: 280px;
            padding: 12px 15px 12px 40px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
            outline: none;
            transition: border 0.3s ease, box-shadow 0.3s ease;
        }

        input[type="email"]:focus, input[type="password"]:focus {
            border-color: #00bcd4;
            box-shadow: 0 0 5px rgba(0, 188, 212, 0.5);
        }

        input[type="submit"] {
            margin-top: 20px;
            padding: 12px 28px;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        input[type="submit"]:hover {
            background: linear-gradient(135deg, #163357, #244a7c);
            transform: scale(1.05);
        }

        .error {
            color: #ff6b6b;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .signup-link {
            margin-top: 20px;
            display: block;
            font-size: 14px;
            color: #dcdcdc;
        }

        .signup-link a {
            color: #00bcd4;
            text-decoration: none;
            font-weight: 500;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        @media screen and (max-width: 480px) {
            input[type="email"], input[type="password"] {
                width: 90%;
            }

            form {
                width: 90%;
            }
        }
    </style>
</head>
<body>

    <h2>Student Login</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="StudentLoginServlet">
        <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" name="email" placeholder="Enter Student Email" required>
        </div>
        <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" placeholder="Enter Password" required>
        </div>
        <input type="submit" value="Login">
        <p class="signup-link">Don't have an account? <a href="student_register.jsp">Create one</a></p>
    </form>

</body>
</html>
