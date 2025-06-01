package com.bookstore.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Logger;

import com.bookstore.connect.DBConnect;
import com.bookstore.model.Product;

public class ProductDAO {
    
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());

    // Helper method to map ResultSet to Product
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductID(rs.getLong("product_id"));
        product.setCategoryID(rs.getLong("category_id"));
        product.setProductName(rs.getString("product_name"));
        product.setProductImage(rs.getString("product_image"));
        product.setProductPrice(rs.getDouble("product_price"));
        product.setProductDescription(rs.getString("product_description"));
        
        // Handle quantity (might be null in old data)
        try {
            product.setQuantity(rs.getInt("quantity"));
        } catch (SQLException e) {
            product.setQuantity(0); // Default to 0 if column doesn't exist
        }
        
        return product;
    }

    // Lấy tất cả sản phẩm
    public ArrayList<Product> getAllProduct() throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }
    
    // get danh sách sản phẩm dựa vào mã danh mục
    public ArrayList<Product> getListProductByCategory(long category_id) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE category_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, category_id);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }

    // hiển thị chi tiết sản phẩm
    public Product getProduct(long productID) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Product product = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE product_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, productID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return product;
    }
    
    // Cập nhật sản phẩm
    public void updateProduct(Product p) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "UPDATE product SET category_id = ?, product_name = ?, product_price = ?, " +
                        "product_description = ?, product_image = ?, quantity = ? WHERE product_id = ?";
            
            ps = connection.prepareStatement(sql);
            ps.setLong(1, p.getCategoryID());
            ps.setString(2, p.getProductName());
            ps.setDouble(3, p.getProductPrice());
            ps.setString(4, p.getProductDescription());
            ps.setString(5, p.getProductImage());
            ps.setInt(6, p.getQuantity());
            ps.setLong(7, p.getProductID());
            
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, connection);
        }
    }
    
    // Thêm sản phẩm mới
    public void insertProduct(Product p) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "INSERT INTO product(product_id, category_id, product_name, product_price, " +
                        "product_description, product_image, quantity) VALUES(?, ?, ?, ?, ?, ?, ?)";
            
            ps = connection.prepareStatement(sql);
            ps.setLong(1, new Date().getTime());
            ps.setLong(2, p.getCategoryID());
            ps.setString(3, p.getProductName());
            ps.setDouble(4, p.getProductPrice());
            ps.setString(5, p.getProductDescription());
            ps.setString(6, p.getProductImage());
            ps.setInt(7, p.getQuantity() > 0 ? p.getQuantity() : 100); // Default quantity = 100
            
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, connection);
        }
    }
    
    // Xóa sản phẩm
    public void deleteProduct(long productID) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "DELETE FROM product WHERE product_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, productID);
            ps.executeUpdate();
        } finally {
            closeResources(null, ps, connection);
        }
    }
    
    // lấy danh sách sản phẩm với phân trang
    public ArrayList<Product> getListProductByNav(long categoryID, int firstResult, int maxResult) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE category_id = ? LIMIT ? OFFSET ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, categoryID);
            ps.setInt(2, maxResult);
            ps.setInt(3, firstResult);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }
    
    // Tìm kiếm sản phẩm theo tên với phân trang
    public ArrayList<Product> getListProductByNav(String productName, int firstResult, int maxResult) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE product_name LIKE ? LIMIT ? OFFSET ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + productName + "%");
            ps.setInt(2, maxResult);
            ps.setInt(3, firstResult);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }
    
    // tính tổng sản phẩm theo category
    public int countProductByCategory(long categoryID) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT COUNT(product_id) FROM product WHERE category_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, categoryID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return count;
    }
    
    // Đếm tổng sản phẩm theo tên
    public int countAllProduct(String productName) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT COUNT(product_id) FROM product WHERE product_name LIKE ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + productName + "%");
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } finally {
            closeResources(rs, ps, connection);
        }

        System.out.println("Total Product Count : " + count);
        return count;
    }
    
    // ==================== STOCK MANAGEMENT METHODS ====================
    
    /**
     * Kiểm tra tồn kho của sản phẩm
     */
    public boolean checkStock(long productID, int requestedQuantity) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT quantity FROM product WHERE product_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, productID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int currentStock = rs.getInt("quantity");
                return currentStock >= requestedQuantity;
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return false;
    }
    
    /**
     * Lấy số lượng tồn kho hiện tại
     */
    public int getCurrentStock(long productID) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT quantity FROM product WHERE product_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, productID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("quantity");
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return 0;
    }
    
    /**
     * Cập nhật số lượng tồn kho (trừ đi số lượng đã bán)
     */
    public boolean updateStock(long productID, int quantitySold) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            
            // Sử dụng transaction để đảm bảo data consistency
            connection.setAutoCommit(false);
            
            // Kiểm tra stock hiện tại trước khi update
            String checkSql = "SELECT quantity FROM product WHERE product_id = ? FOR UPDATE";
            ps = connection.prepareStatement(checkSql);
            ps.setLong(1, productID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int currentStock = rs.getInt("quantity");
                if (currentStock < quantitySold) {
                    connection.rollback();
                    logger.warning("Insufficient stock for product ID " + productID + 
                                 ". Current: " + currentStock + ", Requested: " + quantitySold);
                    return false;
                }
                
                // Update stock
                String updateSql = "UPDATE product SET quantity = quantity - ? WHERE product_id = ?";
                PreparedStatement updatePs = connection.prepareStatement(updateSql);
                updatePs.setInt(1, quantitySold);
                updatePs.setLong(2, productID);
                
                int rowsAffected = updatePs.executeUpdate();
                
                if (rowsAffected == 1) {
                    connection.commit();
                    logger.info("Stock updated successfully for product ID " + productID + 
                              ". Quantity sold: " + quantitySold);
                    updatePs.close();
                    return true;
                } else {
                    connection.rollback();
                    updatePs.close();
                    return false;
                }
            } else {
                connection.rollback();
                logger.warning("Product not found with ID: " + productID);
                return false;
            }
            
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.severe("Error rolling back transaction: " + ex.getMessage());
                }
            }
            logger.severe("Error updating stock: " + e.getMessage());
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                } catch (SQLException e) {
                    logger.warning("Error resetting auto commit: " + e.getMessage());
                }
            }
            closeResources(null, ps, connection);
        }
    }
    
    /**
     * Thêm stock (khi nhập hàng)
     */
    public boolean addStock(long productID, int quantityToAdd) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnect.getConnection();
            String sql = "UPDATE product SET quantity = quantity + ? WHERE product_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, quantityToAdd);
            ps.setLong(2, productID);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected == 1) {
                logger.info("Stock added successfully for product ID " + productID + 
                          ". Quantity added: " + quantityToAdd);
                return true;
            }
            
        } finally {
            closeResources(null, ps, connection);
        }
        
        return false;
    }
    
    /**
     * Lấy danh sách sản phẩm sắp hết hàng (quantity <= threshold)
     */
    public ArrayList<Product> getLowStockProducts(int threshold) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE quantity <= ? AND quantity > 0 ORDER BY quantity ASC";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, threshold);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }
    
    /**
     * Lấy danh sách sản phẩm hết hàng
     */
    public ArrayList<Product> getOutOfStockProducts() throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Product> list = new ArrayList<>();
        
        try {
            connection = DBConnect.getConnection();
            String sql = "SELECT * FROM product WHERE quantity <= 0";
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } finally {
            closeResources(rs, ps, connection);
        }
        
        return list;
    }
    
    // Helper method to close resources
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection connection) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            logger.warning("Error closing database resources: " + e.getMessage());
        }
    }
    
    public static void main(String[] args) throws SQLException {
        ProductDAO dao = new ProductDAO();
        
        // Test stock methods
        System.out.println("Testing stock management...");
        
        // Check stock
        boolean hasStock = dao.checkStock(1, 5);
        System.out.println("Product 1 has stock for 5 items: " + hasStock);
        
        // Get current stock
        int currentStock = dao.getCurrentStock(1);
        System.out.println("Current stock for product 1: " + currentStock);
        
        // Get low stock products
        ArrayList<Product> lowStockProducts = dao.getLowStockProducts(20);
        System.out.println("Low stock products: " + lowStockProducts.size());
        
        for (Product p : lowStockProducts) {
            System.out.println("- " + p.getProductName() + ": " + p.getQuantity() + " items");
        }
    }
}