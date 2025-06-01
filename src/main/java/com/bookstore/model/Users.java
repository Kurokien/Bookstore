package com.bookstore.model;

import java.sql.Timestamp;
import java.util.Date;

public class Users {
    
    // ==================== FIELDS ====================
    private long userID;
    private String userEmail;
    private String userFullname;
    private String userPhone;
    private String userAddress;
    private String userCountry;
    private String userPass;
    private boolean userRole; // true = admin, false = customer
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // ==================== CONSTRUCTORS ====================
    
    /**
     * Default constructor
     */
    public Users() {
    }

    /**
     * Constructor with all fields
     */
    public Users(long userID, String userEmail, String userFullname, String userPhone, 
                String userAddress, String userCountry, String userPass, boolean userRole) {
        this.userID = userID;
        this.userEmail = userEmail;
        this.userFullname = userFullname;
        this.userPhone = userPhone;
        this.userAddress = userAddress;
        this.userCountry = userCountry;
        this.userPass = userPass;
        this.userRole = userRole;
    }

    /**
     * Constructor for registration (userRole = false by default)
     */
    public Users(String userEmail, String userFullname, String userPhone, 
                String userAddress, String userCountry, String userPass) {
        this.userEmail = userEmail;
        this.userFullname = userFullname;
        this.userPhone = userPhone;
        this.userAddress = userAddress;
        this.userCountry = userCountry;
        this.userPass = userPass;
        this.userRole = false; // Default to customer
    }

    /**
     * Constructor for edit (userRole = false by default)
     */
    public Users(String userEmail, String userFullname, String userPhone,
                 String userAddress, String userCountry) {
        this.userEmail = userEmail;
        this.userFullname = userFullname;
        this.userPhone = userPhone;
        this.userAddress = userAddress;
        this.userCountry = userCountry;
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

    public String getUserFullname() {
        return userFullname;
    }

    public void setUserFullname(String userFullname) {
        this.userFullname = userFullname;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }

    public String getUserCountry() {
        return userCountry;
    }

    public void setUserCountry(String userCountry) {
        this.userCountry = userCountry;
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
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
     * Get display name (fullname if available, otherwise email prefix)
     */
    public String getDisplayName() {
        if (userFullname != null && !userFullname.trim().isEmpty()) {
            return userFullname;
        }
        if (userEmail != null && userEmail.contains("@")) {
            return userEmail.substring(0, userEmail.indexOf("@"));
        }
        return userEmail != null ? userEmail : "Unknown";
    }

    /**
     * Get first name from fullname
     */
    public String getFirstName() {
        if (userFullname != null && !userFullname.trim().isEmpty()) {
            String[] names = userFullname.trim().split("\\s+");
            return names[0];
        }
        return getDisplayName();
    }

    /**
     * Get last name from fullname
     */
    public String getLastName() {
        if (userFullname != null && !userFullname.trim().isEmpty()) {
            String[] names = userFullname.trim().split("\\s+");
            if (names.length > 1) {
                return names[names.length - 1];
            }
        }
        return "";
    }

    /**
     * Get user initials for avatar
     */
    public String getInitials() {
        if (userFullname != null && !userFullname.trim().isEmpty()) {
            String[] names = userFullname.trim().split("\\s+");
            StringBuilder initials = new StringBuilder();
            for (int i = 0; i < Math.min(2, names.length); i++) {
                if (!names[i].isEmpty()) {
                    initials.append(names[i].charAt(0));
                }
            }
            return initials.toString().toUpperCase();
        }
        
        if (userEmail != null && !userEmail.isEmpty()) {
            String name = userEmail.split("@")[0];
            if (name.length() >= 2) {
                return (name.charAt(0) + "" + name.charAt(1)).toUpperCase();
            } else if (name.length() == 1) {
                return name.toUpperCase();
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
     * Validate phone number format
     */
    public boolean isValidPhone() {
        if (userPhone == null || userPhone.trim().isEmpty()) {
            return true; // Phone is optional
        }
        // Basic phone validation (can be enhanced)
        return userPhone.matches("^[\\+]?[0-9\\s\\-\\(\\)]{10,20}$");
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
     * Check if all required fields are filled
     */
    public boolean hasRequiredFields() {
        return userEmail != null && !userEmail.trim().isEmpty() &&
               userPass != null && !userPass.trim().isEmpty() &&
               userFullname != null && !userFullname.trim().isEmpty();
    }

    /**
     * Create a safe copy without password
     */
    public Users createSafeCopy() {
        Users safeCopy = new Users();
        safeCopy.setUserID(this.userID);
        safeCopy.setUserEmail(this.userEmail);
        safeCopy.setUserFullname(this.userFullname);
        safeCopy.setUserPhone(this.userPhone);
        safeCopy.setUserAddress(this.userAddress);
        safeCopy.setUserCountry(this.userCountry);
        safeCopy.setUserPass("***HIDDEN***");
        safeCopy.setUserRole(this.userRole);
        safeCopy.setCreatedAt(this.createdAt);
        safeCopy.setUpdatedAt(this.updatedAt);
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
                ", userFullname='" + userFullname + '\'' +
                ", userPhone='" + userPhone + '\'' +
                ", userCountry='" + userCountry + '\'' +
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
                ", userFullname='" + userFullname + '\'' +
                ", userPhone='" + userPhone + '\'' +
                ", userAddress='" + userAddress + '\'' +
                ", userCountry='" + userCountry + '\'' +
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
    public static Users createAdmin(String email, String fullname, String hashedPassword) {
        Users admin = new Users();
        admin.generateID();
        admin.setUserEmail(email);
        admin.setUserFullname(fullname);
        admin.setUserPass(hashedPassword);
        admin.setUserRole(true);
        return admin;
    }

    /**
     * Create customer user
     */
    public static Users createCustomer(String email, String fullname, String phone, 
                                     String address, String country, String hashedPassword) {
        Users customer = new Users();
        customer.generateID();
        customer.setUserEmail(email);
        customer.setUserFullname(fullname);
        customer.setUserPhone(phone);
        customer.setUserAddress(address);
        customer.setUserCountry(country);
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
               user.hasRequiredFields() &&
               user.getUserID() > 0;
    }
}