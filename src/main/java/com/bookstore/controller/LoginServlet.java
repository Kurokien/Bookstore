package com.bookstore.controller;

import com.bookstore.dao.UsersDAO;
import com.bookstore.model.Users;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet", "/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Test servlet đang hoạt động
        response.getWriter().println("<h1>LoginServlet is working!</h1>");
        response.getWriter().println("<p>Available actions:</p>");
        response.getWriter().println("<ul>");
        response.getWriter().println("<li><a href='" + request.getContextPath() + "/admin/login.jsp'>Admin Login</a></li>");
        response.getWriter().println("<li><a href='" + request.getContextPath() + "/login.jsp'>Customer Login</a></li>");
        response.getWriter().println("</ul>");
        
        System.out.println("LoginServlet GET accessed at: " + new java.util.Date());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        System.out.println("LoginServlet POST - Action: " + action);
        
        if ("admin_login".equals(action)) {
            handleAdminLogin(request, response);
        } else if ("customer_login".equals(action)) {
            handleCustomerLogin(request, response);
        } else {
            // Default: chuyển về admin login
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        }
    }
    
    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Admin login attempt - Email: " + email);
        
        try {
            // Validate input
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Empty fields detected");
                response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=empty_fields");
                return;
            }
            
            // Mã hóa password bằng MD5
            String hashedPassword = md5Hash(password);
            System.out.println("Password hashed: " + hashedPassword);
            
            // Kiểm tra đăng nhập
            UsersDAO userDAO = new UsersDAO();
            Users user = userDAO.getUserByEmailAndPassword(email.trim(), hashedPassword);
            
            if (user != null && user.isUserRole()) { // isUserRole() = true có nghĩa là admin
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("admin", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", "admin");
                session.setAttribute("userName", user.getUserEmail());
                session.setAttribute("userId", user.getUserID());
                
                // Log thông tin đăng nhập
                System.out.println("Admin logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                
                // Chuyển hướng đến trang admin
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                
            } else {
                // Đăng nhập thất bại
                System.out.println("Login failed for email: " + email);
                response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=invalid&email=" + email);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=system_error");
        }
    }
    
    private void handleCustomerLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Customer login attempt - Email: " + email);
        
        try {
            // Validate input
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=empty_fields");
                return;
            }
            
            // Mã hóa password
            String hashedPassword = md5Hash(password);
            
            // Kiểm tra đăng nhập
            UsersDAO userDAO = new UsersDAO();
            Users user = userDAO.getUserByEmailAndPassword(email.trim(), hashedPassword);
            
            if (user != null && !user.isUserRole()) { // isUserRole() = false nghĩa là customer
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("customer", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", "customer");
                session.setAttribute("userName", user.getUserEmail());
                session.setAttribute("userId", user.getUserID());
                
                // Log thông tin đăng nhập
                System.out.println("Customer logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                
                // Chuyển hướng về trang chủ
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                
            } else {
                // Đăng nhập thất bại
                System.out.println("Customer login failed for email: " + email);
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid&email=" + email);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=system_error");
        }
    }
    
    /**
     * Mã hóa password bằng MD5
     */
    private String md5Hash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet for Admin and Customer";
    }
}