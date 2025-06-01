<%@page import="com.bookstore.model.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager Product</title>

        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        
        <style>
            .stock-badge {
                padding: 3px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
                text-transform: uppercase;
            }
            
            .in-stock {
                background-color: #d4edda;
                color: #155724;
            }
            
            .low-stock {
                background-color: #fff3cd;
                color: #856404;
            }
            
            .out-of-stock {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .stock-actions {
                display: flex;
                gap: 5px;
                align-items: center;
                margin-top: 5px;
            }
            
            .stock-input {
                width: 50px;
                padding: 2px 4px;
                border: 1px solid #ddd;
                border-radius: 3px;
                text-align: center;
                font-size: 11px;
            }
            
            .btn-stock {
                padding: 2px 6px;
                border: none;
                border-radius: 3px;
                font-size: 10px;
                cursor: pointer;
                color: white;
                font-weight: bold;
            }
            
            .btn-add { background: #28a745; }
            .btn-remove { background: #dc3545; }
            .btn-add:hover { background: #218838; }
            .btn-remove:hover { background: #c82333; }
            
            .product-info {
                text-align: center;
            }
            
            .actions-cell {
                font-size: 11px;
            }
        </style>
    </head>
    <body>
        <%
            ProductDAO productDAO = new ProductDAO();
            ArrayList<Product> listProduct = productDAO.getAllProduct();
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div id="wrapper">

            <jsp:include page="menu.jsp"></jsp:include>

            <div id="rightContent">
                <h3>Quản lý sản phẩm</h3>
                
                <div style="margin-bottom: 15px;">
                    <a href="${root}/admin/insert_product.jsp" style="margin-right: 15px;">Thêm sản phẩm</a>
                    <a href="${root}/admin/stock_management.jsp">Quản lý kho hàng</a>
                </div>

                <table class="data">

                    <tr class="data">
                        <th class="data" width="30px">STT</th>
                        <th class="data">Mã SP</th>
                        <th class="data">Hình ảnh</th>
                        <th class="data">Tên sản phẩm</th>
                        <th class="data">Giá</th>
                        <th class="data">Tồn kho</th>
                        <th class="data">Trạng thái</th>
                        <th class="data" width="150px">Tùy chọn</th>
                    </tr>

                    <%
                        int count = 0;
                        for(Product product : listProduct){
                            count++;
                            String stockClass = product.getStockStatusClass();
                            boolean isOutOfStock = product.isOutOfStock();
                    %>
                    <tr class="data">
                        <td class="data" width="30px"><%=count%></td>
                        <td class="data"><%=product.getProductID()%></td>
                        <td class="data product-info">
                            <img style="height: 50px; border-radius: 4px;" src="../<%=product.getProductImage()%>" />
                        </td>
                        <td class="data">
                            <strong><%=product.getProductName()%></strong>
                            <br><small style="color: #666;">ID: <%=product.getProductID()%></small>
                        </td>
                        <td class="data">
                            <strong>$<%=String.format("%.2f", product.getProductPrice())%></strong>
                        </td>
                        <td class="data product-info">
                            <strong style="font-size: 16px; color: <%=isOutOfStock ? "#dc3545" : (product.hasLowStock() ? "#ffc107" : "#28a745")%>">
                                <%=product.getQuantity()%>
                            </strong>
                            
                            <!-- Quick Stock Actions -->
                            <div class="stock-actions">
                                <form method="POST" action="${root}/admin/StockServlet" style="display: inline;">
                                    <input type="hidden" name="productId" value="<%=product.getProductID()%>">
                                    <input type="hidden" name="action" value="add">
                                    <input type="number" name="quantity" class="stock-input" 
                                           placeholder="+" min="1" max="100" value="10">
                                    <button type="submit" class="btn-stock btn-add">+</button>
                                </form>
                                
                                <%if(product.getQuantity() > 0) {%>
                                    <form method="POST" action="${root}/admin/StockServlet" style="display: inline;">
                                        <input type="hidden" name="productId" value="<%=product.getProductID()%>">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="number" name="quantity" class="stock-input" 
                                               placeholder="-" min="1" max="<%=product.getQuantity()%>" value="1">
                                        <button type="submit" class="btn-stock btn-remove">-</button>
                                    </form>
                                <%}%>
                            </div>
                        </td>
                        <td class="data product-info">
                            <span class="stock-badge <%=stockClass%>">
                                <%=product.getStockStatus()%>
                            </span>
                        </td>
                        <td class="data actions-cell" width="150px">
                            <center>
                                <a href="${root}/admin/update_product.jsp?command=update&product_id=<%=product.getProductID()%>">Sửa</a>&nbsp;|&nbsp;
                                <a href="${root}/ManagerProductServlet?product_id=<%=product.getProductID()%>" 
                                   onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">Xóa</a>
                                <br>
                                <a href="../single.jsp?productID=<%=product.getProductID()%>" target="_blank" style="color: #007cba;">Xem</a>
                            </center>
                        </td>
                    </tr>
                    <%}%>

                </table>
                
                <!-- Summary -->
                <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 5px;">
                    <%
                        int totalProducts = listProduct.size();
                        int inStock = 0;
                        int lowStock = 0;
                        int outOfStock = 0;
                        
                        for(Product p : listProduct) {
                            if(p.isOutOfStock()) outOfStock++;
                            else if(p.hasLowStock()) lowStock++;
                            else inStock++;
                        }
                    %>
                    <strong>Tổng quan kho hàng:</strong>
                    <span style="color: #28a745;">Còn hàng: <%=inStock%></span> | 
                    <span style="color: #ffc107;">Sắp hết: <%=lowStock%></span> | 
                    <span style="color: #dc3545;">Hết hàng: <%=outOfStock%></span> | 
                    <span>Tổng: <%=totalProducts%> sản phẩm</span>
                </div>
            </div>
            <div class="clear"></div>

            <jsp:include page="footer.jsp"></jsp:include>

        </div>

    </body>
</html>