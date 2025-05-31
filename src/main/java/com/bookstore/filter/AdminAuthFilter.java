package com.bookstore.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Các trang không cần authentication
        if (requestURI.endsWith("/admin/login.jsp") || 
            requestURI.endsWith("/admin/login") ||
            requestURI.contains("/css/") ||
            requestURI.contains("/js/") ||
            requestURI.contains("/images/")) {
            
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra session
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = false;
        boolean isAdmin = false;
        
        if (session != null) {
            Boolean loggedIn = (Boolean) session.getAttribute("isLoggedIn");
            String userRole = (String) session.getAttribute("userRole");
            
            isLoggedIn = loggedIn != null && loggedIn;
            isAdmin = "admin".equals(userRole);
        }
        
        if (isLoggedIn && isAdmin) {
            // User đã đăng nhập và là admin, cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập hoặc không phải admin, chuyển hướng đến login
            System.out.println("Access denied for: " + requestURI + " - Not authenticated as admin");
            httpResponse.sendRedirect(contextPath + "/admin/login.jsp?error=access_denied");
        }
    }
}