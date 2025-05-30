<%@page import="com.bookstore.model.Category"%>
<%@page import="com.bookstore.dao.CategoryDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sản phẩm</title>

        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        <script src="<c:url value="/ckeditor/ckeditor.js" />"></script>

    </head>
    <body>
        <%
            CategoryDAO categoryDAO = new CategoryDAO();
            
            ArrayList<Category> categoryList = categoryDAO.getListCategory();
        %>
        <jsp:include page="header.jsp"></jsp:include>

            <div id="wrapper">

            <jsp:include page="menu.jsp"></jsp:include>

                <div id="rightContent">
                    <h3>Thông tin sản phẩm</h3>
                    <form action="/shop/ManagerProductServlet" method="post" enctype="multipart/form-data">
                        <table width="95%">
                            <tr>
                                <td style="float: right"><b>Tên sản phẩm:</b></td>
                                <td><input type="text" class="sedang" name="productName"></td>
                            </tr>

                            <tr>
                                <td style="float: right"><b>Giá bán:</b></td>
                                <td><input type="text" class="sedang" name="productPrice"></td>
                            </tr>
                            <tr>
                                <td style="float: right"><b>Loại sản phẩm:</b></td>
                                <td>
                                    <select name="categoryID">
                                        <%
                                            for(Category c : categoryList) {
                                                %>
                                                    <option value="<%=c.getCategoryID()%>"><%=c.getCategoryName()%></option>
                                                <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="float: right"><b>Mô tả sản phẩm:</b></td>
                                <td>
                                    <textarea name="productDescription"></textarea>
                                </td>
                            </tr>

                            <tr>
                                <td style="float: right"><b>Hình ảnh:</b></td>
                                <td>
                                    <input type="file" name="productImage" />
                                </td>
                            </tr>

                            <tr>
                                <td></td>
                                <td>
                                    <input type="hidden" name="command" value="insert" />
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
