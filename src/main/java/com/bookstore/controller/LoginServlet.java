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

    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        System.out.println("LoginServlet POST - Action: " + action);
        
        if ("admin_login".equals(action)) {
            handleAdminLogin(request, response);
        } else if ("customer_login".equals(action)) {
            handleCustomerLogin(request, response);
        } else {
            // Default: general login (auto-detect role)
            handleGeneralLogin(request, response);
        }
    }
    
    /**
     * Handle general login - auto-detect if user is admin or customer
     */
    private void handleGeneralLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("pass"); // From login form
        String rememberMe = request.getParameter("rememberMe");
        
        System.out.println("General login attempt - Email: " + email);
        
        try {
            // Validate input
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Empty fields detected");
                redirectToLoginWithError(request, response, "Email and password are required", email);
                return;
            }
            
            // Validate email format
            if (!isValidEmail(email.trim())) {
                System.out.println("Invalid email format: " + email);
                redirectToLoginWithError(request, response, "Invalid email format", email);
                return;
            }
            
            // Hash password
            String hashedPassword = md5Hash(password);
            System.out.println("Password hashed for user: " + email);
            
            // Check login
            Users user = usersDAO.getUserByEmailAndPassword(email.trim(), hashedPassword);
            
            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("isLoggedIn", true);
                
                // Check if there's a redirect URL (for both admin and customer)
                String redirectURL = (String) session.getAttribute("redirectURL");
                
                if (user.isUserRole()) {
                    // Admin user
                    session.setAttribute("admin", user);
                    session.setAttribute("userRole", "admin");
                    session.setAttribute("userName", user.getDisplayName());
                    session.setAttribute("userId", user.getUserID());
                    
                    System.out.println("Admin logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                    
                    // Redirect admin
                    if (redirectURL != null && !redirectURL.isEmpty()) {
                        session.removeAttribute("redirectURL");
                        System.out.println("Admin redirecting to saved URL: " + redirectURL);
                        response.sendRedirect(redirectURL);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                    }
                    
                } else {
                    // Customer user
                    session.setAttribute("customer", user);
                    session.setAttribute("userRole", "customer");
                    session.setAttribute("userName", user.getDisplayName());
                    session.setAttribute("userId", user.getUserID());
                    
                    System.out.println("Customer logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                    
                    // Redirect customer
                    if (redirectURL != null && !redirectURL.isEmpty()) {
                        session.removeAttribute("redirectURL");
                        System.out.println("Customer redirecting to saved URL: " + redirectURL);
                        response.sendRedirect(redirectURL);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                }
                
            } else {
                // Login failed
                System.out.println("Login failed for email: " + email);
                redirectToLoginWithError(request, response, "Invalid email or password", email);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception during login: " + e.getMessage());
            redirectToLoginWithError(request, response, "An error occurred during login. Please try again.", email);
        }
    }
    
    /**
     * Handle admin-specific login (DEPRECATED - keeping for backward compatibility)
     */
    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Admin login attempt - Email: " + email);
        
        try {
            // Validate input
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                System.out.println("Empty fields detected");
                redirectToLoginWithError(request, response, "Email and password are required", email);
                return;
            }
            
            // Hash password
            String hashedPassword = md5Hash(password);
            System.out.println("Password hashed: " + hashedPassword);
            
            // Check login
            Users user = usersDAO.getUserByEmailAndPassword(email.trim(), hashedPassword);
            
            if (user != null && user.isUserRole()) { // Must be admin
                // Admin login successful
                HttpSession session = request.getSession();
                session.setAttribute("admin", user);
                session.setAttribute("user", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", "admin");
                session.setAttribute("userName", user.getDisplayName());
                session.setAttribute("userId", user.getUserID());
                
                System.out.println("Admin logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                
                // Check redirect URL for admin
                String redirectURL = (String) session.getAttribute("redirectURL");
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    session.removeAttribute("redirectURL");
                    response.sendRedirect(redirectURL);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                }
                
            } else {
                // Admin login failed
                System.out.println("Admin login failed for email: " + email);
                redirectToLoginWithError(request, response, "Invalid email or password. Admin access required.", email);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectToLoginWithError(request, response, "An error occurred during login. Please try again.", email);
        }
    }
    
    /**
     * Handle customer-specific login
     */
    private void handleCustomerLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Customer login attempt - Email: " + email);
        
        try {
            // Validate input
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                redirectToLoginWithError(request, response, "Email and password are required", email);
                return;
            }
            
            // Hash password
            String hashedPassword = md5Hash(password);
            
            // Check login
            Users user = usersDAO.getUserByEmailAndPassword(email.trim(), hashedPassword);
            
            if (user != null && !user.isUserRole()) { // Must be customer
                // Customer login successful
                HttpSession session = request.getSession();
                session.setAttribute("customer", user);
                session.setAttribute("user", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", "customer");
                session.setAttribute("userName", user.getDisplayName());
                session.setAttribute("userId", user.getUserID());
                
                System.out.println("Customer logged in: " + user.getUserEmail() + " at " + new java.util.Date());
                
                // Check redirect URL for customer
                String redirectURL = (String) session.getAttribute("redirectURL");
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    session.removeAttribute("redirectURL");
                    response.sendRedirect(redirectURL);
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
                
            } else {
                // Customer login failed
                System.out.println("Customer login failed for email: " + email);
                redirectToLoginWithError(request, response, "Invalid email or password", email);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectToLoginWithError(request, response, "An error occurred during login. Please try again.", email);
        }
    }
    
    /**
     * Redirect to login page with error message
     */
    private void redirectToLoginWithError(HttpServletRequest request, HttpServletResponse response, 
                                        String errorMessage, String email) throws IOException {
        String encodedError = java.net.URLEncoder.encode(errorMessage, "UTF-8");
        String encodedEmail = email != null ? java.net.URLEncoder.encode(email, "UTF-8") : "";
        
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=" + encodedError + 
                            (email != null ? "&email=" + encodedEmail : ""));
    }
    
    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
    
    /**
     * MD5 hash function
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
        return "Enhanced Login Servlet for Admin and Customer with Email Authentication and Redirect Support";
    }
}