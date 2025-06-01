package com.bookstore.connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnect {
    // Update with your Supabase PostgreSQL credentials
    private static final String URL = "jdbc:postgresql://aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require";
    private static final String USER = "postgres.nfwdxeisgzvpnvxbwies"; // Replace with your Supabase username
    private static final String PASSWORD = "Lw3gA7VnZk9TyX2uQm5E"; // Replace with your Supabase password

    private static final Logger logger = Logger.getLogger(DBConnect.class.getName());

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Explicitly load the PostgreSQL driver
            Class.forName("org.postgresql.Driver");
            logger.info("PostgreSQL Driver loaded successfully.");

            logger.info("Attempting to connect to database: " + URL);
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            if (conn == null) {
                logger.severe("Connection is null after DriverManager.getConnection()");
            }

            logger.info("Database connection established successfully.");
            return conn;
        } catch (ClassNotFoundException e) {
            logger.severe("PostgreSQL Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            logger.severe("Database connection failed: " + e.getMessage());
            logger.severe("Error Code: " + e.getErrorCode());
            logger.severe("SQL State: " + e.getSQLState());
            e.printStackTrace();

            // Log detailed error for debugging
            System.err.println("=== DATABASE CONNECTION ERROR ===");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            System.err.println("=====================================");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
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