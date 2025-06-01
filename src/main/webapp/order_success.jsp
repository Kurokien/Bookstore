<%@page import="com.bookstore.controller.CheckOutServlet.OrderInfo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Success - BookStore</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <script src="js/jquery.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <style>
            .success-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 40px 20px;
                text-align: center;
            }
            
            .success-header {
                margin-bottom: 30px;
            }
            
            .success-icon {
                width: 120px;
                height: 120px;
                margin: 0 auto 20px;
                background: linear-gradient(135deg, #28a745, #20c997);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 48px;
                color: white;
                animation: checkmark 1s ease-in-out;
            }           
            
            .success-title {
                color: #28a745;
                font-size: 32px;
                margin-bottom: 10px;
                font-weight: bold;
            }
            
            .success-subtitle {
                color: #666;
                font-size: 18px;
                margin-bottom: 30px;
            }
            
            .order-details {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                text-align: left;
            }
            
            .order-header {
                text-align: center;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f8f9fa;
            }
            
            .order-id {
                font-size: 24px;
                font-weight: bold;
                color: #007cba;
                margin-bottom: 5px;
            }
            
            .order-date {
                color: #666;
                font-size: 14px;
            }
            
            .detail-section {
                margin-bottom: 20px;
            }
            
            .detail-section h4 {
                color: #333;
                margin-bottom: 10px;
                font-size: 16px;
                padding-bottom: 5px;
                border-bottom: 1px solid #eee;
            }
            
            .detail-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            
            .detail-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                padding: 8px 0;
                border-bottom: 1px solid #f8f9fa;
            }
            
            .detail-label {
                font-weight: bold;
                color: #555;
            }
            
            .detail-value {
                color: #333;
            }
            
            .order-total {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-top: 20px;
            }
            
            .total-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }
            
            .total-final {
                font-size: 20px;
                font-weight: bold;
                color: #007cba;
                padding-top: 10px;
                border-top: 2px solid #007cba;
                margin-top: 10px;
            }
            
            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
                flex-wrap: wrap;
                margin-top: 30px;
            }
            
            .btn {
                padding: 12px 25px;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s;
                cursor: pointer;
            }
            
            .btn-primary {
                background: #007cba;
                color: white;
            }
            
            .btn-primary:hover {
                background: #005a87;
                color: white;
                transform: translateY(-2px);
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #545b62;
                color: white;
                transform: translateY(-2px);
            }
            
            .btn-success {
                background: #28a745;
                color: white;
            }
            
            .btn-success:hover {
                background: #218838;
                color: white;
                transform: translateY(-2px);
            }
            
            .payment-info {
                background: #e3f2fd;
                padding: 20px;
                border-radius: 8px;
                margin-top: 20px;
                border-left: 4px solid #007cba;
            }
            
            .payment-info h4 {
                color: #007cba;
                margin-bottom: 10px;
            }
            
            .next-steps {
                background: #fff3cd;
                padding: 20px;
                border-radius: 8px;
                margin-top: 20px;
                border-left: 4px solid #ffc107;
            }
            
            .next-steps h4 {
                color: #856404;
                margin-bottom: 15px;
            }
            
            .next-steps ul {
                text-align: left;
                margin: 0;
                padding-left: 20px;
            }
            
            .next-steps li {
                margin-bottom: 8px;
                color: #856404;
            }
            
            @media (max-width: 768px) {
                .detail-grid {
                    grid-template-columns: 1fr;
                }
                
                .action-buttons {
                    flex-direction: column;
                }
                
                .btn {
                    width: 100%;
                }
                
                .success-icon {
                    width: 80px;
                    height: 80px;
                    font-size: 32px;
                }
                
                .success-title {
                    font-size: 24px;
                }
            }
        </style>
        
        <script>
            $(document).ready(function() {
                // Auto-refresh cart count
                setTimeout(function() {
                    $('.cart span').text('0');
                }, 1000);
                
                // Confetti effect (simple)
                createConfetti();
            });
            
            function createConfetti() {
                const colors = ['#007cba', '#28a745', '#ffc107', '#dc3545', '#6c757d'];
                const confettiCount = 50;
                
                for (let i = 0; i < confettiCount; i++) {
                    const confetti = $('<div class="confetti"></div>');
                    confetti.css({
                        position: 'fixed',
                        left: Math.random() * 100 + '%',
                        top: '-10px',
                        width: '10px',
                        height: '10px',
                        backgroundColor: colors[Math.floor(Math.random() * colors.length)],
                        borderRadius: '50%',
                        zIndex: 9999,
                        pointerEvents: 'none',
                        animation: `fall ${Math.random() * 3 + 2}s linear forwards`
                    });
                    
                    $('body').append(confetti);
                    
                    setTimeout(() => confetti.remove(), 5000);
                }
            }
        </script>
        
        <style>
            @keyframes fall {
                to {
                    transform: translateY(100vh) rotate(360deg);
                    opacity: 0;
                }
            }
        </style>
    </head>
    <body>
        <%
            OrderInfo orderInfo = (OrderInfo) session.getAttribute("orderInfo");
            if (orderInfo == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="success-container">
            <div class="success-header">
                <div class="success-icon">✓</div>
                <h1 class="success-title">Đặt hàng thành công!</h1>
                <p class="success-subtitle">Cảm ơn bạn đã mua sắm tại BookStore</p>
            </div>

            <div class="order-details">
                <div class="order-header">
                    <div class="order-id">Đơn hàng #<%=orderInfo.getOrderId()%></div>
                    <div class="order-date">Đặt ngày: <%=new java.util.Date()%></div>
                </div>

                <div class="detail-grid">
                    <div class="detail-section">
                        <h4>📋 Thông tin khách hàng</h4>
                        <div class="detail-item">
                            <span class="detail-label">Họ tên:</span>
                            <span class="detail-value"><%=orderInfo.getFullName()%></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Điện thoại:</span>
                            <span class="detail-value"><%=orderInfo.getPhone()%></span>
                        </div>
                        <%if(orderInfo.getCountry() != null && !orderInfo.getCountry().trim().isEmpty()) {%>
                        <div class="detail-item">
                            <span class="detail-label">Quốc gia:</span>
                            <span class="detail-value"><%=orderInfo.getCountry()%></span>
                        </div>
                        <%}%>
                    </div>

                    <div class="detail-section">
                        <h4>🚚 Thông tin giao hàng</h4>
                        <div class="detail-item">
                            <span class="detail-label">Địa chỉ:</span>
                            <span class="detail-value"><%=orderInfo.getAddress()%></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Phương thức:</span>
                            <span class="detail-value">
                                <%if("Bank transfer".equals(orderInfo.getPayment())) {%>
                                    🏦 Chuyển khoản ngân hàng
                                <%} else if("Live".equals(orderInfo.getPayment())) {%>
                                    💵 Thanh toán khi nhận hàng
                                <%} else {%>
                                    <%=orderInfo.getPayment()%>
                                <%}%>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="order-total">
                    <div class="total-item">
                        <span>Số lượng sản phẩm:</span>
                        <span><%=orderInfo.getItemCount()%> sản phẩm</span>
                    </div>
                    <div class="total-item">
                        <span>Phí vận chuyển:</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="total-item total-final">
                        <span>Tổng tiền:</span>
                        <span>$<%=String.format("%.2f", orderInfo.getTotal())%></span>
                    </div>
                </div>
            </div>

            <%if("Bank transfer".equals(orderInfo.getPayment())) {%>
            <div class="payment-info">
                <h4>💳 Thông tin thanh toán</h4>
                <p><strong>Tên ngân hàng:</strong> Vietcombank</p>
                <p><strong>Số tài khoản:</strong> 1234567890</p>
                <p><strong>Tên chủ tài khoản:</strong> BookStore Company</p>
                <p><strong>Nội dung chuyển khoản:</strong> Don hang #<%=orderInfo.getOrderId()%></p>
                <p><em>Vui lòng chuyển khoản đúng số tiền và ghi rõ nội dung để đơn hàng được xử lý nhanh chóng.</em></p>
            </div>
            <%}%>

            <div class="next-steps">
                <h4>📌 Các bước tiếp theo</h4>
                <ul>
                    <li>Email xác nhận đã được gửi đến địa chỉ email của bạn</li>
                    <%if("Bank transfer".equals(orderInfo.getPayment())) {%>
                        <li>Vui lòng thực hiện chuyển khoản theo thông tin bên trên</li>
                        <li>Đơn hàng sẽ được xử lý sau khi nhận được thanh toán</li>
                    <%} else {%>
                        <li>Đơn hàng sẽ được xử lý trong vòng 24 giờ</li>
                        <li>Bạn sẽ thanh toán khi nhận hàng</li>
                    <%}%>
                    <li>Thời gian giao hàng: 2-5 ngày làm việc</li>
                    <li>Bạn sẽ nhận được thông tin theo dõi qua email/SMS</li>
                </ul>
            </div>

            <div class="action-buttons">
                <a href="index.jsp" class="btn btn-primary">🏠 Tiếp tục mua sắm</a>
                <a href="mailto:support@bookstore.com?subject=Order <%=orderInfo.getOrderId()%>" class="btn btn-secondary">📧 Liên hệ hỗ trợ</a>
                <button onclick="window.print()" class="btn btn-success">🖨️ In đơn hàng</button>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

        <%
            // Clear order info after displaying
            session.removeAttribute("orderInfo");
        %>
    </body>
</html>