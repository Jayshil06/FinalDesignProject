<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Login</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 25px;
            overflow: hidden;
            animation: fadeInBody 0.9s ease;
        }

        body::before {
            content: "";
            position: fixed;
            top: 50%;
            left: 50%;
            width: 540px;
            height: 540px;
            background: url('images/handshake-logo.jpg') no-repeat center center;
            background-size: cover;
            border-radius: 50%;
            opacity: 0.08;
            transform: translate(-50%, -50%);
            z-index: 0;
            animation: pulse 8s ease-in-out infinite;
            pointer-events: none;
        }

        .form-card {
            width: 100%;
            max-width: 430px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(8px);
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.9s ease;
        }

        h2 {
            margin-top: 0;
            text-align: center;
            color: #f9ca24;
            animation: slideDown 0.7s ease;
        }

        .msg {
            text-align: center;
            color: #95ffb9;
            font-weight: 500;
        }

        .error {
            color: #ff8080;
            text-align: center;
            font-weight: 500;
        }

        label {
            display: block;
            margin-top: 12px;
            margin-bottom: 6px;
        }

        input {
            width: 100%;
            box-sizing: border-box;
            padding: 10px;
            border: none;
            border-radius: 8px;
            outline: none;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        input:focus {
            box-shadow: 0 0 0 2px rgba(0, 188, 212, 0.45);
            transform: translateY(-1px);
        }

        button {
            width: 100%;
            margin-top: 18px;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        button:hover {
            transform: translateY(-2px) scale(1.01);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.35);
        }

        .links {
            margin-top: 12px;
            text-align: center;
        }

        .links a {
            color: #7ed6ff;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); }
            50% { transform: translate(-50%, -50%) scale(1.06); }
        }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Company Login</h2>

        <% if ("success".equals(request.getParameter("registered"))) { %>
            <p class="msg">Registration successful. Please login.</p>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form method="post" action="CompanyLoginServlet">
            <label>Email</label>
            <input type="email" name="email" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <div class="links">
            <a href="company_register.jsp">New recruiter? Register</a>
        </div>
    </div>
</body>
</html>
