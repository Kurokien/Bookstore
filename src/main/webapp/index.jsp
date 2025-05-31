<%@page import="java.util.ArrayList"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>product</title>
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
            <!---->
            <div class="container">
                <div class="content">
                    <div class="content-top">
                        <h3 class="future">Recommendation</h3>
                        <div class="content-top-in">

                        <%
                            for (Product p : listProduct) {
                        %>

                        <div class="col-md-3 md-col">
                            <div class="col-md">
                                <a href="single.jsp?productID=<%=p.getProductID()%>"><img src="<%=p.getProductImage()%>" alt="<%=p.getProductName()%>" /></a>
                                <div class="top-content">
                                    <h5><a href="single.jsp?productID=<%=p.getProductID()%>"><%=p.getProductName()%></a></h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2 add-to-cart-btn" 
                                           data-product-id="<%=p.getProductID()%>" data-product-name="<%=p.getProductName()%>">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span><%=p.getProductPrice()%></span></p>
                                        <div class="clearfix"></div>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <%
                            }
                        %>


                        <div class="clearfix"></div>
                    </div>
                </div>
                <!---->


                <ul class="start">
                    <li><a href="index.jsp?q=<%=productName%>&pages=<%=pages-1%>"><i></i></a></li>
                    <%for(int i=1;i<=(total/8)+1;i++){%>
                        <li class="arrow"><a href="index.jsp?q=<%=productName%>&pages=<%=i%>"><%=i%></a></li>
                    <%}%>
                    <li><a href="index.jsp?q=<%=productName%>&pages=<%=pages+1%>"><i class="next"> </i></a></li>
                </ul>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript">
$(document).ready(function() {
    // Add to cart functionality
    $('.add-to-cart-btn').click(function(e) {
        e.preventDefault();
        
        var productId = $(this).data('product-id');
        var productName = $(this).data('product-name');
        var button = $(this);
        
        // Show loading state
        var originalText = button.text();
        button.text('Đang thêm...').prop('disabled', true);
        
        $.ajax({
            url: 'CartServlet',
            type: 'POST',
            data: {
                command: 'plus',
                productID: productId,
                ajax: 'true'
            },
            success: function(response) {
                if (response.includes('success')) {
                    var parts = response.split('|');
                    // Update cart count in header
                    $('.cart span').text(parts[1]);
                    
                    // Show success notification
                    showNotification('"' + productName + '" đã được thêm vào giỏ hàng!', 'success');
                } else {
                    showNotification('Có lỗi xảy ra khi thêm sản phẩm!', 'error');
                }
                
                // Reset button
                button.text(originalText).prop('disabled', false);
            },
            error: function() {
                showNotification('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!', 'error');
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
        
        // Hide notification after 3 seconds
        setTimeout(function() {
            notification.removeClass('show');
            setTimeout(function() {
                notification.remove();
            }, 300);
        }, 3000);
    }
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
