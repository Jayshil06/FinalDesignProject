package com.me.finaldesignproject;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;



public class AdminLogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalidate the admin session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Clear JWT tokens from client-side storage
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<script>");
        response.getWriter().println("localStorage.removeItem('jwt_token');");
        response.getWriter().println("sessionStorage.removeItem('jwt_token');");
        response.getWriter().println("window.top.location.href = 'index.html';");
        response.getWriter().println("</script>");
        response.getWriter().println("</body></html>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
