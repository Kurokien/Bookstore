package com.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import com.bookstore.connect.DBConnect;
import com.bookstore.model.Product;


public class ProductDAO {

    // Lấy tất cả sản phẩm
    public ArrayList<Product> getAllProduct() throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM product";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        ArrayList<Product> list = new ArrayList<>();
        while (rs.next()) {
            Product product = new Product();
            product.setProductID(rs.getLong("product_id"));
            product.setProductName(rs.getString("product_name"));
            product.setProductImage(rs.getString("product_image"));
            product.setProductPrice(rs.getDouble("product_price"));
            product.setProductDescription(rs.getString("product_description"));
            list.add(product);
        }
        return list;
    }
    
    // get danh sách sản phẩm dựa vào mã danh mục
    public ArrayList<Product> getListProductByCategory(long category_id) throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM product WHERE category_id = '" + category_id + "'";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        ArrayList<Product> list = new ArrayList<>();
        while (rs.next()) {
            Product product = new Product();
            product.setProductID(rs.getLong("product_id"));
            product.setProductName(rs.getString("product_name"));
            product.setProductImage(rs.getString("product_image"));
            product.setProductPrice(rs.getDouble("product_price"));
            product.setProductDescription(rs.getString("product_description"));
            list.add(product);
        }
        return list;
    }

    // hiển thị chi tiết sản phẩm
    public Product getProduct(long productID) throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM product WHERE product_id = '" + productID + "'";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        Product product = new Product();
        while (rs.next()) {
            product.setProductID(rs.getLong("product_id"));
            product.setProductName(rs.getString("product_name"));
            product.setProductImage(rs.getString("product_image"));
            product.setProductPrice(rs.getDouble("product_price"));
            product.setProductDescription(rs.getString("product_description"));
        }
        return product;
    }
    // Cập nhật sản phẩm
    public void updateProduct(Product p)  throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "UPDATE PRODUCT SET category_id = ?"
                + ", product_name = ?"
                + ", product_price = ?"
                + ", product_description = ?"
                + ", product_image = ?"
                + " WHERE product_id = ?";
        
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setLong(1, p.getCategoryID());
        ps.setString(2, p.getProductName());
        ps.setDouble(3, p.getProductPrice());
        ps.setString(4, p.getProductDescription());
        ps.setString(5, p.getProductImage());
        ps.setLong(6, p.getProductID());
        ps.executeUpdate();
    }
    
    // Cập nhật sản phẩm
    public void insertProduct(Product p)  throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "INSERT INTO PRODUCT(product_id, category_id, product_name, product_price, product_description, product_image) "
                + "VALUES(?, ?, ?, ?, ?, ?)";
        
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setLong(1, new Date().getTime());
        ps.setLong(2, p.getCategoryID());
        ps.setString(3, p.getProductName());
        ps.setDouble(4, p.getProductPrice());
        ps.setString(5, p.getProductDescription());
        ps.setString(6, p.getProductImage());
        ps.executeUpdate();
    }
    
    public void deleteProduct(long productID)  throws SQLException {
        Connection connection = DBConnect.getConnection();
        String sql = "DELETE FROM PRODUCT WHERE product_id = ?";
        
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setLong(1, productID);
        ps.executeUpdate();
    }
    
    
    // lấy danh sách sản phẩm
    public ArrayList<Product> getListProductByNav(long categoryID, int firstResult, int maxResult) throws SQLException{
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM product WHERE category_id = '" + categoryID + "' limit ?,?";
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setInt(1, firstResult);
        ps.setInt(2, maxResult);
        ResultSet rs = ps.executeQuery();
        ArrayList<Product> list = new ArrayList<>();
        while (rs.next()) {
            Product product = new Product();
            product.setProductID(rs.getLong("product_id"));
            product.setProductName(rs.getString("product_name"));
            product.setProductImage(rs.getString("product_image"));
            product.setProductPrice(rs.getDouble("product_price"));
            product.setProductDescription(rs.getString("product_description"));
            list.add(product);
        }
        return list;
    }
    
    public ArrayList<Product> getListProductByNav(String productName, int firstResult, int maxResult) throws SQLException{
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT * FROM product WHERE product_name LIKE '%" + productName + "%' limit ?,?";
        PreparedStatement ps = connection.prepareCall(sql);
        ps.setInt(1, firstResult);
        ps.setInt(2, maxResult);
        ResultSet rs = ps.executeQuery();
        ArrayList<Product> list = new ArrayList<>();
        while (rs.next()) {
            Product product = new Product();
            product.setProductID(rs.getLong("product_id"));
            product.setProductName(rs.getString("product_name"));
            product.setProductImage(rs.getString("product_image"));
            product.setProductPrice(rs.getDouble("product_price"));
            product.setProductDescription(rs.getString("product_description"));
            list.add(product);
        }
        return list;
    }
    
    // tính tổng sản phẩm
    public int countProductByCategory(long categoryID) throws SQLException{
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT count(product_id) FROM product WHERE category_id = '" + categoryID + "'";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        int count = 0;
        while (rs.next()) {
            count = rs.getInt(1);
        }
        return count;  
    }
    
    public int countAllProduct(String productName) throws SQLException{
        Connection connection = DBConnect.getConnection();
        String sql = "SELECT count(product_id) FROM product WHERE product_name LIKE '%" + productName + "%'";
        PreparedStatement ps = connection.prepareCall(sql);
        ResultSet rs = ps.executeQuery();
        int count = 0;
        while (rs.next()) {
            count = rs.getInt(1);
        }
        return count;
    }
    
    public static void main(String[] args) throws SQLException {
        ProductDAO dao = new ProductDAO();
//        for (Product p : dao.getListProductByCategory(3)) {
//            System.out.println(p.getProductID() + " - " + p.getProductName());
//        }
        System.out.println(dao.countProductByCategory(1));
    }
    
}
