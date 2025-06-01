<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Details - BookStore</title>
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
        <script type="text/javascript">
            jQuery(document).ready(function ($) {
                $(".scroll").click(function (event) {
                    event.preventDefault();
                    $('html,body').animate({scrollTop: $(this.hash).offset().top}, 1000);
                });
            });
        </script>
        <!--slider-script-->
        <script src="js/responsiveslides.min.js"></script>
        <script>
            $(function () {
                $("#slider1").responsiveSlides({
                    auto: true,
                    speed: 500,
                    namespace: "callbacks",
                    pager: true,
                });
            });
        </script>
        <!--//slider-script-->
        <script>$(document).ready(function (c) {
                $('.alert-close').on('click', function (c) {
                    $('.message').fadeOut('slow', function (c) {
                        $('.message').remove();
                    });
                });
            });
        </script>
        <script>$(document).ready(function (c) {
                $('.alert-close1').on('click', function (c) {
                    $('.message1').fadeOut('slow', function (c) {
                        $('.message1').remove();
                    });
                });
            });
        </script>
        
        <style>
            .stock-section {
                margin: 20px 0;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 8px;
                border-left: 4px solid #007cba;
            }
            
            .stock-status {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
            }
            
            .stock-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .stock-badge.in-stock {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .stock-badge.low-stock {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }
            
            .stock-badge.out-of-stock {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .quantity-selector {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 15px 0;
                padding: 15px;
                background-color: #ffffff;
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }
            
            .quantity-label {
                font-weight: bold;
                color: #333;
                margin-right: 10px;
            }
            
            .quantity-controls {
                display: flex;
                align-items: center;
                gap: 5px;
                border: 1px solid #ddd;
                border-radius: 4px;
                overflow: hidden;
            }
            
            .quantity-btn {
                background: #f8f9fa;
                border: none;
                padding: 8px 12px;
                cursor: pointer;
                font-weight: bold;
                color: #333;
                transition: background-color 0.3s;
            }
            
            .quantity-btn:hover:not(:disabled) {
                background: #007cba;
                color: white;
            }
            
            .quantity-btn:disabled {
                background: #e9ecef;
                color: #6c757d;
                cursor: not-allowed;
            }
            
            .quantity-input {
                border: none;
                text-align: center;
                width: 60px;
                padding: 8px;
                font-weight: bold;
                outline: none;
            }
            
            .add-to-cart-enhanced {
                display: flex;
                align-items: center;
                gap: 15px;
                margin: 20px 0;
            }
            
            .add-to-cart-btn.enhanced {
                flex: 1;
                padding: 15px 25px;
                font-size: 16px;
                font-weight: bold;
                transition: all 0.3s;
                text-align: center;
            }
            
            .add-to-cart-btn.disabled {
                background-color: #6c757d !important;
                color: #adb5bd !important;
                cursor: not-allowed;
                opacity: 0.6;
            }
            
            .stock-warning {
                background-color: #fff3cd;
                color: #856404;
                padding: 10px;
                border-radius: 4px;
                border: 1px solid #ffeaa7;
                margin: 10px 0;
                font-size: 14px;
            }
            
            .stock-info-detail {
                font-size: 14px;
                color: #666;
                margin-top: 8px;
            }
            
            .pricing-section {
                margin: 20px 0;
            }
            
            .price-display {
                font-size: 28px;
                font-weight: bold;
                color: #007cba;
                margin: 10px 0;
            }
            
            .total-preview {
                padding: 10px;
                background-color: #e3f2fd;
                border-radius: 4px;
                margin: 10px 0;
                font-weight: bold;
            }
            
            .product-actions {
                display: flex;
                gap: 15px;
                margin: 20px 0;
            }
            
            .btn-secondary-action {
                padding: 12px 20px;
                background-color: #6c757d;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-weight: bold;
                text-align: center;
                transition: background-color 0.3s;
            }
            
            .btn-secondary-action:hover {
                background-color: #545b62;
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <%
            ProductDAO productDAO = new ProductDAO();
            Product product = new Product();
            String productID = "";
            if (request.getParameter("productID") != null) {
                productID = request.getParameter("productID");
                try {
                    product = productDAO.getProduct(Long.parseLong(productID));
                } catch (Exception e) {
                    // Handle error - product not found
                    response.sendRedirect("index.jsp?error=" + 
                        java.net.URLEncoder.encode("Product not found", "UTF-8"));
                    return;
                }
            } else {
                response.sendRedirect("index.jsp");
                return;
            }
            
            if (product == null || product.getProductID() == 0) {
                response.sendRedirect("index.jsp?error=" + 
                    java.net.URLEncoder.encode("Product not found", "UTF-8"));
                return;
            }
            
            boolean isOutOfStock = product.isOutOfStock();
            boolean isLowStock = product.hasLowStock();
            String stockClass = product.getStockStatusClass();
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="container">
            <div class="single">
                <div class="col-md-9 top-in-single">
                    <div class="col-md-5 single-top">	
                        <a href="#" onclick="return false;">
                            <img class="etalage_thumb_image img-responsive" 
                                 src="<%=product.getProductImage()%>" 
                                 alt="<%=product.getProductName()%>">
                        </a>
                    </div>	
                    
                    <div class="col-md-7 single-top-in">
                        <div class="single-para">
                            <h4><%=product.getProductName()%></h4>
                            
                            <!-- Stock Information Section -->
                            <div class="stock-section">
                                <div class="stock-status">
                                    <span class="stock-badge <%=stockClass%>">
                                        <%=product.getStockStatus()%>
                                    </span>
                                    <%if(!isOutOfStock) {%>
                                        <span class="stock-info-detail">
                                            <%=product.getQuantity()%> items available
                                        </span>
                                    <%}%>
                                </div>
                                
                                <%if(isLowStock && !isOutOfStock) {%>
                                    <div class="stock-warning">
                                        ⚠️ <strong>Hurry!</strong> Only <%=product.getQuantity()%> left in stock!
                                    </div>
                                <%}%>
                                
                                <%if(isOutOfStock) {%>
                                    <div class="stock-warning" style="background-color: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                                        😔 <strong>Sorry!</strong> This item is currently out of stock.
                                    </div>
                                <%}%>
                            </div>
                            
                            <!-- Pricing Section -->
                            <div class="pricing-section">
                                <div class="price-display">
                                    <%=String.format("%.2f", product.getProductPrice())%> VND
                                </div>
                            </div>
                            
                            <%if(!isOutOfStock) {%>
                                <!-- Quantity Selector -->
                                <div class="quantity-selector">
                                    <span class="quantity-label">Quantity:</span>
                                    <div class="quantity-controls">
                                        <button type="button" class="quantity-btn" id="decrease-btn">−</button>
                                        <input type="number" id="quantity-input" class="quantity-input" 
                                               value="1" min="1" max="<%=product.getQuantity()%>">
                                        <button type="button" class="quantity-btn" id="increase-btn">+</button>
                                    </div>
                                    <span id="max-quantity-info" class="stock-info-detail">
                                        (Max: <%=product.getQuantity()%>)
                                    </span>
                                </div>
                                
                                <!-- Total Preview -->
                                <div class="total-preview">
                                    Total: <span id="total-price"><%=String.format("%.2f", product.getProductPrice())%> VND</span>
                                </div>
                                
                                <!-- Add to Cart Section -->
                                <div class="add-to-cart-enhanced">
                                    <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2 add-to-cart-btn enhanced" 
                                       data-product-id="<%=productID%>" 
                                       data-product-name="<%=product.getProductName()%>"
                                       data-available-stock="<%=product.getQuantity()%>"
                                       data-price="<%=product.getProductPrice()%>"
                                       id="add-to-cart-main">
                                       🛒 ADD TO CART
                                    </a>
                                </div>
                            <%} else {%>
                                <!-- Out of Stock Actions -->
                                <div class="add-to-cart-enhanced">
                                    <span class="add-to-cart-btn enhanced disabled">
                                        🔒 OUT OF STOCK
                                    </span>
                                </div>
                            <%}%>
                            
                            <!-- Product Description -->
                            <div style="margin: 25px 0;">
                                <h5>Product Description</h5>
                                <p><%=product.getProductDescription()%></p>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="product-actions">
                                <a href="index.jsp" class="btn-secondary-action">
                                    ← Continue Shopping
                                </a>
                                <a href="cart.jsp" class="btn-secondary-action">
                                    🛒 View Cart
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"> </div>
                    
                    <!-- Related Products Section (placeholder) -->
                    <div class="content-top-in" style="margin-top: 40px;">
                        <h4 style="margin-bottom: 20px;">You might also like</h4>
                        <div class="col-md-4 top-single">
                            <div class="col-md">
                                <img src="images/pic8.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Related Book 1</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>15</span><span>.99</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>
                        <div class="col-md-4 top-single">
                            <div class="col-md">
                                <img src="images/pic9.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Related Book 2</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>12</span><span>.99</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>
                        <div class="col-md-4 top-single-in">
                            <div class="col-md">
                                <img src="images/pic10.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Related Book 3</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>18</span><span>.99</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>

                        <div class="clearfix"></div>
                    </div>
                </div>
                <div class="clearfix"> </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>
        
        <script type="text/javascript">
            $(document).ready(function() {
                var maxQuantity = <%=product.getQuantity()%>;
                var unitPrice = <%=product.getProductPrice()%>;
                var currentQuantity = 1;
                
                // Quantity controls
                $('#increase-btn').click(function() {
                    if (currentQuantity < maxQuantity) {
                        currentQuantity++;
                        $('#quantity-input').val(currentQuantity);
                        updateTotal();
                    }
                    updateQuantityButtons();
                });
                
                $('#decrease-btn').click(function() {
                    if (currentQuantity > 1) {
                        currentQuantity--;
                        $('#quantity-input').val(currentQuantity);
                        updateTotal();
                    }
                    updateQuantityButtons();
                });
                
                $('#quantity-input').on('input change', function() {
                    var newQuantity = parseInt($(this).val());
                    if (isNaN(newQuantity) || newQuantity < 1) {
                        newQuantity = 1;
                    } else if (newQuantity > maxQuantity) {
                        newQuantity = maxQuantity;
                    }
                    
                    currentQuantity = newQuantity;
                    $(this).val(currentQuantity);
                    updateTotal();
                    updateQuantityButtons();
                });
                
                function updateQuantityButtons() {
                    $('#decrease-btn').prop('disabled', currentQuantity <= 1);
                    $('#increase-btn').prop('disabled', currentQuantity >= maxQuantity);
                }
                
                function updateTotal() {
                    var total = currentQuantity * unitPrice;
                    $('#total-price').text(total.toFixed(2));
                }
                
                // Add to cart functionality
                $('#add-to-cart-main').click(function(e) {
                    e.preventDefault();

                    if ($(this).hasClass('disabled')) {
                        return false;
                    }

                    var productId = $(this).data('product-id');
                    var productName = $(this).data('product-name');
                    var availableStock = $(this).data('available-stock');
                    var button = $(this);

                    // Show loading state
                    var originalText = button.html();
                    button.html('🔄 Adding...').prop('disabled', true);

                    // Add items one by one to match selected quantity
                    addMultipleItems(productId, productName, currentQuantity, 0, button, originalText);
                });
                
                function addMultipleItems(productId, productName, totalQuantity, addedSoFar, button, originalText) {
                    if (addedSoFar >= totalQuantity) {
                        // All items added successfully
                        button.html(originalText).prop('disabled', false);
                        showNotification('✅ Added ' + totalQuantity + ' × "' + productName + '" to cart!', 'success');
                        
                        // Update page stock info if needed
                        updatePageStock(totalQuantity);
                        return;
                    }
                    
                    $.ajax({
                        url: 'CartServlet',
                        type: 'POST',
                        data: {
                            command: 'plus',
                            productID: productId,
                            ajax: 'true'
                        },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                // Update cart count in header
                                $('.cart span').text(response.cartCount);
                                
                                // Add next item
                                addMultipleItems(productId, productName, totalQuantity, addedSoFar + 1, button, originalText);
                            } else {
                                button.html(originalText).prop('disabled', false);
                                showNotification('❌ ' + (response.error || 'Error adding product to cart'), 'error');
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error('AJAX Error:', error);
                            button.html(originalText).prop('disabled', false);
                            showNotification('❌ Error adding product to cart. Please try again.', 'error');
                        }
                    });
                }
                
                function updatePageStock(quantityAdded) {
                    maxQuantity -= quantityAdded;
                    if (maxQuantity <= 0) {
                        // Out of stock
                        $('.stock-section').html(`
                            <div class="stock-status">
                                <span class="stock-badge out-of-stock">Out of Stock</span>
                            </div>
                            <div class="stock-warning" style="background-color: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                                😔 <strong>Sorry!</strong> This item is now out of stock.
                            </div>
                        `);
                        $('.quantity-selector, .add-to-cart-enhanced').hide();
                    } else {
                        // Update stock display
                        $('.stock-info-detail').text(maxQuantity + ' items available');
                        $('#max-quantity-info').text('(Max: ' + maxQuantity + ')');
                        $('#quantity-input').attr('max', maxQuantity);
                        
                        if (currentQuantity > maxQuantity) {
                            currentQuantity = maxQuantity;
                            $('#quantity-input').val(currentQuantity);
                            updateTotal();
                        }
                        updateQuantityButtons();
                        
                        // Update low stock warning
                        if (maxQuantity <= 10) {
                            $('.stock-badge').removeClass('in-stock').addClass('low-stock').text('Low Stock');
                            if ($('.stock-warning').length === 0) {
                                $('.stock-status').after(`
                                    <div class="stock-warning">
                                        ⚠️ <strong>Hurry!</strong> Only ` + maxQuantity + ` left in stock!
                                    </div>
                                `);
                            } else {
                                $('.stock-warning').html('⚠️ <strong>Hurry!</strong> Only ' + maxQuantity + ' left in stock!');
                            }
                        }
                    }
                }

                // Notification function
                function showNotification(message, type) {
                    // Remove existing notifications
                    $('.notification').remove();

                    var notification = $('<div class="notification notification-' + type + '">' + message + '</div>');

                    $('body').append(notification);

                    // Show notification
                    setTimeout(function() {
                        notification.addClass('show');
                    }, 100);

                    // Hide notification after 4 seconds
                    setTimeout(function() {
                        notification.removeClass('show');
                        setTimeout(function() {
                            notification.remove();
                        }, 300);
                    }, 4000);
                }
                
                // Initialize
                updateQuantityButtons();
            });
        </script>

        <style>
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            z-index: 9999;
            transform: translateX(400px);
            transition: transform 0.3s ease;
            max-width: 350px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification-success {
            background: linear-gradient(135deg, #28a745, #20c997);
        }

        .notification-error {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
        }

        .add-to-cart-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        </style>
    </body>
</html>