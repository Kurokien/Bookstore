<%@page import="com.bookstore.model.Item"%>
<%@page import="java.util.Map"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout - BookStore</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="js/jquery.min.js"></script>
        <!-- Custom Theme files -->
        <!--theme-style-->
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />	
        <!--//theme-style-->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="keywords" content="Bonfire Responsive web template, Bootstrap Web Templates, Flat Web Templates, Andriod Compatible web template, 
            Smartphone Compatible web template, free webdesigns for Nokia, Samsung, LG, SonyErricsson, Motorola web design" />
        <script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
        <!--fonts-->
        <link href='http://fonts.googleapis.com/css?family=Exo:100,200,300,400,500,600,700,800,900' rel='stylesheet' type='text/css'>
        <!--//fonts-->
        <script type="text/javascript" src="js/move-top.js"></script>
        <script type="text/javascript" src="js/easing.js"></script>
        
        <style>
            .checkout-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .checkout-header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #eee;
            }
            
            .checkout-content {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 30px;
            }
            
            .checkout-form {
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .order-summary {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
            }
            
            .form-section {
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            
            .form-section:last-child {
                border-bottom: none;
            }
            
            .form-section h3 {
                color: #333;
                margin-bottom: 15px;
                font-size: 18px;
            }
            
            .form-row {
                display: flex;
                gap: 15px;
                margin-bottom: 15px;
            }
            
            .form-group {
                flex: 1;
                margin-bottom: 15px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            
            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            }
            
            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #007cba;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 124, 186, 0.3);
            }
            
            .required {
                color: red;
            }
            
            .cart-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px 0;
                border-bottom: 1px solid #eee;
            }
            
            .cart-item:last-child {
                border-bottom: none;
            }
            
            .item-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
                border: 1px solid #ddd;
            }
            
            .item-details h4 {
                margin: 0 0 5px 0;
                font-size: 14px;
                color: #333;
            }
            
            .item-details p {
                margin: 0;
                font-size: 12px;
                color: #666;
            }
            
            .item-price {
                margin-left: auto;
                text-align: right;
            }
            
            .item-price .price {
                font-weight: bold;
                color: #007cba;
            }
            
            .order-total {
                margin-top: 20px;
                padding-top: 15px;
                border-top: 2px solid #007cba;
            }
            
            .total-line {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }
            
            .total-line.final {
                font-size: 18px;
                font-weight: bold;
                color: #007cba;
                margin-top: 10px;
                padding-top: 10px;
                border-top: 1px solid #eee;
            }
            
            .checkout-btn {
                width: 100%;
                padding: 15px;
                background: #007cba;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
                transition: background-color 0.3s;
            }
            
            .checkout-btn:hover {
                background: #005a87;
            }
            
            .checkout-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
            }
            
            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
            }
            
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                border: 1px solid #c3e6cb;
            }
            
            @media (max-width: 768px) {
                .checkout-content {
                    grid-template-columns: 1fr;
                }
                
                .form-row {
                    flex-direction: column;
                }
            }
        </style>
        
        <script>
            $(document).ready(function() {
                // Form validation
                $('#checkoutForm').submit(function(e) {
                    var fullName = $('#fullName').val().trim();
                    var phone = $('#phone').val().trim();
                    var address = $('#address').val().trim();
                    var payment = $('#payment').val();
                    
                    if (fullName.length < 2) {
                        alert('Vui lòng nhập họ tên đầy đủ!');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (phone.length < 10) {
                        alert('Vui lòng nhập số điện thoại hợp lệ!');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (address.length < 10) {
                        alert('Vui lòng nhập địa chỉ đầy đủ!');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (!payment) {
                        alert('Vui lòng chọn phương thức thanh toán!');
                        e.preventDefault();
                        return false;
                    }
                    
                    // Show loading
                    $('.checkout-btn').prop('disabled', true).text('Đang xử lý...');
                    
                    return true;
                });
                
                // Phone number formatting
                $('#phone').on('input', function() {
                    var phone = $(this).val().replace(/\D/g, '');
                    if (phone.length > 0) {
                        if (phone.length <= 10) {
                            phone = phone.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                        }
                        $(this).val(phone);
                    }
                });
            });
        </script>
    </head>
    <body>

        <%
            Users users = (Users) session.getAttribute("user");
            if (users == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
                return;
            }
            
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getCartItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=empty_cart");
                return;
            }
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="checkout-container">
            <div class="checkout-header">
                <h2>🛒 Checkout</h2>
                <p>Review your order and complete your purchase</p>
            </div>
            
            <!-- Display messages -->
            <%if(request.getParameter("error") != null){%>
                <div class="error-message">
                    ❌ <%=request.getParameter("error")%>
                </div> 
            <%}%>
            
            <%if(request.getParameter("success") != null){%>
                <div class="success-message">
                    ✅ <%=request.getParameter("success")%>
                </div> 
            <%}%>

            <div class="checkout-content">
                <!-- Checkout Form -->
                <div class="checkout-form">
                    <form action="CheckOutServlet" method="POST" id="checkoutForm">
                        
                        <!-- Personal Information -->
                        <div class="form-section">
                            <h3>📋 Thông tin cá nhân</h3>
                            
                            <div class="form-group">
                                <label for="fullName">Họ và tên <span class="required">*</span></label>
                                <input type="text" name="fullName" id="fullName" required 
                                       value="<%=users.getUserFullname() != null ? users.getUserFullname() : ""%>"
                                       placeholder="Nhập họ tên đầy đủ">
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="phone">Số điện thoại <span class="required">*</span></label>
                                    <input type="tel" name="phone" id="phone" required 
                                           value="<%=users.getUserPhone() != null ? users.getUserPhone() : ""%>"
                                           placeholder="0123-456-789">
                                </div>
                                
                                <div class="form-group">
                                    <label for="country">Quốc gia</label>
                                    <select name="country" id="country">
                                        <option value="">Chọn quốc gia</option>
                                        <option value="Vietnam" <%="Vietnam".equals(users.getUserCountry()) ? "selected" : ""%>>Vietnam</option>
                                        <option value="United States">United States</option>
                                        <option value="United Kingdom">United Kingdom</option>
                                        <option value="Canada">Canada</option>
                                        <option value="Australia">Australia</option>
                                        <option value="Japan">Japan</option>
                                        <option value="South Korea">South Korea</option>
                                        <option value="Singapore">Singapore</option>
                                        <option value="Thailand">Thailand</option>
                                        <option value="Malaysia">Malaysia</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Shipping Information -->
                        <div class="form-section">
                            <h3>🚚 Thông tin giao hàng</h3>
                            
                            <div class="form-group">
                                <label for="address">Địa chỉ giao hàng <span class="required">*</span></label>
                                <textarea name="address" id="address" rows="3" required 
                                          placeholder="Nhập địa chỉ đầy đủ (số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)"><%=users.getUserAddress() != null ? users.getUserAddress() : ""%></textarea>
                            </div>
                        </div>
                        
                        <!-- Payment Information -->
                        <div class="form-section">
                            <h3>💳 Phương thức thanh toán</h3>
                            
                            <div class="form-group">
                                <label for="payment">Chọn phương thức <span class="required">*</span></label>
                                <select name="payment" id="payment" required>
                                    <option value="">-- Chọn phương thức thanh toán --</option>
                                    <option value="Bank transfer">🏦 Chuyển khoản ngân hàng</option>
                                    <option value="Live">💵 Thanh toán khi nhận hàng (COD)</option>
                                </select>
                            </div>
                        </div>
                        
                        <button type="submit" class="checkout-btn">
                            🚀 Hoàn tất đặt hàng
                        </button>
                    </form>
                </div>
                
                <!-- Order Summary -->
                <div class="order-summary">
                    <h3>📝 Đơn hàng của bạn</h3>
                    
                    <!-- Cart Items -->
                    <%for (Map.Entry<Long, Item> entry : cart.getCartItems().entrySet()) {
                        Item item = entry.getValue();
                        double itemTotal = item.getProduct().getProductPrice() * item.getQuantity();
                    %>
                    <div class="cart-item">
                        <img src="<%=item.getProduct().getProductImage()%>" 
                             alt="<%=item.getProduct().getProductName()%>" 
                             class="item-image">
                        
                        <div class="item-details">
                            <h4><%=item.getProduct().getProductName()%></h4>
                            <p>Quantity: <%=item.getQuantity()%></p>
                            <p>Unit price: $<%=String.format("%.2f", item.getProduct().getProductPrice())%></p>
                        </div>
                        
                        <div class="item-price">
                            <span class="price"><%=String.format("%.2f", itemTotal)%> VND</span>
                        </div>
                    </div>
                    <%}%>
                    
                    <!-- Order Total -->
                    <div class="order-total">
                        <div class="total-line">
                            <span>Subtotal:</span>
                            <span><%=String.format("%.2f", cart.totalCart())%> VND</span>
                        </div>
                        <div class="total-line">
                            <span>Shipping:</span>
                            <span>Free</span>
                        </div>
                        <div class="total-line">
                            <span>Tax:</span>
                            <span>0.00 VND</span>
                        </div>
                        <div class="total-line final">
                            <span>Total:</span>
                            <span><%=String.format("%.2f", cart.totalCart())%> VND</span>
                        </div>
                    </div>
                    
                    <!-- Security Info -->
                    <div style="margin-top: 20px; padding: 15px; background: #e3f2fd; border-radius: 4px; font-size: 12px;">
                        <strong>🔒 Bảo mật thanh toán</strong><br>
                        Thông tin của bạn được bảo vệ bằng mã hóa SSL 256-bit
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

    </body>
</html>