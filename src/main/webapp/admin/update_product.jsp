<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page import="com.bookstore.model.Category"%>
<%@page import="com.bookstore.dao.CategoryDAO"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật sản phẩm</title>

        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />

    </head>
    <body>
        
        <%
            String error = "";
            if(request.getParameter("error")!=null){
                error = (String) request.getParameter("error");
            }
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            Product product = new Product();
            
            String productID = "";
            if (request.getParameter("product_id") != null) {
                productID = request.getParameter("product_id");
                product = productDAO.getProduct(Long.parseLong(productID));
            }
            
            ArrayList<Category> categoryList = categoryDAO.getListCategory();
        %>

        <jsp:include page="header.jsp"></jsp:include>

            <div id="wrapper">

            <jsp:include page="menu.jsp"></jsp:include>

                <div id="rightContent">
                    <h3>Cập nhật sản phẩm</h3>
                    <form action="/shop/ManagerProductServlet" method="post" enctype="multipart/form-data">
                    <table width="95%">
                        <tr>
                            <td style="float: right"><b>Tên sản phẩm:</b></td>
                            <td><input type="text" class="sedang" name="productName" value="<%=product.getProductName()%>"></td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Giá bán:</b></td>
                            <td><input type="text" class="sedang" name="productPrice" value="<%=product.getProductPrice()%>"></td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Loại sản phẩm:</b></td>
                            <td>
                                <select name="categoryID">
                                    <%
                                        for(Category c : categoryList) {
                                            if(c.getCategoryID() == product.getCategoryID()) {
                                                %>
                                                    <option value="<%=c.getCategoryID()%>" selected="true"><%=c.getCategoryName()%></option>
                                                <%
                                            } else {
                                                %>
                                                    <option value="<%=c.getCategoryID()%>"><%=c.getCategoryName()%></option>
                                                <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Mô tả sản phẩm:</b></td>
                            <td>
                                <textarea name="productDescription"><%=product.getProductDescription()%></textarea>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Hình ảnh:</b></td>
                            <td>
                                <img style="height: 80px;" src="../<%=product.getProductImage()%>" />
                                <br />
                                <input type="file" name="productImage" />
                            </td>
                        </tr>
                        
                        <tr>
                            <td></td>
                            <td>
                                <input type="hidden" name="command" value="update" />
                                <input type="hidden" name="productID" value="<%=product.getProductID()%>" />
                                <input type="submit" class="button" value="Lưu dữ liệu" />
                            </td>
                        </tr>
                    </table>
                    </form>
                </div>
                <div class="clear"></div>

            <jsp:include page="footer.jsp"></jsp:include>

        </div>


    </body>
</html>
