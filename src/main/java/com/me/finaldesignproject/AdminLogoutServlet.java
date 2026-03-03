package com.me.finaldesignproject;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;



public class AdminLogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalidate the admin session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redirect out of the frame to index.html
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<script>window.top.location.href = 'index.html';</script>");
        response.getWriter().println("</body></html>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
