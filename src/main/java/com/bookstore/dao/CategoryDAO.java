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

    // get danh sách thể loại
    public ArrayList<Category> getListCategory() throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM category";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        ArrayList<Category> list = new ArrayList<>();
        while (rs.next()) {
            Category category = new Category();
            category.setCategoryID(rs.getLong("category_id"));
            category.setCategoryName(rs.getString("category_name"));
            list.add(category);
        }
        return list;
    }
    
    // get thể loại
    public Category getCategory(long category_id) throws SQLException {
        Connection connection = DBConnect.getConnection();
        Category c = new Category();
        String sql = "SELECT * FROM category where category_id = '" + category_id + "'";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            c.setCategoryID(rs.getLong("category_id"));
            c.setCategoryName(rs.getString("category_name"));
        }
        return c;
    }

    // thêm mới dữ liệu
    public boolean insertCategory(Category c) {
        Connection connection = DBConnect.getConnection();
        String sql = "INSERT INTO category VALUES(?,?)";
        try {
            PreparedStatement ps = connection.prepareCall(sql);
            ps.setLong(1, c.getCategoryID());
            ps.setString(2, c.getCategoryName());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // cập nhật dữ liệu
    public boolean updateCategory(Category c) {
        Connection connection = DBConnect.getConnection();
        String sql = "UPDATE category SET category_name = ? WHERE category_id = ?";
        try {
            PreparedStatement ps = connection.prepareCall(sql);
            ps.setString(1, c.getCategoryName());
            ps.setLong(2, c.getCategoryID());
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // xóa dữ liệu
    public boolean deleteCategory(long category_id) {
        Connection connection = DBConnect.getConnection();
        String sql = "DELETE FROM category WHERE category_id = ?";
        try {
            PreparedStatement ps = connection.prepareCall(sql);
            ps.setLong(1, category_id);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public static void main(String[] args) throws SQLException {
        CategoryDAO dao = new CategoryDAO();
//        for (int i = 1; i < 10; i++) {
//            dao.insertCategory(new Category(i, "Category " + i));
//        }
//        System.out.println(dao.updateCategory(new Category(8, "Tùng Dương")));
        System.out.println(dao.deleteCategory(7));
    }
    
}
