<%@page import="com.bookstore.model.Item"%>
<%@page import="java.util.Map"%>
<%@page import="com.bookstore.model.Cart"%>
<%@page import="com.bookstore.model.Users"%>
<%@page import="com.bookstore.model.Category"%>
<%@page import="com.bookstore.dao.CategoryDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>header</title>

    <div id="fb-root"></div>
    <script>(function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id))
                return;
            js = d.createElement(s);
            js.id = id;
            js.src = "//connect.facebook.net/vi_VN/sdk.js#xfbml=1&version=v2.6&appId=381324158709242";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>

</head>
<body>

    <%
        CategoryDAO categoryDAO = new CategoryDAO();
        Users users = null;
        if (session.getAttribute("user") != null) {
            users = (Users) session.getAttribute("user");
        }
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        
        String q = "";
        if(request.getParameter("q") != null) {
            request.getParameter("q");
        }

    %>

    <!--header-->
    <div class="header">
        <div class="header-top">
            <div class="container">	
                <div class="header-top-in" style="padding: .5em 1em">
                    <div class="logo">
                        <a href="index.jsp"><img src="images/logo.png" alt=" " style="height:80px"></a>
                    </div>
                    <div class="header-in" style="margin-top: 20px;">
                        <ul class="icon1 sub-icon1">
                            <%if (users != null) {%>
                            <li><a><%=users.getUserEmail()%></a> </li>
                            <li><a href="<%= request.getContextPath() %>/UsersServlet?command=logout">LOGOUT</a> </li>
                                <%}%>
                            <%if (users == null) {%>
                                <li><a href="<%= request.getContextPath() %>/login.jsp">LOGIN</a> </li>

                                <li><a href="<%= request.getContextPath() %>/register.jsp">REGISTER</a> </li>
                            <%}%>
                            <li><a href="<%= request.getContextPath() %>/checkout.jsp">CHECKOUT</a> </li
                            <li><div class="cart">
                                    <a href="#" class="cart-in"> </a>
                                    <span> <%=cart.countItem()%></span>
                                </div>
                                <ul class="sub-icon1 list">
                                    <h3>Recently added items</h3>
                                    <div class="shopping_cart">

                                        <%for (Map.Entry<Long, Item> list : cart.getCartItems().entrySet()) {%>
                                        <div class="cart_box">
                                            <div class="message">
                                                <div class="alert-close"> </div> 
                                                <div class="list_img"><img src="<%=list.getValue().getProduct().getProductImage()%>" class="img-responsive" alt=""></div>
                                                <div class="list_desc"><h4><a href="CartServlet?command=remove&productID=<%=list.getValue().getProduct().getProductID()%>"><%=list.getValue().getProduct().getProductName()%></a></h4>
                                                    <%=list.getValue().getQuantity()%> x<span class="actual"> $<%=list.getValue().getProduct().getProductPrice()%></span>
                                                </div>
                                                <div class="clearfix"></div>
                                            </div>
                                        </div>
                                        <%}%>

                                    </div>
                                    <div class="total">
                                        <div class="total_left">Cart Subtotal: </div>
                                        <div class="total_right">$<%=cart.totalCart()%></div>
                                        <div class="clearfix"> </div>
                                    </div>
                                    <div class="login_buttons">
                                        <div class="check_button"><a href="checkout.jsp">Check out</a></div>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="clearfix"></div>
                                </ul>
                            </li>
                            
                        </ul>
                    </div>
                    <div class="clearfix"> </div>
                </div>
            </div>
        </div>

        <div class="header-bottom">
            <div class="container">
                <div class="h_menu4">
                    <a class="toggleMenu" href="#">Menu</a>
                    <ul class="nav">
                        <li class="active"><a href="index.jsp"><i> </i>Home</a></li>
                        <%
                            for (Category c : categoryDAO.getListCategory()) {
                        %>
                        <li><a href="product.jsp?categoryID=<%=c.getCategoryID()%>&pages=1"><%=c.getCategoryName()%></a></li>
                            <%
                                }
                            %>
                        </li> 						
                        <li><a href="aboutus.jsp" >About us</a></li>            
                        <li><a href="404.jsp" >Blog</a></li>						  				 
                        <li><a href="contact.jsp" >Contact</a></li>

                    </ul>
                    <script type="text/javascript" src="js/nav.js"></script>
                </div>
            </div>
        </div>
        <div class="header-bottom-in">
            <div class="container">
                <div class="header-bottom-on">
                    <div class="header-can">
                        <div class="search">
                            <form action="<%= request.getContextPath() %>/shop/index.jsp" method="GET">
                                <input type="text" name="q" value="<%=q%>"/>
                                <input type="submit" value="">
                            </form>
                        </div>

                        <div class="clearfix"> </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
