package com.bookstore.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet", "/logout", "/admin/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }
    
    /**
     * Xử lý đăng xuất cho cả admin và customer
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userEmail = null;
        String userRole = null;
        boolean wasLoggedIn = false;
        
        if (session != null) {
            // Lấy thông tin user trước khi xóa session
            userEmail = (String) session.getAttribute("userName");
            userRole = (String) session.getAttribute("userRole");
            wasLoggedIn = session.getAttribute("isLoggedIn") != null;
            
            // Log thông tin đăng xuất
            if (wasLoggedIn && userEmail != null) {
                System.out.println("User logged out: " + userEmail + " (" + userRole + ") at " + new java.util.Date());
            }
            
            // Xóa tất cả session attributes
            session.removeAttribute("admin");
            session.removeAttribute("customer");
            session.removeAttribute("isLoggedIn");
            session.removeAttribute("userRole");
            session.removeAttribute("userName");
            session.removeAttribute("userId");
            session.removeAttribute("cart");
            session.removeAttribute("redirectURL");
            
            // Hủy session hoàn toàn
            session.invalidate();
        }
        
        // Ngăn browser cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Xác định trang chuyển hướng dựa trên role
        String redirectPage;
        if ("admin".equals(userRole)) {
            redirectPage = request.getContextPath() + "/admin/login.jsp?message=logout_success";
        } else {
            redirectPage = request.getContextPath() + "/index.jsp?message=logout_success";
        }
        
        // Chuyển hướng với thông báo thành công
        response.sendRedirect(redirectPage);
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet for Admin and Customer";
    }
}