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
        if (requestURI.contains("/css/") ||
            requestURI.contains("/js/") ||
            requestURI.contains("/images/") ||
            requestURI.contains("/upload/")) {
            
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
            
            // Debug logging
            System.out.println("AdminAuthFilter - URI: " + requestURI);
            System.out.println("AdminAuthFilter - isLoggedIn: " + isLoggedIn + ", isAdmin: " + isAdmin);
            System.out.println("AdminAuthFilter - userRole: " + userRole);
        }
        
        if (isLoggedIn && isAdmin) {
            // User đã đăng nhập và là admin, cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập hoặc không phải admin, chuyển hướng đến login của client
            System.out.println("Access denied for: " + requestURI + " - Not authenticated as admin");
            
            // Lưu URL để redirect sau khi đăng nhập
            if (session != null) {
                session.setAttribute("redirectURL", requestURI);
            }
            
            // Redirect đến login.jsp của client với thông báo cần quyền admin
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=" + 
                                    java.net.URLEncoder.encode("Bạn cần đăng nhập với quyền quản trị để truy cập trang này.", "UTF-8"));
        }
    }
}