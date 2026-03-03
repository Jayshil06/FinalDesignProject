package com.me.finaldesignproject;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Invalidate the current session
        HttpSession session = request.getSession(false); // avoid creating a new session
        if (session != null) {
            session.invalidate();
        }

        // Redirect to index.html
        response.sendRedirect("index.html");
    }

    // Optional: also handle POST if needed
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
