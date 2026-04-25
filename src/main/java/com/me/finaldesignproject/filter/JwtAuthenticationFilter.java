package com.me.finaldesignproject.filter;

import com.me.finaldesignproject.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/company/*", "/student/*"})
public class JwtAuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();
        String token = httpRequest.getHeader("Authorization");

        // Allow login and register pages without authentication
        if (path.contains("login") || path.contains("register") || path.endsWith(".jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Check for JWT token
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);

            try {
                // Validate token
                String subject = JwtUtil.extractSubject(token);
                String role = JwtUtil.extractClaim(token, "role");
                int userId = JwtUtil.extractClaimAsInt(token, "user_id");

                // Set user info in request attributes
                httpRequest.setAttribute("user_id", userId);
                httpRequest.setAttribute("user_role", role);
                httpRequest.setAttribute("user_subject", subject);

                // Also set in session for backward compatibility
                HttpSession session = httpRequest.getSession();
                session.setAttribute("authenticated", true);
                session.setAttribute("user_id", userId);
                session.setAttribute("user_role", role);

                chain.doFilter(request, response);

            } catch (Exception e) {
                // Invalid token
                httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                httpResponse.setContentType("application/json");
                httpResponse.getWriter().write("{\"error\": \"Invalid or expired token\"}");
            }
        } else {
            // No token provided
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write("{\"error\": \"Authorization token required\"}");
        }
    }

    @Override
    public void destroy() {
    }
}