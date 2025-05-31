package com.bookstore.connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnect {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/shop?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "minhkhoa2004";
    
    private static final Logger logger = Logger.getLogger(DBConnect.class.getName());
    
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Explicitly load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("MySQL Driver loaded successfully.");
            
            logger.info("Attempting to connect to database: " + URL);
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (conn != null) {
                logger.info("Database connection established successfully.");
            } else {
                logger.severe("Connection is null after DriverManager.getConnection()");
            }
            
        } catch (ClassNotFoundException e) {
            logger.severe("MySQL Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            logger.severe("Database connection failed: " + e.getMessage());
            logger.severe("Error Code: " + e.getErrorCode());
            logger.severe("SQL State: " + e.getSQLState());
            e.printStackTrace();
            
            // Ghi log chi tiết để debug
            System.err.println("=== DATABASE CONNECTION ERROR ===");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            System.err.println("=====================================");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return conn;
    }
    
    /**
     * Test connection method
     */
    public static boolean testConnection() {
        Connection conn = getConnection();
        if (conn != null) {
            try {
                conn.close();
                return true;
            } catch (SQLException e) {
                logger.warning("Error closing test connection: " + e.getMessage());
            }
        }
        return false;
    }
    
    /**
     * Close connection safely
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.info("Connection closed successfully.");
            } catch (SQLException e) {
                logger.warning("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("✅ Connection successful: " + conn);
            closeConnection(conn);
        } else {
            System.out.println("❌ Connection failed!");
        }
    }
}