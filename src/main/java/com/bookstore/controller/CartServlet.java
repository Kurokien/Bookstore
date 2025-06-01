package com.bookstore.controller;

import java.io.IOException;
import java.sql.SQLException;

import org.json.JSONObject;

import com.bookstore.dao.ProductDAO;
import com.bookstore.model.Cart;
import com.bookstore.model.Item;
import com.bookstore.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String command = request.getParameter("command");
        String productID = request.getParameter("productID");
        String isAjax = request.getParameter("ajax");

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        try {
            Long idProduct = Long.parseLong(productID);
            Product product = productDAO.getProduct(idProduct);

            if (product != null) {
                switch (command) {
                    case "plus":
                        handleAddToCart(cart, product, idProduct, isAjax, response);
                        break;
                    case "minus":
                        handleReduceQuantity(cart, product, idProduct, isAjax, response);
                        break;
                    case "remove":
                        handleRemoveFromCart(cart, idProduct, isAjax, response);
                        break;
                    default:
                        sendErrorResponse(isAjax, response, "Invalid command", request);
                        return;
                }
                
                session.setAttribute("cart", cart);
                
                // Nếu không phải AJAX request, redirect như cũ
                if (!"true".equals(isAjax)) {
                    String referer = request.getHeader("Referer");
                    if (referer != null && referer.contains("cart.jsp")) {
                        response.sendRedirect(request.getContextPath() + "/cart.jsp");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                }
                
            } else {
                sendErrorResponse(isAjax, response, "Product not found", request);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            sendErrorResponse(isAjax, response, "Invalid product ID", request);
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(isAjax, response, "Database error occurred", request);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(isAjax, response, "An unexpected error occurred", request);
        }
    }
    
    /**
     * Handle adding product to cart with stock checking
     */
    private void handleAddToCart(Cart cart, Product product, Long productId, String isAjax, 
                                HttpServletResponse response) throws IOException, SQLException {
        
        // Lấy số lượng hiện tại trong giỏ hàng
        int currentCartQuantity = 0;
        if (cart.getCartItems().containsKey(productId)) {
            currentCartQuantity = cart.getCartItems().get(productId).getQuantity();
        }
        
        // Số lượng mới sẽ là currentCartQuantity + 1
        int newQuantity = currentCartQuantity + 1;
        
        // Kiểm tra tồn kho
        int availableStock = productDAO.getCurrentStock(productId);
        
        if (newQuantity > availableStock) {
            // Không đủ hàng
            if ("true".equals(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("success", false);
                jsonResponse.put("error", "Insufficient stock. Available: " + availableStock + 
                               ", In cart: " + currentCartQuantity);
                jsonResponse.put("availableStock", availableStock);
                jsonResponse.put("currentCartQuantity", currentCartQuantity);

                response.getWriter().write(jsonResponse.toString());
                return;
            } else {
                // Non-AJAX request - sẽ được xử lý ở method gọi
                throw new RuntimeException("Insufficient stock. Available: " + availableStock);
            }
        }
        
        // Đủ hàng - thêm vào giỏ hàng
        if (cart.getCartItems().containsKey(productId)) {
            cart.plusToCart(productId, new Item(product, currentCartQuantity));
        } else {
            cart.plusToCart(productId, new Item(product, 1));
        }
        
        // Trả về response thành công cho AJAX
        if ("true".equals(isAjax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);
            jsonResponse.put("cartCount", cart.countItem());
            jsonResponse.put("cartTotal", cart.totalCart());
            jsonResponse.put("productName", product.getProductName());
            jsonResponse.put("newQuantity", newQuantity);
            jsonResponse.put("availableStock", availableStock);

            response.getWriter().write(jsonResponse.toString());
        }
    }
    
    /**
     * Handle reducing quantity in cart
     */
    private void handleReduceQuantity(Cart cart, Product product, Long productId, String isAjax, 
                                     HttpServletResponse response) throws IOException {
        
        if (cart.getCartItems().containsKey(productId)) {
            int currentQuantity = cart.getCartItems().get(productId).getQuantity();
            cart.subToCart(productId, new Item(product, currentQuantity));
            
            // Trả về response cho AJAX
            if ("true".equals(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("success", true);
                jsonResponse.put("cartCount", cart.countItem());
                jsonResponse.put("cartTotal", cart.totalCart());
                jsonResponse.put("productName", product.getProductName());

                response.getWriter().write(jsonResponse.toString());
            }
        }
    }
    
    /**
     * Handle removing product from cart
     */
    private void handleRemoveFromCart(Cart cart, Long productId, String isAjax, 
                                     HttpServletResponse response) throws IOException, SQLException {
        
        String productName = "";
        if (cart.getCartItems().containsKey(productId)) {
            productName = cart.getCartItems().get(productId).getProduct().getProductName();
        }
        
        cart.removeToCart(productId);
        
        // Trả về response cho AJAX
        if ("true".equals(isAjax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);
            jsonResponse.put("cartCount", cart.countItem());
            jsonResponse.put("cartTotal", cart.totalCart());
            jsonResponse.put("productName", productName);

            response.getWriter().write(jsonResponse.toString());
        }
    }
    
    /**
     * Send error response
     */
    private void sendErrorResponse(String isAjax, HttpServletResponse response, String errorMessage, 
                                  HttpServletRequest request) throws IOException {
        
        if ("true".equals(isAjax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);
            jsonResponse.put("error", errorMessage);
            
            response.getWriter().write(jsonResponse.toString());
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=" + 
                                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }
}