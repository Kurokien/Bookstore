
<%@page import="java.util.ArrayList"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.model.Category"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page import="com.bookstore.dao.CategoryDAO"%>
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
            CategoryDAO categoryDAO = new CategoryDAO();
            long categoryID = 0;
            if (request.getParameter("categoryID") != null) {
                categoryID = (long) Long.parseLong(request.getParameter("categoryID"));
            }
            Category c = categoryDAO.getCategory(categoryID);
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

            total = productDAO.countProductByCategory(categoryID);
            if (total <= 8) {
                firstResult = 0;
                maxResult = total;
            }else{
                firstResult = (pages - 1) * 8;
                maxResult = 8;
            }

            ArrayList<Product> listProduct = productDAO.getListProductByNav(
                    categoryID, firstResult, maxResult);
        %>

        <jsp:include page="header.jsp"></jsp:include>

            <br /><br />
            <!---->
            <div class="container">
                <div class="content">
                    <div class="content-top">
                        <h3 class="future"><%=c.getCategoryName()%></h3>
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
                                        <p class="dollar"><span class="in-dollar">VND</span><span><%=p.getProductPrice()%></span></p>
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
                    <li><a href="index.jsp?pages=<%=pages-1%>"><i></i></a></li>
                    <%for(int i=1;i<=(total/8)+1;i++){%>
                        <li class="arrow"><a href="product.jsp?categoryID=<%=categoryID%>&pages=<%=i%>"><%=i%></a></li>
                    <%}%>
                    <li><a href="index.jsp?pages=<%=pages+1%>"><i class="next"> </i></a></li>
                </ul>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

    </body>
</html>
