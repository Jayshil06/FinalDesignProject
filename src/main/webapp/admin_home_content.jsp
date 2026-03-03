<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            margin: 0;
            padding: 50px 30px;
            text-align: center;
        }

        .welcome {
            max-width: 850px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 60px 40px;
            border-radius: 18px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.35);
        }

        .welcome h1 {
            color: #f9ca24;
            font-size: 38px;
            margin-bottom: 25px;
        }

        .welcome p {
            font-size: 17px;
            color: #e0e0e0;
            line-height: 1.7;
            margin-bottom: 18px;
        }

        .highlight {
            color: #00bcd4;
            font-weight: 600;
        }

        .welcome-icon {
            font-size: 60px;
            margin-bottom: 25px;
            color: #f9ca24;
        }

        footer {
            margin-top: 60px;
            font-size: 13px;
            color: #ccc;
        }
    </style>
</head>
<body>

    <div class="welcome">
        <div class="welcome-icon">📊</div>
        <h1>Hello Admin, Welcome Back!</h1>
        <p>
            You’ve entered the <span class="highlight">Admin Control Center</span> of the Design Engineering Portal.
        </p>
        <p>
            From managing student profiles and tracking job applications to overseeing company details — everything is right at your fingertips.
        </p>
        <p>
            Navigate using the top menu to explore <span class="highlight">Student Management</span>, <span class="highlight">Company Listings</span>, and the <span class="highlight">Application Dashboard</span>.
        </p>
        <p>
            Stay organized, stay informed, and make an impact 🚀
        </p>
    </div>

    <footer>
        &copy; <%= java.time.Year.now() %> Design Engineering Portal · Crafted for seamless admin control.
    </footer>

</body>
</html>
