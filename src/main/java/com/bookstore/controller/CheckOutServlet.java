package com.bookstore.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;

import com.bookstore.dao.BillDAO;
import com.bookstore.dao.BillDetailDAO;
import com.bookstore.dao.ProductDAO;
import com.bookstore.dao.UsersDAO;
import com.bookstore.model.Bill;
import com.bookstore.model.BillDetail;
import com.bookstore.model.Cart;
import com.bookstore.model.Item;
import com.bookstore.model.Product;
import com.bookstore.model.Users;
import com.bookstore.tools.SendMail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CheckOutServlet", urlPatterns = {"/CheckOutServlet"})
public class CheckOutServlet extends HttpServlet {

    private final BillDAO billDAO = new BillDAO();
    private final BillDetailDAO billDetailDAO = new BillDetailDAO();
    private final UsersDAO usersDAO = new UsersDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        Users users = (Users) session.getAttribute("user");
        
        // Kiểm tra user đã đăng nhập
        if (users == null || usersDAO.getUser(users.getUserID()) == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }

        // Kiểm tra giỏ hàng
        if (cart == null || cart.getCartItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=" + 
                                java.net.URLEncoder.encode("Giỏ hàng trống", "UTF-8"));
            return;
        }

        // Kiểm tra tồn kho cho tất cả sản phẩm trong giỏ hàng
        StringBuilder stockErrors = new StringBuilder();
        
        try {
            for (Map.Entry<Long, Item> entry : cart.getCartItems().entrySet()) {
                Item item = entry.getValue();
                long productId = item.getProduct().getProductID();
                int requestedQuantity = item.getQuantity();
                
                // Kiểm tra tồn kho
                if (!productDAO.checkStock(productId, requestedQuantity)) {
                    int currentStock = productDAO.getCurrentStock(productId);
                    if (stockErrors.length() > 0) {
                        stockErrors.append(", ");
                    }
                    stockErrors.append(item.getProduct().getProductName())
                              .append(" (yêu cầu: ").append(requestedQuantity)
                              .append(", có sẵn: ").append(currentStock).append(")");
                }
            }
            
            // Nếu có lỗi tồn kho, redirect về cart với thông báo lỗi
            if (stockErrors.length() > 0) {
                String errorMessage = "Số lượng không đủ cho: " + stockErrors.toString();
                response.sendRedirect(request.getContextPath() + "/cart.jsp?error=" + 
                                    java.net.URLEncoder.encode(errorMessage, "UTF-8"));
                return;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart.jsp?error=" + 
                                java.net.URLEncoder.encode("Lỗi kiểm tra tồn kho", "UTF-8"));
            return;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("total", cart.totalCart());

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get form data
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String country = request.getParameter("country");
        String address = request.getParameter("address");
        String payment = request.getParameter("payment");
        
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        Users users = (Users) session.getAttribute("user");
        
        // Validation
        if (users == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }
        
        if (cart == null || cart.getCartItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=" + 
                                java.net.URLEncoder.encode("Giỏ hàng trống", "UTF-8"));
            return;
        }
        
        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            payment == null || payment.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=" + 
                                java.net.URLEncoder.encode("Vui lòng điền đầy đủ thông tin bắt buộc", "UTF-8"));
            return;
        }
        
        try {
            // Double-check stock before processing order
            StringBuilder stockErrors = new StringBuilder();
            
            for (Map.Entry<Long, Item> entry : cart.getCartItems().entrySet()) {
                Item item = entry.getValue();
                long productId = item.getProduct().getProductID();
                int requestedQuantity = item.getQuantity();
                
                if (!productDAO.checkStock(productId, requestedQuantity)) {
                    int currentStock = productDAO.getCurrentStock(productId);
                    if (stockErrors.length() > 0) {
                        stockErrors.append(", ");
                    }
                    stockErrors.append(item.getProduct().getProductName())
                              .append(" (yêu cầu: ").append(requestedQuantity)
                              .append(", có sẵn: ").append(currentStock).append(")");
                }
            }
            
            if (stockErrors.length() > 0) {
                String errorMessage = "Số lượng không đủ cho: " + stockErrors.toString();
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=" + 
                                    java.net.URLEncoder.encode(errorMessage, "UTF-8"));
                return;
            }
            
            // Tạo Bill
            long billID = new Date().getTime();
            Bill bill = new Bill();
            bill.setBillID(billID);
            bill.setAddress(address.trim());
            bill.setPayment(payment);
            bill.setUserID(users.getUserID());
            bill.setDate(new Timestamp(new Date().getTime()));
            bill.setTotal(cart.totalCart());
            
            // Insert Bill vào database
            billDAO.insertBill(bill);
            System.out.println("Bill created successfully with ID: " + billID);
            
            // Process từng item trong cart
            boolean allStockUpdated = true;
            StringBuilder processingErrors = new StringBuilder();
            
            for (Map.Entry<Long, Item> entry : cart.getCartItems().entrySet()) {
                Item item = entry.getValue();
                Product product = item.getProduct();
                
                try {
                    // Insert bill detail
                    BillDetail billDetail = new BillDetail(0, billID,
                            product.getProductID(),
                            product.getProductPrice(),
                            item.getQuantity());
                    billDetailDAO.insertBillDetail(billDetail);
                    
                    // Update stock (trừ số lượng đã bán)
                    boolean stockUpdated = productDAO.updateStock(product.getProductID(), 
                                                                 item.getQuantity());
                    
                    if (!stockUpdated) {
                        allStockUpdated = false;
                        if (processingErrors.length() > 0) {
                            processingErrors.append(", ");
                        }
                        processingErrors.append(product.getProductName());
                        System.err.println("Failed to update stock for product: " + product.getProductName());
                    } else {
                        System.out.println("Stock updated successfully for " + product.getProductName() + 
                                         ". Quantity sold: " + item.getQuantity());
                    }
                    
                } catch (SQLException e) {
                    allStockUpdated = false;
                    if (processingErrors.length() > 0) {
                        processingErrors.append(", ");
                    }
                    processingErrors.append(product.getProductName());
                    System.err.println("Error processing item " + product.getProductName() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            // Send confirmation email
            try {
                SendMail sm = new SendMail();
                String emailContent = buildEmailContent(users, cart, billID, fullName, phone, 
                                                       country, address, payment);
                boolean emailSent = sm.sendMail(users.getUserEmail(), "BookStore - Xác nhận đơn hàng", emailContent);
                
                if (emailSent) {
                    System.out.println("Confirmation email sent to: " + users.getUserEmail());
                } else {
                    System.err.println("Failed to send confirmation email to: " + users.getUserEmail());
                }
            } catch (Exception e) {
                System.err.println("Error sending email: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Store order info in session for success page
            session.setAttribute("orderInfo", new OrderInfo(billID, fullName, phone, 
                                                           country, address, payment, 
                                                           cart.totalCart(), cart.countItem()));
            
            // Clear cart
            cart = new Cart();
            session.setAttribute("cart", cart);
            
            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/order_success.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            String errorMessage = "Có lỗi xảy ra khi xử lý đơn hàng. Vui lòng thử lại.";
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=" + 
                                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = "Có lỗi không mong muốn xảy ra. Vui lòng thử lại.";
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=" + 
                                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }
    
    /**
     * Build email content for order confirmation
     */
    private String buildEmailContent(Users user, Cart cart, long billID, String fullName, 
                                    String phone, String country, String address, String payment) {
        StringBuilder content = new StringBuilder();
        
        content.append("Kính chào ").append(fullName).append(",\n\n");
        content.append("Cảm ơn bạn đã đặt hàng tại BookStore!\n\n");
        content.append("THÔNG TIN ĐỐN HÀNG:\n");
        content.append("Mã đơn hàng: ").append(billID).append("\n");
        content.append("Ngày đặt: ").append(new Date().toString()).append("\n");
        content.append("Tên khách hàng: ").append(fullName).append("\n");
        content.append("Số điện thoại: ").append(phone).append("\n");
        if (country != null && !country.trim().isEmpty()) {
            content.append("Quốc gia: ").append(country).append("\n");
        }
        content.append("Địa chỉ giao hàng: ").append(address).append("\n");
        content.append("Phương thức thanh toán: ").append(payment).append("\n\n");
        
        content.append("CHI TIẾT SẢN PHẨM:\n");
        content.append("----------------------------------------\n");
        
        for (Map.Entry<Long, Item> entry : cart.getCartItems().entrySet()) {
            Item item = entry.getValue();
            Product product = item.getProduct();
            double itemTotal = product.getProductPrice() * item.getQuantity();
            
            content.append(product.getProductName()).append("\n");
            content.append("  Số lượng: ").append(item.getQuantity()).append("\n");
            content.append("  Đơn giá: $").append(String.format("%.2f", product.getProductPrice())).append("\n");
            content.append("  Thành tiền: $").append(String.format("%.2f", itemTotal)).append("\n\n");
        }
        
        content.append("----------------------------------------\n");
        content.append("TỔNG TIỀN: $").append(String.format("%.2f", cart.totalCart())).append("\n\n");
        
        content.append("Đơn hàng của bạn đang được xử lý và sẽ được giao đến địa chỉ đã cung cấp.\n");
        content.append("Bạn sẽ nhận được email khác với thông tin theo dõi khi đơn hàng được gửi đi.\n\n");
        content.append("Cảm ơn bạn đã chọn BookStore!\n\n");
        content.append("Trân trọng,\n");
        content.append("Đội ngũ BookStore");
        
        return content.toString();
    }
    
    /**
     * Inner class to store order information
     */
    public static class OrderInfo {
        private long orderId;
        private String fullName;
        private String phone;
        private String country;
        private String address;
        private String payment;
        private double total;
        private int itemCount;
        
        public OrderInfo(long orderId, String fullName, String phone, String country, 
                        String address, String payment, double total, int itemCount) {
            this.orderId = orderId;
            this.fullName = fullName;
            this.phone = phone;
            this.country = country;
            this.address = address;
            this.payment = payment;
            this.total = total;
            this.itemCount = itemCount;
        }
        
        // Getters
        public long getOrderId() { return orderId; }
        public String getFullName() { return fullName; }
        public String getPhone() { return phone; }
        public String getCountry() { return country; }
        public String getAddress() { return address; }
        public String getPayment() { return payment; }
        public double getTotal() { return total; }
        public int getItemCount() { return itemCount; }
    }
}