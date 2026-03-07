<%@ page import="java.sql.*" %>
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
    <title>Post Job Opening</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: #f0f0f0;
            margin: 0;
            padding: 30px 20px;
            animation: fadeInBody 0.7s ease;
        }

        .card {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(8px);
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
            animation: fadeInUp 0.8s ease;
        }

        h2 {
            text-align: center;
            color: #f9ca24;
            margin-top: 0;
            animation: slideDown 0.7s ease;
        }

        .msg {
            text-align: center;
            font-weight: 500;
        }

        .success { color: #95ffb9; }
        .error { color: #ff8f8f; }

        label {
            display: block;
            margin-top: 12px;
            margin-bottom: 6px;
        }

        input, textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 10px;
            border: none;
            border-radius: 8px;
            outline: none;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        input:focus, textarea:focus {
            box-shadow: 0 0 0 2px rgba(0, 188, 212, 0.45);
            transform: translateY(-1px);
        }

        textarea {
            min-height: 140px;
            resize: vertical;
        }

        button {
            width: 100%;
            margin-top: 16px;
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

        @keyframes fadeInBody {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<%
    String jobRole = "";
    String jobDescription = "";
    String cgpaValue = "";
%>
    <div class="card">
        <h2>Post Job Opening</h2>

        <% if ("1".equals(request.getParameter("success"))) { %>
            <p class="msg success">Job details saved successfully.</p>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <p class="msg error">Unable to save job details. Please verify inputs and try again.</p>
        <% } %>

        <form action="PostJobServlet" method="post" autocomplete="off">
            <label>Job Role</label>
            <input type="text" name="job_role" value="<%= jobRole %>" autocomplete="off" required>

            <label>CGPA Required</label>
            <input type="number" step="0.01" min="0" max="10" name="cgpa_required" value="<%= cgpaValue %>" autocomplete="off" required>

            <label>Job Description</label>
            <textarea name="job_description" autocomplete="off" required><%= jobDescription %></textarea>

            <button type="submit">Save Job Opening</button>
        </form>
    </div>
</body>
</html>
