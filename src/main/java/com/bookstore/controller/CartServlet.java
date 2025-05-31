package com.bookstore.controller;

import java.io.IOException;

import com.bookstore.dao.ProductDAO;
import com.bookstore.model.Cart;
import com.bookstore.model.Item;
import com.bookstore.model.Product;

import org.json.JSONObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
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
                            if (cart.getCartItems().containsKey(idProduct)) {
                                cart.plusToCart(idProduct, new Item(product,
                                        cart.getCartItems().get(idProduct).getQuantity()));
                            } else {
                                cart.plusToCart(idProduct, new Item(product, 1));
                            }
                            break;
                        case "minus":
                            if (cart.getCartItems().containsKey(idProduct)) {
                                cart.subToCart(idProduct, new Item(product,
                                        cart.getCartItems().get(idProduct).getQuantity()));
                            }
                            break;
                        case "remove":
                            cart.removeToCart(idProduct);
                            break;
                    }
                }

                session.setAttribute("cart", cart);

                // Nếu là AJAX request, trả về JSON
                if ("true".equals(isAjax)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    JSONObject jsonResponse = new JSONObject();
                    jsonResponse.put("success", true);
                    jsonResponse.put("cartCount", cart.countItem());
                    jsonResponse.put("cartTotal", cart.totalCart());
                    jsonResponse.put("productName", product != null ? product.getProductName() : "");

                    response.getWriter().write(jsonResponse.toString());
                    return;
                }

                // Nếu không phải AJAX, redirect như cũ
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("cart.jsp")) {
                    response.sendRedirect(request.getContextPath() + "/cart.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }

            } catch (Exception e) {
                e.printStackTrace();

                if ("true".equals(isAjax)) {
                    response.setContentType("application/json");
                    JSONObject jsonResponse = new JSONObject();
                    jsonResponse.put("success", false);
                    jsonResponse.put("error", "Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng");
                    response.getWriter().write(jsonResponse.toString());
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            }
        }
    
}
