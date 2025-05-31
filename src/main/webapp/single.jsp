<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>detail</title>
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
    </head>
    <body>

        <%
            ProductDAO productDAO = new ProductDAO();
            Product product = new Product();
            String productID = "";
            if (request.getParameter("productID") != null) {
                productID = request.getParameter("productID");
                product = productDAO.getProduct(Long.parseLong(productID));
            }
        %>

        <jsp:include page="header.jsp"></jsp:include>

            <div class="container">
                <div class="single">
                    <div class="col-md-9 top-in-single">
                        <div class="col-md-5 single-top">	

                            <a href="optionallink.html">
                                <img class="etalage_thumb_image img-responsive" src="<%=product.getProductImage()%>" alt="" >
                            </a>

                        </div>	
                    <div class="col-md-7 single-top-in">
                        <div class="single-para">
                            <h4><%=product.getProductName()%></h4>
                            <div class="para-grid">
                                <span class="add-to">$<%=product.getProductPrice()%></span>
                               <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2 add-to-cart-btn" 
                                  data-product-id="<%=productID%>" data-product-name="<%=product.getProductName()%>">ADD TO CART</a>
                                <div class="clearfix"></div>
                            </div>
                            <h5>100 items in stock</h5>
                            <div class="available">
                                
                            </div>
                            <p><%=product.getProductDescription()%></p>

                            <a href="#" class="hvr-shutter-in-vertical ">More details</a>

                        </div>
                    </div>
                    <div class="clearfix"> </div>
                    <div class="content-top-in">
                        <div class="col-md-4 top-single">
                            <div class="col-md">
                                <img src="images/pic8.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Mascot Kitty - White</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>2</span><span>0</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>
                        <div class="col-md-4 top-single">
                            <div class="col-md">
                                <img src="images/pic9.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Mascot Kitty - White</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>2</span><span>0</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>
                        <div class="col-md-4 top-single-in">
                            <div class="col-md">
                                <img src="images/pic10.jpg" alt="" />
                                <div class="top-content">
                                    <h5>Mascot Kitty - White</h5>
                                    <div class="white">
                                        <a href="#" class="hvr-shutter-in-vertical hvr-shutter-in-vertical2">ADD TO CART</a>
                                        <p class="dollar"><span class="in-dollar">$</span><span>2</span><span>0</span></p>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>							
                            </div>
                        </div>

                        <div class="clearfix"></div>
                    </div>
                    
                    <div>   
                            
                    </div>
                    
                </div>
                <div class="clearfix"> </div>
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
                                showNotification('"' + productName + '" đã được thêm vào giỏ hàng!', 'success');

                                // Reset button
                                button.text(originalText).prop('disabled', false);
                            } else {
                                showNotification(response.error || 'Có lỗi xảy ra!', 'error');
                                button.text(originalText).prop('disabled', false);
                            }
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

                    // Show notification
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
