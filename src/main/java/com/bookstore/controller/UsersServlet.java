package com.bookstore.controller;

import java.io.IOException;

import com.bookstore.dao.UsersDAO;
import com.bookstore.model.Users;
import com.bookstore.tools.MD5;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/users")
public class UsersServlet extends HttpServlet {
    
    private final UsersDAO usersDAO = new UsersDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String command = request.getParameter("command");
        
        if ("logout".equals(command)) {
            handleLogout(request, response);
        } else {
            // Default redirect to home
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("UsersServlet doPost");
        
        String command = request.getParameter("command");
        String url = "";
        
        try {
            if ("insert".equals(command)) {
                handleRegistration(request, response);
            } else if ("login".equals(command)) {
                handleLogin(request, response);
            } else {
                // Unknown command
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            RequestDispatcher rd = getServletContext().getRequestDispatcher("/error.jsp");
            rd.forward(request, response);
        }
    }
    
    /**
     * Handle user registration with enhanced validation
     */
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String country = request.getParameter("country");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String terms = request.getParameter("terms");
        
        // Validation
        StringBuilder errors = new StringBuilder();
        
        // Required field validation
        if (email == null || email.trim().isEmpty()) {
            errors.append("Email is required. ");
        }
        if (fullname == null || fullname.trim().isEmpty()) {
            errors.append("Full name is required. ");
        }
        if (password == null || password.trim().isEmpty()) {
            errors.append("Password is required. ");
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.append("Password confirmation is required. ");
        }
        if (terms == null) {
            errors.append("You must agree to the terms and conditions. ");
        }
        
        // Email format validation
        if (email != null && !email.trim().isEmpty()) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                errors.append("Invalid email format. ");
            }
        }
        
        // Password validation
        if (password != null && password.length() < 6) {
            errors.append("Password must be at least 6 characters long. ");
        }
        
        // Password match validation
        if (password != null && confirmPassword != null && !password.equals(confirmPassword)) {
            errors.append("Passwords do not match. ");
        }
        
        // Phone validation (if provided)
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^[\\+]?[0-9\\s\\-\\(\\)]{10,20}$")) {
                errors.append("Invalid phone number format. ");
            }
        }
        
        // Check if email already exists
        if (email != null && !email.trim().isEmpty()) {
            if (usersDAO.checkEmail(email.trim())) {
                errors.append("Email address is already registered. ");
            }
        }
        
        // If there are validation errors, redirect back to register page
        if (errors.length() > 0) {
            System.out.println("Registration validation errors: " + errors.toString());
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=" + 
                                java.net.URLEncoder.encode(errors.toString().trim(), "UTF-8"));
            return;
        }
        
        try {
            // Create new user
            Users newUser = new Users();
            newUser.setUserID(System.currentTimeMillis()); // Generate unique ID
            newUser.setUserEmail(email.trim());
            newUser.setUserFullname(fullname.trim());
            newUser.setUserPhone(phone != null ? phone.trim() : null);
            newUser.setUserAddress(address != null ? address.trim() : null);
            newUser.setUserCountry(country != null ? country.trim() : null);
            newUser.setUserPass(MD5.encryption(password)); // Hash password
            newUser.setUserRole(false); // Default to customer
            
            // Insert user into database
            boolean success = usersDAO.insertUser(newUser);
            
            if (success) {
                // Registration successful
                System.out.println("User registered successfully: " + email);
                
                // Auto-login the user
                HttpSession session = request.getSession();
                session.setAttribute("user", newUser);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", "customer");
                session.setAttribute("userName", newUser.getDisplayName());
                session.setAttribute("userId", newUser.getUserID());
                
                // Redirect to success page or home
                response.sendRedirect(request.getContextPath() + "/index.jsp?success=" + 
                                    java.net.URLEncoder.encode("Registration successful! Welcome to BookStore.", "UTF-8"));
            } else {
                // Registration failed
                System.out.println("User registration failed: " + email);
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=" + 
                                    java.net.URLEncoder.encode("Registration failed. Please try again.", "UTF-8"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception during registration: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=" + 
                                java.net.URLEncoder.encode("An error occurred during registration. Please try again.", "UTF-8"));
        }
    }
    
    /**
     * Handle user login
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("pass"); // Note: parameter name is "pass" from login form
        
        System.out.println("Login attempt for email: " + email);
        
        // Validation
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
            return;
        }
        
        try {
            // Hash password and attempt login
            String hashedPassword = MD5.encryption(password);
            Users user = usersDAO.login(email.trim(), hashedPassword);
            
            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("userRole", user.isUserRole() ? "admin" : "customer");
                session.setAttribute("userName", user.getDisplayName());
                session.setAttribute("userId", user.getUserID());
                
                System.out.println("User login successful: " + email + " as " + 
                                 (user.isUserRole() ? "admin" : "customer"));
                
                // Redirect based on role
                if (user.isUserRole()) {
                    // Admin user
                    response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                } else {
                    // Regular customer
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } else {
                // Login failed
                System.out.println("Login failed for email: " + email);
                request.setAttribute("error", "Invalid email or password!");
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
                rd.forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception during login: " + e.getMessage());
            request.setAttribute("error", "An error occurred during login. Please try again.");
            RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
        }
    }
    
    /**
     * Handle user logout
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userEmail = null;
        
        if (session != null) {
            // Get user info before clearing session
            Users user = (Users) session.getAttribute("user");
            if (user != null) {
                userEmail = user.getUserEmail();
            }
            
            // Clear all session attributes
            session.removeAttribute("user");
            session.removeAttribute("isLoggedIn");
            session.removeAttribute("userRole");
            session.removeAttribute("userName");
            session.removeAttribute("userId");
            session.removeAttribute("cart");
            
            // Invalidate session
            session.invalidate();
            
            System.out.println("User logged out: " + userEmail);
        }
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/index.jsp?message=" + 
                            java.net.URLEncoder.encode("You have been logged out successfully.", "UTF-8"));
    }
    
    /**
     * Get servlet info
     */
    @Override
    public String getServletInfo() {
        return "Users Servlet for Registration and Login";
    }
}