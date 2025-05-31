package com.bookstore.dao;

import com.bookstore.connect.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.bookstore.model.Users;

public class UsersDAO {
    
    private static final Logger logger = Logger.getLogger(UsersDAO.class.getName());

    // ==================== ORIGINAL CLIENT METHODS (UNCHANGED) ====================
    
    // check email
    public boolean checkEmail(String email) {
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM users WHERE user_email = '" + email + "'";
        PreparedStatement ps;
        try {
            ps = connection.prepareCall(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                connection.close();
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    // add account method
    public boolean insertUser(Users u) {
        Connection connection = DBConnect.getConnection();
        String sql = "INSERT INTO users VALUES(?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareCall(sql);
            ps.setLong(1, u.getUserID());
            ps.setString(2, u.getUserEmail());
            ps.setString(3, u.getUserPass());
            ps.setBoolean(4, u.isUserRole());
            ps.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    // check login
    public Users login(String email, String password) {
        Connection con = DBConnect.getConnection();
        String sql = "select * from users where user_email='" + email + "' and user_pass='" + password + "'";
        PreparedStatement ps;
        try {
            ps = (PreparedStatement) con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Users u = new Users();
                u.setUserID(rs.getLong("user_id"));
                u.setUserEmail(rs.getString("user_email"));
                u.setUserPass(rs.getString("user_pass"));
                u.setUserRole(rs.getBoolean("user_role"));
                con.close();
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Users getUser(long userID) {
        try {
            Connection connection = DBConnect.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement ps = connection.prepareCall(sql);
            ps.setLong(1, userID);
            ResultSet rs = ps.executeQuery();
            Users u = new Users();
            while (rs.next()) {
                u.setUserEmail(rs.getString("user_email"));
            }
            return u;
        } catch (SQLException ex) {
            Logger.getLogger(UsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // ==================== NEW ADMIN METHODS (ADDED) ====================

    /**
     * Get user by email and password (For admin authentication)
     */
    public Users getUserByEmailAndPassword(String email, String hashedPassword) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return null;
            }
            
            String sql = "SELECT * FROM users WHERE user_email = ? AND user_pass = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getLong("user_id"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPass(rs.getString("user_pass"));
                user.setUserRole(rs.getBoolean("user_role"));
                
                logger.info("User found: " + email + ", Role: " + (user.isUserRole() ? "Admin" : "Customer"));
                return user;
            } else {
                logger.warning("No user found with email: " + email);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting user by email and password: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return null;
    }

    /**
     * Get user by ID (Enhanced version for admin)
     */
    public Users getUserById(long userId) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return null;
            }
            
            String sql = "SELECT * FROM users WHERE user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, userId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getLong("user_id"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPass(rs.getString("user_pass"));
                user.setUserRole(rs.getBoolean("user_role"));
                return user;
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return null;
    }

    /**
     * Check if email exists (Enhanced version for admin)
     */
    public boolean isEmailExists(String email) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return false;
            }
            
            String sql = "SELECT COUNT(*) FROM users WHERE user_email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.severe("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return false;
    }

    /**
     * Get all users (Admin function)
     */
    public ArrayList<Users> getAllUsers() {
        ArrayList<Users> userList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return userList;
            }
            
            String sql = "SELECT * FROM users ORDER BY user_id";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getLong("user_id"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPass(rs.getString("user_pass"));
                user.setUserRole(rs.getBoolean("user_role"));
                userList.add(user);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return userList;
    }

    /**
     * Get all customers (Non-admin users)
     */
    public ArrayList<Users> getAllCustomers() {
        ArrayList<Users> customerList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return customerList;
            }
            
            String sql = "SELECT * FROM users WHERE user_role = false ORDER BY user_id";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getLong("user_id"));
                user.setUserEmail(rs.getString("user_email"));
                user.setUserPass(rs.getString("user_pass"));
                user.setUserRole(rs.getBoolean("user_role"));
                customerList.add(user);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting all customers: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return customerList;
    }

    /**
     * Update user information
     */
    public boolean updateUser(Users user) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for update");
                return false;
            }
            
            String sql = "UPDATE users SET user_email = ?, user_pass = ?, user_role = ? WHERE user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUserEmail());
            ps.setString(2, user.getUserPass());
            ps.setBoolean(3, user.isUserRole());
            ps.setLong(4, user.getUserID());
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException e) {
            logger.severe("Error updating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, connection);
        }
        
        return false;
    }

    /**
     * Delete user by ID
     */
    public boolean deleteUser(long userID) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for delete");
                return false;
            }
            
            String sql = "DELETE FROM users WHERE user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, userID);
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException e) {
            logger.severe("Error deleting user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, connection);
        }
        
        return false;
    }

    /**
     * Count total users
     */
    public int getTotalUsers() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return 0;
            }
            
            String sql = "SELECT COUNT(*) FROM users";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting total users: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return 0;
    }

    /**
     * Count total customers
     */
    public int getTotalCustomers() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return 0;
            }
            
            String sql = "SELECT COUNT(*) FROM users WHERE user_role = false";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting total customers: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return 0;
    }

    // ==================== UTILITY METHODS ====================

    /**
     * Close database resources safely
     */
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection connection) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            logger.warning("Error closing database resources: " + e.getMessage());
        }
    }

    /**
     * Test connection and basic operations
     */
    public static void main(String[] args) {
        UsersDAO dao = new UsersDAO();
        System.out.println("Testing UsersDAO...");
        
        // Test admin login (password: admin123 -> MD5: 0192023a7bbd73250516f069df18b500)
        Users admin = dao.getUserByEmailAndPassword("admin@bookstore.com", "0192023a7bbd73250516f069df18b500");
        if (admin != null) {
            System.out.println("✅ Admin found: " + admin.getUserEmail());
            System.out.println("✅ Is admin: " + admin.isUserRole());
        } else {
            System.out.println("❌ Admin not found!");
        }
        
        // Test original client methods
        boolean emailExists = dao.checkEmail("admin@bookstore.com");
        System.out.println("📧 Admin email exists (original method): " + emailExists);
        
        // Test admin methods
        System.out.println("📊 Total users: " + dao.getTotalUsers());
        System.out.println("📊 Total customers: " + dao.getTotalCustomers());
    }
}