package com.bookstore.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.bookstore.dao.ProductDAO;
import com.bookstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StockServlet", urlPatterns = {"/admin/StockServlet"})
public class StockServlet extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to stock management page
        response.sendRedirect(request.getContextPath() + "/admin/stock_management.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check admin authentication
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=access_denied");
            return;
        }
        
        try {
            // Get parameters
            String productIdStr = request.getParameter("productId");
            String action = request.getParameter("action");
            String quantityStr = request.getParameter("quantity");
            
            // Validation
            if (productIdStr == null || action == null || quantityStr == null) {
                redirectWithError(request, response, "Thiếu thông tin cần thiết!");
                return;
            }
            
            long productId;
            int quantity;
            
            try {
                productId = Long.parseLong(productIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                redirectWithError(request, response, "Thông tin không hợp lệ!");
                return;
            }
            
            // Validate quantity
            if (quantity <= 0) {
                redirectWithError(request, response, "Số lượng phải lớn hơn 0!");
                return;
            }
            
            // Get product
            Product product = productDAO.getProduct(productId);
            if (product == null) {
                redirectWithError(request, response, "Không tìm thấy sản phẩm!");
                return;
            }
            
            // Perform action
            boolean success = false;
            String successMessage = "";
            
            switch (action.toLowerCase()) {
                case "add":
                    success = productDAO.addStock(productId, quantity);
                    if (success) {
                        successMessage = "Đã thêm " + quantity + " sản phẩm vào kho cho \"" + 
                                       product.getProductName() + "\"";
                        System.out.println("Stock added: Product ID " + productId + 
                                         ", Quantity: +" + quantity + 
                                         ", New total: " + (product.getQuantity() + quantity));
                    }
                    break;
                    
                case "remove":
                    // Check if we have enough stock to remove
                    int currentStock = productDAO.getCurrentStock(productId);
                    if (currentStock < quantity) {
                        redirectWithError(request, response, 
                                        "Không thể trừ " + quantity + " sản phẩm. Chỉ còn " + 
                                        currentStock + " sản phẩm trong kho!");
                        return;
                    }
                    
                    success = productDAO.updateStock(productId, quantity);
                    if (success) {
                        successMessage = "Đã trừ " + quantity + " sản phẩm khỏi kho cho \"" + 
                                       product.getProductName() + "\"";
                        System.out.println("Stock removed: Product ID " + productId + 
                                         ", Quantity: -" + quantity + 
                                         ", New total: " + (product.getQuantity() - quantity));
                    }
                    break;
                    
                case "set":
                    // Set absolute quantity
                    int currentQuantity = productDAO.getCurrentStock(productId);
                    if (quantity == currentQuantity) {
                        response.sendRedirect(request.getContextPath() + "/admin/stock_management.jsp");
                        return;
                    }
                    
                    // Update by setting new quantity directly
                    // We need a new method for this or calculate the difference
                    int difference = quantity - currentQuantity;
                    if (difference > 0) {
                        success = productDAO.addStock(productId, difference);
                    } else if (difference < 0) {
                        success = productDAO.updateStock(productId, Math.abs(difference));
                    } else {
                        success = true; // No change needed
                    }
                    
                    if (success) {
                        successMessage = "Đã cập nhật số lượng thành " + quantity + 
                                       " cho \"" + product.getProductName() + "\"";
                        System.out.println("Stock set: Product ID " + productId + 
                                         ", New quantity: " + quantity + 
                                         ", Change: " + (difference >= 0 ? "+" : "") + difference);
                    }
                    break;
                    
                default:
                    redirectWithError(request, response, "Thao tác không hợp lệ!");
                    return;
            }
            
            if (success) {
                // Redirect về stock_management.jsp mà không có thông báo
                response.sendRedirect(request.getContextPath() + "/admin/stock_management.jsp");
            } else {
                redirectWithError(request, response, "Có lỗi xảy ra khi cập nhật kho hàng!");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Database error in StockServlet: " + e.getMessage());
            redirectWithError(request, response, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Unexpected error in StockServlet: " + e.getMessage());
            redirectWithError(request, response, "Có lỗi không mong muốn xảy ra!");
        }
    }
    
    /**
     * Redirect with error message
     */
    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, 
                                 String message) throws IOException {
        String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
        response.sendRedirect(request.getContextPath() + "/admin/stock_management.jsp?error=" + encodedMessage);
    }
    
    @Override
    public String getServletInfo() {
        return "Stock Management Servlet for Admin Operations";
    }
}