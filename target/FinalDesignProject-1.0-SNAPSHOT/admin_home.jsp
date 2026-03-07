<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            background: #141e30;
        }
    </style>
    <script>
        function animateAdminContent() {
            try {
                var frame = document.getElementsByName("contentFrame")[0];
                frame.style.opacity = "1";
            } catch (e) {
            }
        }
    </script>
</head>
<frameset rows="20%,80%" frameborder="0" border="0" framespacing="0">
    <!-- Top Navigation Panel -->
    <frame src="admin_nav.jsp" name="navFrame" noresize scrolling="no" frameborder="0" marginwidth="0" marginheight="0">

    <!-- Main Content Area -->
    <frame src="admin_home_content.jsp" name="contentFrame" style="opacity:1;" onload="animateAdminContent();" frameborder="0" marginwidth="0" marginheight="0">
</frameset>
<noframes>
    <body>
        Your browser does not support frames.
    </body>
</noframes>
</html>
