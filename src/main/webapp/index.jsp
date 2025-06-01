<%@page import="java.util.ArrayList"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BookStore - Home</title>
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
        <script src="js/responsiveslides.min.js"></script>
        
        <style>
            .stock-info {
                font-size: 12px;
                margin-top: 8px;
                padding: 4px 8px;
                border-radius: 4px;
                display: inline-block;
                font-weight: bold;
                text-transform: uppercase;
            }
            
            .in-stock {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .low-stock {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }
            
            .out-of-stock {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }                      
            
            .product-card {
                position: relative;
                transition: transform 0.3s ease;
            }
            
            .product-card:hover {
                transform: translateY(-5px);
            }
            
            .product-card.out-of-stock {
                opacity: 0.6;
            }
            
            .product-card.out-of-stock .col-md {
                position: relative;
            }
            
            .product-card.out-of-stock .col-md::before {
                content: "SOLD OUT";
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: rgba(220, 53, 69, 0.9);
                color: white;
                padding: 10px 20px;
                border-radius: 4px;
                font-weight: bold;
                z-index: 10;
                font-size: 14px;
                letter-spacing: 1px;
            }
            
            .add-to-cart-btn.disabled {
                background-color: #6c757d !important;
                color: #adb5bd !important;
                cursor: not-allowed;
                opacity: 0.6;
            }
            
            .add-to-cart-btn.disabled:hover {
                background-color: #6c757d !important;
                color: #adb5bd !important;
            }
            
            .quantity-display {
                font-size: 11px;
                color: #666;
                margin-top: 3px;
            }
            
            .success-message, .error-message {
                padding: 10px 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                font-weight: bold;
            }
            
            .success-message {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    
    <body>

        <%
            ProductDAO productDAO = new ProductDAO();
            String productName = "";
            if(request.getParameter("q") != null) {
                productName = request.getParameter("q");
            }
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }
            int pages = 1, firstResult = 0, maxResult = 0, total = 0;
            if (request.getParameter("pages") != null) {
                try {
                    pages = (int) Integer.parseInt(request.getParameter("pages"));
                } catch (Exception e) {
                    pages = 1;
                }
            }
            
            if(pages < 1 ) {
                pages = 1;
            }

            total = productDAO.countAllProduct(productName);
            if (total <= 8) {
                firstResult = 0;
                maxResult = total;
            }else{
                firstResult = (pages - 1) * 8;
                maxResult = 8;
            }

            ArrayList<Product> listProduct = productDAO.getListProductByNav(productName, firstResult, maxResult);
        %>

        <jsp:include page="header.jsp"></jsp:include>
        <jsp:include page="banner.jsp"></jsp:include>
        
        <br /><br />
        
        <!-- Display messages -->
        <div class="container">
            <%if(request.getParameter("success") != null){%>
                <div class="success-message">
                    ✅ <%=request.getParameter("success")%>
                </div> 
            <%}%>
            
            <%if(request.getParameter("error") != null){%>
                <div class="error-message">
                    ❌ <%=request.getParameter("error")%>
                </div> 
            <%}%>
        </div>
        
        <!---->
        <div class="container">
            <div class="content">
                <div class="content-top">
                    <h3 class="future">
                        <%if(productName != null && !productName.trim().isEmpty()) {%>
                            Search Results for "<%=productName%>" (<%=total%> books found)
                        <%} else {%>
                            Recommendation (<%=total%> books available)
                        <%}%>
                    </h3>
                    <div class="content-top-in">

                    <%
                        if (listProduct.isEmpty()) {
                    %>
                        <div style="text-align: center; padding: 50px; color: #666;">
                            <h4>No books found</h4>
                            <p>Try adjusting your search terms or browse our categories.</p>
                            <a href="index.jsp" class="btn btn-primary">View All Books</a>
                        </div>
                    <%
                        } else {
                            for (Product p : listProduct) {
                                String stockClass = p.getStockStatusClass();
                                boolean isOutOfStock = p.isOutOfStock();
                                boolean isLowStock = p.hasLowStock();
                    %>

                    <div class="col-md-3 md-col">
                        <div class="product-card <%=isOutOfStock ? "out-of-stock" : ""%>">
                            <div class="col-md">
                                <a href="single.jsp?productID=<%=p.getProductID()%>">
                                    <img src="<%=p.getProductImage()%>" alt="<%=p.getProductName()%>" />
                                </a>
                                <div class="top-content">
                                    <h5><a href="single.jsp?productID=<%=p.getProductID()%>"><%=p.getProductName()%></a></h5>
                                    
                                    <!-- Stock Information -->
                                    <div class="stock-info <%=stockClass%>">
                                        <%=p.getStockStatus()%>
                                        <%if(!isOutOfStock) {%>
                                            (<%=p.getQuantity()%> left)
                                        <%}%>
                                    </div>
                                    
                                    <div class="white">
                                        <%if(isOutOfStock) {%>
                                            <span class="add-to-cart-btn disabled">OUT OF STOCK</span>
                                        <%} else {%>
                                            <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2 add-to-cart-btn" 
                                               data-product-id="<%=p.getProductID()%>" 
                                               data-product-name="<%=p.getProductName()%>"
                                               data-available-stock="<%=p.getQuantity()%>">
                                               ADD TO CART
                                            </a>
                                        <%}%>
                                        
                                        <p class="dollar">
                                            <span class="in-dollar">$</span>
                                            <span><%=String.format("%.2f", p.getProductPrice())%></span>
                                        </p>
                                        
                                        <%if(isLowStock && !isOutOfStock) {%>
                                            <div class="quantity-display" style="color: #856404;">
                                                ⚠️ Only <%=p.getQuantity()%> left in stock!
                                            </div>
                                        <%}%>
                                        
                                        <div class="clearfix"></div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <%
                            }
                        }
                    %>

                    <div class="clearfix"></div>
                </div>
            </div>
            <!---->

            <%if(total > 8) {%>
                <ul class="start">
                    <%if(pages > 1) {%>
                        <li><a href="index.jsp?q=<%=productName%>&pages=<%=pages-1%>"><i></i></a></li>
                    <%}%>
                    
                    <%
                        int totalPages = (int) Math.ceil((double) total / 8);
                        int startPage = Math.max(1, pages - 2);
                        int endPage = Math.min(totalPages, pages + 2);
                        
                        for(int i = startPage; i <= endPage; i++){
                    %>
                        <li class="arrow <%=i == pages ? "active" : ""%>">
                            <a href="index.jsp?q=<%=productName%>&pages=<%=i%>"><%=i%></a>
                        </li>
                    <%}%>
                    
                    <%if(pages < totalPages) {%>
                        <li><a href="index.jsp?q=<%=productName%>&pages=<%=pages+1%>"><i class="next"> </i></a></li>
                    <%}%>
                </ul>
            <%}%>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

<script type="text/javascript">
$(document).ready(function() {
    // Add to cart functionality
    $('.add-to-cart-btn').click(function(e) {
        e.preventDefault();
        
        if ($(this).hasClass('disabled')) {
            return false;
        }
        
        var productId = $(this).data('product-id');
        var productName = $(this).data('product-name');
        var availableStock = $(this).data('available-stock');
        var button = $(this);
        
        // Show loading state
        var originalText = button.text();
        button.text('Adding...').prop('disabled', true);
        
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
                    
                    // Show success notification
                    showNotification('✅ "' + productName + '" added to cart!', 'success');
                    
                    // Update stock display if needed
                    if (response.availableStock !== undefined) {
                        var stockInfo = button.closest('.product-card').find('.stock-info');
                        var newStock = response.availableStock - response.newQuantity;
                        
                        if (newStock <= 0) {
                            stockInfo.removeClass('in-stock low-stock').addClass('out-of-stock');
                            stockInfo.text('Out of Stock');
                            button.removeClass('hvr-shutter-in-vertical hvr-shutter-in-vertical2')
                                  .addClass('disabled').text('OUT OF STOCK');
                        } else if (newStock <= 10) {
                            stockInfo.removeClass('in-stock').addClass('low-stock');
                            stockInfo.html('Low Stock (' + newStock + ' left)');
                        }
                    }
                    
                } else {
                    showNotification('❌ ' + (response.error || 'Error adding product to cart'), 'error');
                }
                
                // Reset button
                button.text(originalText).prop('disabled', false);
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
                showNotification('❌ Error adding product to cart. Please try again.', 'error');
                button.text(originalText).prop('disabled', false);
            }
        });
    });
    
    // Notification function
    function showNotification(message, type) {
        // Remove existing notifications
        $('.notification').remove();
        
        var notification = $('<div class="notification notification-' + type + '">' + message + '</div>');
        
        $('body').append(notification);
        
        // Show notification with animation
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
    
    // Auto-hide messages after 5 seconds
    setTimeout(function() {
        $('.success-message, .error-message').fadeOut();
    }, 5000);
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

.start li.active a {
    background-color: #007cba;
    color: white;
}
</style>
    </body>
</html>