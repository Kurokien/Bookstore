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

    // ==================== ORIGINAL CLIENT METHODS (UPDATED) ====================
    
    // check email
    public boolean checkEmail(String email) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT user_id FROM users WHERE user_email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next(); // true if email exists
        } catch (SQLException ex) {
            logger.severe("Error checking email: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        return false;
    }
    
    // add account method (UPDATED for new fields)
    public boolean insertUser(Users user) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "INSERT INTO users (user_id, user_email, user_fullname, user_phone, " +
                        "user_address, user_country, user_pass, user_role) VALUES (?,?,?,?,?,?,?,?)";
            
            ps = connection.prepareStatement(sql);
            ps.setLong(1, user.getUserID());
            ps.setString(2, user.getUserEmail());
            ps.setString(3, user.getUserFullname());
            ps.setString(4, user.getUserPhone());
            ps.setString(5, user.getUserAddress());
            ps.setString(6, user.getUserCountry());
            ps.setString(7, user.getUserPass());
            ps.setBoolean(8, user.isUserRole());
            
            int result = ps.executeUpdate();
            logger.info("User inserted successfully: " + user.getUserEmail());
            return result > 0;
            
        } catch (SQLException ex) {
            logger.severe("Error inserting user: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources(null, ps, connection);
        }
        return false;
    }
    
    // check login (UPDATED for new fields)
    public Users login(String email, String password) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM users WHERE user_email = ? AND user_pass = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Users user = mapResultSetToUser(rs);
                logger.info("User login successful: " + email);
                return user;
            }
        } catch (SQLException e) {
            logger.severe("Error during login: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        return null;
    }
    
    // get user by ID (UPDATED for new fields)
    public Users getUser(long userID) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, userID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException ex) {
            logger.severe("Error getting user by ID: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources(rs, ps, connection);
        }
        return null;
    }

    // ==================== ENHANCED ADMIN METHODS ====================

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
                Users user = mapResultSetToUser(rs);
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
     * Get user by email only
     */
    public Users getUserByEmail(String email) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection");
                return null;
            }
            
            String sql = "SELECT * FROM users WHERE user_email = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting user by email: " + e.getMessage());
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
            
            String sql = "SELECT * FROM users ORDER BY created_at DESC";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Users user = mapResultSetToUser(rs);
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
            
            String sql = "SELECT * FROM users WHERE user_role = false ORDER BY created_at DESC";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Users user = mapResultSetToUser(rs);
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
            
            String sql = "UPDATE users SET user_email = ?, user_fullname = ?, user_phone = ?, " +
                        "user_address = ?, user_country = ?, user_pass = ?, user_role = ? " +
                        "WHERE user_id = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUserEmail());
            ps.setString(2, user.getUserFullname());
            ps.setString(3, user.getUserPhone());
            ps.setString(4, user.getUserAddress());
            ps.setString(5, user.getUserCountry());
            ps.setString(6, user.getUserPass());
            ps.setBoolean(7, user.isUserRole());
            ps.setLong(8, user.getUserID());
            
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
     * Update user profile (without password and role)
     */
    public boolean updateUserProfile(Users user) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for profile update");
                return false;
            }
            
            String sql = "UPDATE users SET user_fullname = ?, user_phone = ?, " +
                        "user_address = ?, user_country = ? WHERE user_id = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setString(1, user.getUserFullname());
            ps.setString(2, user.getUserPhone());
            ps.setString(3, user.getUserAddress());
            ps.setString(4, user.getUserCountry());
            ps.setLong(5, user.getUserID());
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException e) {
            logger.severe("Error updating user profile: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, connection);
        }
        
        return false;
    }

    /**
     * Change user password
     */
    public boolean changePassword(long userId, String newHashedPassword) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for password change");
                return false;
            }
            
            String sql = "UPDATE users SET user_pass = ? WHERE user_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, newHashedPassword);
            ps.setLong(2, userId);
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException e) {
            logger.severe("Error changing password: " + e.getMessage());
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
     * Map ResultSet to Users object
     */
    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setUserID(rs.getLong("user_id"));
        user.setUserEmail(rs.getString("user_email"));
        user.setUserFullname(rs.getString("user_fullname"));
        user.setUserPhone(rs.getString("user_phone"));
        user.setUserAddress(rs.getString("user_address"));
        user.setUserCountry(rs.getString("user_country"));
        user.setUserPass(rs.getString("user_pass"));
        user.setUserRole(rs.getBoolean("user_role"));
        
        // Handle timestamps (might be null if columns don't exist yet)
        try {
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            // Ignore if columns don't exist yet
        }
        
        return user;
    }

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
        
        // Test email check
        boolean emailExists = dao.checkEmail("admin@bookstore.com");
        System.out.println("📧 Admin email exists: " + emailExists);
        
        // Test admin methods
        System.out.println("📊 Total users: " + dao.getTotalUsers());
        System.out.println("📊 Total customers: " + dao.getTotalCustomers());
        
        // Test get all customers
        ArrayList<Users> customers = dao.getAllCustomers();
        System.out.println("👥 Customer list size: " + customers.size());
        for (Users customer : customers) {
            System.out.println("   - " + customer.getDisplayName() + " (" + customer.getUserEmail() + ")");
        }
    }
}