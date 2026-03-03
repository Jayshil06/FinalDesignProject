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
</head>
<frameset rows="20%,80%">
    <!-- Top Navigation Panel -->
    <frame src="admin_nav.jsp" name="navFrame" noresize scrolling="no">

    <!-- Main Content Area -->
    <frame src="admin_home_content.jsp" name="contentFrame">
</frameset>
<noframes>
    <body>
        Your browser does not support frames.
    </body>
</noframes>
</html>
