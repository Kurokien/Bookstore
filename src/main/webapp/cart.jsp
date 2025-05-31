<%@page import="com.bookstore.model.Item"%>
<%@page import="java.util.Map"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart - BookStore</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <script src="js/jquery.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <style>
            .cart-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                min-height: 500px;
            }
            
            .cart-header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #eee;
            }
            
            .cart-header h2 {
                color: #333;
                font-size: 28px;
                margin-bottom: 10px;
            }
            
            .cart-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
            }
            
            .cart-table th {
                background-color: #007cba;
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: bold;
            }
            
            .cart-table td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                vertical-align: middle;
            }
            
            .cart-table tr:hover {
                background-color: #f8f9fa;
            }
            
            .product-info {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            
            .product-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid #ddd;
            }
            
            .product-details h4 {
                margin: 0 0 5px 0;
                color: #333;
                font-size: 16px;
            }
            
            .product-details p {
                margin: 0;
                color: #666;
                font-size: 14px;
            }
            
            .quantity-controls {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .quantity-btn {
                width: 35px;
                height: 35px;
                border: 1px solid #ddd;
                background: #f8f9fa;
                color: #333;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                transition: all 0.3s;
            }
            
            .quantity-btn:hover {
                background: #007cba;
                color: white;
                border-color: #007cba;
            }
            
            .quantity-input {
                width: 60px;
                text-align: center;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }
            
            .price {
                font-weight: bold;
                color: #007cba;
                font-size: 16px;
            }
            
            .remove-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                transition: background 0.3s;
            }
            
            .remove-btn:hover {
                background: #c82333;
            }
            
            .cart-summary {
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            
            .cart-total {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 20px;
                font-weight: bold;
                color: #333;
                margin-bottom: 20px;
                padding-top: 15px;
                border-top: 2px solid #eee;
            }
            
            .cart-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .btn {
                padding: 12px 25px;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s;
                text-align: center;
            }
            
            .btn-primary {
                background: #007cba;
                color: white;
            }
            
            .btn-primary:hover {
                background: #005a87;
                color: white;
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #545b62;
                color: white;
            }
            
            .btn-success {
                background: #28a745;
                color: white;
                font-size: 18px;
                padding: 15px 30px;
            }
            
            .btn-success:hover {
                background: #218838;
                color: white;
            }
            
            .btn-danger {
                background: #dc3545;
                color: white;
            }
            
            .btn-danger:hover {
                background: #c82333;
                color: white;
            }
            
            .btn:disabled {
                background: #6c757d;
                color: #adb5bd;
                cursor: not-allowed;
                opacity: 0.5;
            }
            
            .select-all-checkbox,
            .item-checkbox {
                width: 18px;
                height: 18px;
                margin-right: 8px;
                cursor: pointer;
            }
            
            .selected-info {
                text-align: center;
                margin-bottom: 15px;
                font-weight: bold;
                color: #007cba;
                font-size: 16px;
            }
            
            .cart-table th:first-child,
            .cart-table td:first-child {
                text-align: center;
                width: 120px;
            }
            
            .empty-cart {
                text-align: center;
                padding: 60px 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .empty-cart img {
                width: 120px;
                opacity: 0.5;
                margin-bottom: 20px;
            }
            
            .empty-cart h3 {
                color: #666;
                margin-bottom: 15px;
            }
            
            .empty-cart p {
                color: #999;
                margin-bottom: 25px;
            }
            
            @media (max-width: 768px) {
                .cart-table {
                    font-size: 14px;
                }
                
                .cart-table th,
                .cart-table td {
                    padding: 10px 8px;
                }
                
                .product-info {
                    flex-direction: column;
                    text-align: center;
                    gap: 10px;
                }
                
                .product-image {
                    width: 60px;
                    height: 60px;
                }
                
                .cart-actions {
                    flex-direction: column;
                }
                
                .btn {
                    width: 100%;
                }
            }
            
            .loading {
                opacity: 0.6;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <%
            // Kiểm tra user và cart session
            Object userObj = session.getAttribute("user");
            Users currentUser = (userObj != null) ? (Users) userObj : null;
            
            Object cartObj = session.getAttribute("cart");
            Cart currentCart = (cartObj != null) ? (Cart) cartObj : new Cart();
            if (cartObj == null) {
                session.setAttribute("cart", currentCart);
            }
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="cart-container">
            <div class="cart-header">
                <h2>🛒 Your Shopping Cart</h2>
                <p>Review your items and proceed to checkout</p>
            </div>

            <% if (currentCart.getCartItems().isEmpty()) { %>
                <div class="empty-cart">
                    <h3>Your cart is empty</h3>
                    <p>Looks like you haven't added any books to your cart yet.</p>
                    <a href="index.jsp" class="btn btn-primary">Continue Shopping</a>
                </div>
            <% } else { %>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="select-all" class="select-all-checkbox">
                                <label for="select-all">Chọn tất cả</label>
                            </th>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map.Entry<Long, Item> entry : currentCart.getCartItems().entrySet()) {
                            Item item = entry.getValue();
                            double itemTotal = item.getProduct().getProductPrice() * item.getQuantity();
                        %>
                        <tr data-product-id="<%=item.getProduct().getProductID()%>">
                            <td>
                                <input type="checkbox" class="item-checkbox" 
                                       data-product-id="<%=item.getProduct().getProductID()%>"
                                       data-price="<%=itemTotal%>"
                                       data-product-name="<%=item.getProduct().getProductName()%>">
                            </td>
                            <td>
                                <div class="product-info">
                                    <img src="<%=item.getProduct().getProductImage()%>" 
                                         alt="<%=item.getProduct().getProductName()%>" 
                                         class="product-image">
                                    <div class="product-details">
                                        <h4><%=item.getProduct().getProductName()%></h4>
                                        <p><%=item.getProduct().getProductDescription().length() > 50 ? 
                                            item.getProduct().getProductDescription().substring(0, 50) + "..." : 
                                            item.getProduct().getProductDescription()%></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="price">$<%=String.format("%.2f", item.getProduct().getProductPrice())%></span>
                            </td>
                            <td>
                                <div class="quantity-controls">
                                    <button class="quantity-btn" data-action="decrease" data-product-id="<%=item.getProduct().getProductID()%>">−</button>
                                    <input type="number" class="quantity-input" id="qty-<%=item.getProduct().getProductID()%>" 
                                           value="<%=item.getQuantity()%>" min="1" max="99" 
                                           data-product-id="<%=item.getProduct().getProductID()%>">
                                    <button class="quantity-btn" data-action="increase" data-product-id="<%=item.getProduct().getProductID()%>">+</button>
                                </div>
                            </td>
                            <td>
                                <span class="price item-total">$<%=String.format("%.2f", itemTotal)%></span>
                            </td>
                            <td>
                                <button class="remove-btn" data-product-id="<%=item.getProduct().getProductID()%>">
                                    🗑️ Remove
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="cart-summary">
                    <div class="selected-info">
                        <span id="selected-count">0</span> sản phẩm được chọn
                    </div>
                    
                    <div class="cart-total">
                        <span>Tổng tiền (sản phẩm đã chọn):</span>
                        <span class="price" id="selected-total">$0.00</span>
                    </div>
                    
                    <div class="cart-actions">
                        <a href="index.jsp" class="btn btn-secondary">Tiếp tục mua sắm</a>
                        
                        <button id="remove-selected-btn" class="btn btn-danger" disabled>
                            🗑️ Xóa sản phẩm đã chọn
                        </button>
                        
                        <% if (currentUser != null) { %>
                            <button id="checkout-selected-btn" class="btn btn-success" disabled>
                                🚀 Thanh toán sản phẩm đã chọn
                            </button>
                        <% } else { %>
                            <a href="login.jsp?redirect=checkout" class="btn btn-success">Đăng nhập để thanh toán</a>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>

        <script type="text/javascript">
            $(document).ready(function() {
                console.log('Cart JavaScript loaded'); // Debug
                
                // Update quantity
                $('.quantity-btn').click(function() {
                    var productId = $(this).data('product-id');
                    var action = $(this).data('action');
                    var currentQty = parseInt($('#qty-' + productId).val());
                    var newQty = currentQty;
                    
                    if (action === 'increase') {
                        newQty = currentQty + 1;
                    } else if (action === 'decrease' && currentQty > 1) {
                        newQty = currentQty - 1;
                    }
                    
                    if (newQty !== currentQty) {
                        updateCart(productId, action);
                    }
                });
                
                // Direct quantity input change
                $('.quantity-input').change(function() {
                    var productId = $(this).data('product-id');
                    var newQty = parseInt($(this).val());
                    
                    if (newQty < 1) {
                        $(this).val(1);
                        return;
                    }
                });
                
                function updateCart(productId, action) {
                    // Show loading
                    $('body').addClass('loading');
                    
                    $.ajax({
                        url: 'CartServlet',
                        type: 'POST',
                        data: {
                            command: action === 'increase' ? 'plus' : (action === 'decrease' ? 'minus' : 'remove'),
                            productID: productId
                        },
                        success: function() {
                            // Just reload page
                            window.location.reload();
                        },
                        error: function() {
                            $('body').removeClass('loading');
                            alert('Có lỗi xảy ra khi cập nhật giỏ hàng!');
                        }
                    });
                }
                
                // Remove item (no confirmation)
                $('.remove-btn').click(function() {
                    var productId = $(this).data('product-id');
                    updateCart(productId, 'remove');
                });
                
                // Select all functionality
                $('#select-all').change(function() {
                    console.log('Select all clicked:', $(this).is(':checked')); // Debug
                    var isChecked = $(this).is(':checked');
                    $('.item-checkbox').prop('checked', isChecked);
                    updateSelectedInfo();
                });
                
                // Individual checkbox change
                $('.item-checkbox').change(function() {
                    console.log('Item checkbox changed:', $(this).data('product-id'), $(this).is(':checked')); // Debug
                    updateSelectedInfo();
                    updateSelectAllCheckbox();
                });
                
                // Update select all checkbox state
                function updateSelectAllCheckbox() {
                    var totalCheckboxes = $('.item-checkbox').length;
                    var checkedCheckboxes = $('.item-checkbox:checked').length;
                    
                    $('#select-all').prop('checked', totalCheckboxes === checkedCheckboxes);
                }
                
                // Update selected items info and total
                function updateSelectedInfo() {
                    var selectedItems = $('.item-checkbox:checked');
                    var selectedCount = selectedItems.length;
                    var selectedTotal = 0;
                    
                    selectedItems.each(function() {
                        var price = parseFloat($(this).data('price'));
                        selectedTotal += price;
                        console.log('Adding price:', price, 'Current total:', selectedTotal); // Debug
                    });
                    
                    console.log('Final - Count:', selectedCount, 'Total:', selectedTotal); // Debug
                    
                    $('#selected-count').text(selectedCount);
                    $('#selected-total').text('$' + selectedTotal.toFixed(2));
                    
                    // Enable/disable buttons
                    var hasSelection = selectedCount > 0;
                    $('#remove-selected-btn').prop('disabled', !hasSelection);
                    $('#checkout-selected-btn').prop('disabled', !hasSelection);
                }
                
                // Remove selected items
                $('#remove-selected-btn').click(function() {
                    var selectedItems = $('.item-checkbox:checked');
                    if (selectedItems.length === 0) return;
                    
                    $('body').addClass('loading');
                    var productIds = [];
                    selectedItems.each(function() {
                        productIds.push($(this).data('product-id'));
                    });
                    
                    // Remove items one by one
                    removeMultipleItems(productIds, 0);
                });
                
                function removeMultipleItems(productIds, index) {
                    if (index >= productIds.length) {
                        window.location.reload();
                        return;
                    }
                    
                    $.ajax({
                        url: 'CartServlet',
                        type: 'POST',
                        data: {
                            command: 'remove',
                            productID: productIds[index]
                        },
                        success: function() {
                            removeMultipleItems(productIds, index + 1);
                        },
                        error: function() {
                            $('body').removeClass('loading');
                            alert('Có lỗi xảy ra khi xóa sản phẩm!');
                        }
                    });
                }
                
                // Checkout selected items
                $('#checkout-selected-btn').click(function() {
                    var selectedItems = $('.item-checkbox:checked');
                    if (selectedItems.length === 0) {
                        alert('Vui lòng chọn ít nhất một sản phẩm để thanh toán!');
                        return;
                    }
                    
                    // For now, just redirect to checkout
                    window.location.href = 'checkout.jsp';
                });
                
                // Initialize
                console.log('Initializing...'); // Debug
                updateSelectedInfo();
            });
        </script>

        <jsp:include page="footer.jsp"></jsp:include>
    </body>
</html>