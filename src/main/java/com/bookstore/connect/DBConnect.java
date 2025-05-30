package com.bookstore.connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnect {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/shop";
    private static final String USER = "root";
    private static final String PASSWORD = "Az242005";
    
    public static Connection getConnection()  {
        Connection conn = null;
        try {
            // Explicitly load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL Driver loaded successfully.");
            System.out.println("Connecting to database..." + URL);
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connection established successfully.");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
    
    public static void main(String[] args)  {
        System.out.println(getConnection());
    }
    
}
