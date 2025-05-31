package com.bookstore.dao;

import com.bookstore.connect.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.bookstore.model.Category;

public class CategoryDAO {
    
    private static final Logger logger = Logger.getLogger(CategoryDAO.class.getName());

    // get danh sách thể loại
    public ArrayList<Category> getListCategory() throws SQLException {
        ArrayList<Category> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                throw new SQLException("Cannot establish database connection");
            }
            
            String sql = "SELECT * FROM category";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getLong("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                list.add(category);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting category list: " + e.getMessage());
            throw e;
        } finally {
            // Đóng resources theo thứ tự ngược lại
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                logger.warning("Error closing resources: " + e.getMessage());
            }
        }
        
        return list;
    }
    
    // get thể loại
    public Category getCategory(long category_id) throws SQLException {
        Category c = new Category();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                throw new SQLException("Cannot establish database connection");
            }
            
            String sql = "SELECT * FROM category WHERE category_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, category_id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                c.setCategoryID(rs.getLong("category_id"));
                c.setCategoryName(rs.getString("category_name"));
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting category: " + e.getMessage());
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                logger.warning("Error closing resources: " + e.getMessage());
            }
        }
        
        return c;
    }

    // thêm mới dữ liệu
    public boolean insertCategory(Category c) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for insert");
                return false;
            }
            
            String sql = "INSERT INTO category VALUES(?,?)";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, c.getCategoryID());
            ps.setString(2, c.getCategoryName());
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException ex) {
            logger.severe("Error inserting category: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                logger.warning("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }

    // cập nhật dữ liệu
    public boolean updateCategory(Category c) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for update");
                return false;
            }
            
            String sql = "UPDATE category SET category_name = ? WHERE category_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, c.getCategoryName());
            ps.setLong(2, c.getCategoryID());
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException ex) {
            logger.severe("Error updating category: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                logger.warning("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }

    // xóa dữ liệu
    public boolean deleteCategory(long category_id) {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            if (connection == null) {
                logger.severe("Cannot establish database connection for delete");
                return false;
            }
            
            String sql = "DELETE FROM category WHERE category_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, category_id);
            
            int result = ps.executeUpdate();
            return result == 1;
            
        } catch (SQLException ex) {
            logger.severe("Error deleting category: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                logger.warning("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }
    
    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();
        try {
            System.out.println("Testing CategoryDAO...");
            ArrayList<Category> categories = dao.getListCategory();
            System.out.println("✅ Found " + categories.size() + " categories");
            for (Category cat : categories) {
                System.out.println("- " + cat.getCategoryName());
            }
        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}