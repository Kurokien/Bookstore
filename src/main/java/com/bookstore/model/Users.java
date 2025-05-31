package com.bookstore.model;

import java.util.Date;

public class Users {
    
    // ==================== FIELDS ====================
    private long userID;
    private String userEmail;
    private String userPass;
    private boolean userRole; // true = admin, false = customer
    
    // ==================== CONSTRUCTORS ====================
    
    /**
     * Default constructor
     */
    public Users() {
    }

    /**
     * Constructor with all fields
     */
    public Users(long userID, String userEmail, String userPass, boolean userRole) {
        this.userID = userID;
        this.userEmail = userEmail;
        this.userPass = userPass;
        this.userRole = userRole;
    }

    /**
     * Constructor without ID (for new users)
     */
    public Users(String userEmail, String userPass, boolean userRole) {
        this.userEmail = userEmail;
        this.userPass = userPass;
        this.userRole = userRole;
    }

    /**
     * Constructor for customer registration (userRole = false by default)
     */
    public Users(String userEmail, String userPass) {
        this.userEmail = userEmail;
        this.userPass = userPass;
        this.userRole = false; // Default to customer
    }

    // ==================== GETTERS & SETTERS ====================

    public long getUserID() {
        return userID;
    }

    public void setUserID(long userID) {
        this.userID = userID;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserPass() {
        return userPass;
    }

    public void setUserPass(String userPass) {
        this.userPass = userPass;
    }

    public boolean isUserRole() {
        return userRole;
    }

    public void setUserRole(boolean userRole) {
        this.userRole = userRole;
    }

    // ==================== HELPER METHODS ====================

    /**
     * Get role as string
     */
    public String getRoleString() {
        return userRole ? "Admin" : "Customer";
    }

    /**
     * Check if user is admin
     */
    public boolean isAdmin() {
        return userRole;
    }

    /**
     * Check if user is customer
     */
    public boolean isCustomer() {
        return !userRole;
    }

    /**
     * Get display name (email prefix)
     */
    public String getDisplayName() {
        if (userEmail != null && userEmail.contains("@")) {
            return userEmail.substring(0, userEmail.indexOf("@"));
        }
        return userEmail != null ? userEmail : "Unknown";
    }

    /**
     * Get user initials for avatar
     */
    public String getInitials() {
        if (userEmail != null && !userEmail.isEmpty()) {
            String[] parts = userEmail.split("[@\\.]");
            if (parts.length >= 1) {
                String name = parts[0];
                if (name.length() >= 2) {
                    return (name.charAt(0) + "" + name.charAt(1)).toUpperCase();
                } else if (name.length() == 1) {
                    return name.toUpperCase();
                }
            }
        }
        return "U";
    }

    /**
     * Validate email format
     */
    public boolean isValidEmail() {
        if (userEmail == null || userEmail.trim().isEmpty()) {
            return false;
        }
        return userEmail.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    /**
     * Check if password is strong
     */
    public boolean isStrongPassword() {
        if (userPass == null || userPass.length() < 6) {
            return false;
        }
        // Add more password validation rules if needed
        return true;
    }

    /**
     * Create a safe copy without password
     */
    public Users createSafeCopy() {
        Users safeCopy = new Users();
        safeCopy.setUserID(this.userID);
        safeCopy.setUserEmail(this.userEmail);
        safeCopy.setUserPass("***HIDDEN***");
        safeCopy.setUserRole(this.userRole);
        return safeCopy;
    }

    /**
     * Generate unique ID based on timestamp
     */
    public void generateID() {
        this.userID = System.currentTimeMillis();
    }

    // ==================== OBJECT METHODS ====================

    /**
     * toString method for debugging
     */
    @Override
    public String toString() {
        return "Users{" +
                "userID=" + userID +
                ", userEmail='" + userEmail + '\'' +
                ", userRole=" + getRoleString() +
                ", isValidEmail=" + isValidEmail() +
                '}';
    }

    /**
     * toString method with password hidden (for logging)
     */
    public String toSafeString() {
        return "Users{" +
                "userID=" + userID +
                ", userEmail='" + userEmail + '\'' +
                ", userPass='***HIDDEN***'" +
                ", userRole=" + getRoleString() +
                '}';
    }

    /**
     * equals method for proper object comparison
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Users users = (Users) obj;
        return userID == users.userID;
    }

    /**
     * hashCode method
     */
    @Override
    public int hashCode() {
        return Long.hashCode(userID);
    }

    // ==================== STATIC UTILITY METHODS ====================

    /**
     * Create admin user
     */
    public static Users createAdmin(String email, String hashedPassword) {
        Users admin = new Users();
        admin.generateID();
        admin.setUserEmail(email);
        admin.setUserPass(hashedPassword);
        admin.setUserRole(true);
        return admin;
    }

    /**
     * Create customer user
     */
    public static Users createCustomer(String email, String hashedPassword) {
        Users customer = new Users();
        customer.generateID();
        customer.setUserEmail(email);
        customer.setUserPass(hashedPassword);
        customer.setUserRole(false);
        return customer;
    }

    /**
     * Validate user data
     */
    public static boolean isValidUser(Users user) {
        return user != null && 
               user.isValidEmail() && 
               user.isStrongPassword() &&
               user.getUserID() > 0;
    }

    // ==================== DEMO/TEST METHODS ====================

    /**
     * Main method for testing
     */
    public static void main(String[] args) {
        System.out.println("Testing Users model...");
        
        // Test admin creation
        Users admin = Users.createAdmin("admin@bookstore.com", "hashedAdminPassword");
        System.out.println("✅ Admin: " + admin.toSafeString());
        System.out.println("   - Display Name: " + admin.getDisplayName());
        System.out.println("   - Initials: " + admin.getInitials());
        System.out.println("   - Is Admin: " + admin.isAdmin());
        
        // Test customer creation
        Users customer = Users.createCustomer("john.doe@gmail.com", "hashedCustomerPassword");
        System.out.println("✅ Customer: " + customer.toSafeString());
        System.out.println("   - Display Name: " + customer.getDisplayName());
        System.out.println("   - Initials: " + customer.getInitials());
        System.out.println("   - Is Customer: " + customer.isCustomer());
        
        // Test validation
        System.out.println("📋 Validation:");
        System.out.println("   - Admin valid: " + Users.isValidUser(admin));
        System.out.println("   - Customer valid: " + Users.isValidUser(customer));
        
        // Test email validation
        Users invalidUser = new Users("invalid-email", "pass", false);
        System.out.println("   - Invalid email: " + invalidUser.isValidEmail());
    }
}