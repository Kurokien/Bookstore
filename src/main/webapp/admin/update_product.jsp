<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page import="com.bookstore.model.Category"%>
<%@page import="com.bookstore.dao.CategoryDAO"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật sản phẩm</title>

        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        <script src="${root}/js/jquery.min.js"></script>
        
        <style>
            .stock-section {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                border-left: 4px solid #007cba;
                margin: 15px 0;
            }
            
            .stock-info {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }
            
            .stock-warning {
                padding: 8px;
                border-radius: 4px;
                margin-top: 8px;
                font-size: 12px;
                font-weight: bold;
            }
            
            .stock-warning.low {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }
            
            .stock-warning.out {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .required {
                color: red;
            }
            
            .current-stock {
                padding: 10px;
                background: #e3f2fd;
                border-radius: 4px;
                margin-bottom: 10px;
            }
            
            .stock-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
                text-transform: uppercase;
            }
            
            .in-stock { background-color: #d4edda; color: #155724; }
            .low-stock { background-color: #fff3cd; color: #856404; }
            .out-of-stock { background-color: #f8d7da; color: #721c24; }
        </style>
        
        <script>
            $(document).ready(function() {
                var originalQuantity = <%=request.getParameter("product_id") != null ? "currentProduct.getQuantity()" : "0"%>;
                
                // Quantity validation and preview
                $('#quantity').on('input', function() {
                    var quantity = parseInt($(this).val());
                    var preview = $('#quantity-preview');
                    
                    if (!isNaN(quantity) && quantity >= 0) {
                        var status = '';
                        var statusClass = '';
                        var changeText = '';
                        
                        if (quantity === 0) {
                            status = 'Hết hàng';
                            statusClass = 'color: #dc3545;';
                        } else if (quantity <= 10) {
                            status = 'Sắp hết hàng';
                            statusClass = 'color: #ffc107;';
                        } else {
                            status = 'Còn hàng';
                            statusClass = 'color: #28a745;';
                        }
                        
                        var diff = quantity - originalQuantity;
                        if (diff > 0) {
                            changeText = ' (+' + diff + ')';
                        } else if (diff < 0) {
                            changeText = ' (' + diff + ')';
                        }
                        
                        preview.html('Trạng thái mới: <span style="' + statusClass + '">' + status + ' (' + quantity + ' sản phẩm' + changeText + ')</span>').show();
                    } else {
                        preview.hide();
                    }
                });
                
                // Initialize preview
                $('#quantity').trigger('input');
                
                // Form validation
                $('#productForm').submit(function(e) {
                    var productName = $('input[name="productName"]').val().trim();
                    var productPrice = parseFloat($('input[name="productPrice"]').val());
                    var quantity = parseInt($('input[name="quantity"]').val());
                    
                    if (productName.length < 2) {
                        alert('Tên sản phẩm phải có ít nhất 2 ký tự!');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (isNaN(productPrice) || productPrice < 0) {
                        alert('Vui lòng nhập giá hợp lệ!');
                        e.preventDefault();
                        return false;
                    }
                    
                    if (isNaN(quantity) || quantity < 0) {
                        alert('Vui lòng nhập số lượng hợp lệ!');
                        e.preventDefault();
                        return false;
                    }
                    
                    return true;
                });
            });
        </script>
    </head>
    <body>
        
        <%
            String error = "";
            if(request.getParameter("error")!=null){
                error = (String) request.getParameter("error");
            }
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            Product currentProduct = new Product();
            
            String productID = "";
            if (request.getParameter("product_id") != null) {
                productID = request.getParameter("product_id");
                currentProduct = productDAO.getProduct(Long.parseLong(productID));
            }
            
            ArrayList<Category> categoryList = categoryDAO.getListCategory();
        %>

        <jsp:include page="header.jsp"></jsp:include>

        <div id="wrapper">

            <jsp:include page="menu.jsp"></jsp:include>

            <div id="rightContent">
                <h3>✏️ Cập nhật sản phẩm</h3>
                
                <!-- Display messages -->
                <c:if test="${param.success != null}">
                    <div style="padding: 10px; background: #d4edda; color: #155724; border-radius: 4px; margin-bottom: 15px;">
                        ✅ ${param.success}
                    </div>
                </c:if>
                
                <c:if test="${param.error != null}">
                    <div style="padding: 10px; background: #f8d7da; color: #721c24; border-radius: 4px; margin-bottom: 15px;">
                        ❌ ${param.error}
                    </div>
                </c:if>
                
                <form action="${root}/ManagerProductServlet" method="post" enctype="multipart/form-data" id="productForm">
                    <table width="95%">
                        <tr>
                            <td style="float: right"><b>Tên sản phẩm: <span class="required">*</span></b></td>
                            <td>
                                <input type="text" class="sedang" name="productName" 
                                       value="<%=currentProduct.getProductName()%>" required>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Giá bán (USD): <span class="required">*</span></b></td>
                            <td>
                                <input type="number" class="sedang" name="productPrice" 
                                       value="<%=String.format("%.2f", currentProduct.getProductPrice())%>"
                                       step="0.01" min="0" max="9999.99" required>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Loại sản phẩm: <span class="required">*</span></b></td>
                            <td>
                                <select name="categoryID" required>
                                    <%for(Category c : categoryList) {
                                        if(c.getCategoryID() == currentProduct.getCategoryID()) {%>
                                            <option value="<%=c.getCategoryID()%>" selected="true"><%=c.getCategoryName()%></option>
                                        <%} else {%>
                                            <option value="<%=c.getCategoryID()%>"><%=c.getCategoryName()%></option>
                                        <%}
                                    }%>
                                </select>
                            </td>
                        </tr>
                        
                        <!-- Stock Management Section -->
                        <tr>
                            <td colspan="2">
                                <div class="stock-section">
                                    <h4 style="margin: 0 0 15px 0; color: #333;">📦 Quản lý kho hàng</h4>
                                    
                                    <!-- Current Stock Status -->
                                    <div class="current-stock">
                                        <strong>Trạng thái hiện tại:</strong>
                                        <span class="stock-badge <%=currentProduct.getStockStatusClass()%>">
                                            <%=currentProduct.getStockStatus()%>
                                        </span>
                                        <span style="margin-left: 10px;">(<%=currentProduct.getQuantity()%> sản phẩm)</span>
                                        
                                        <%if(currentProduct.hasLowStock() && !currentProduct.isOutOfStock()) {%>
                                            <div class="stock-warning low">
                                                ⚠️ Cảnh báo: Sắp hết hàng!
                                            </div>
                                        <%} else if(currentProduct.isOutOfStock()) {%>
                                            <div class="stock-warning out">
                                                🚫 Sản phẩm đã hết hàng!
                                            </div>
                                        <%}%>
                                    </div>
                                    
                                    <table width="100%">
                                        <tr>
                                            <td style="float: right; width: 30%;"><b>Số lượng mới: <span class="required">*</span></b></td>
                                            <td>
                                                <input type="number" class="sedang" name="quantity" id="quantity"
                                                       min="0" max="999999" required 
                                                       value="<%=currentProduct.getQuantity()%>">
                                                <div class="stock-info">
                                                    Cập nhật số lượng sản phẩm trong kho (0 - 999,999)
                                                </div>
                                                <div id="quantity-preview" class="current-stock" style="display: none; margin-top: 10px;"></div>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <!-- Quick Stock Actions -->
                                    <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #dee2e6;">
                                        <strong>Thao tác nhanh:</strong>
                                        <div style="margin-top: 8px;">
                                            <button type="button" onclick="adjustStock(10)" style="margin-right: 5px; padding: 4px 8px; font-size: 12px;">+10</button>
                                            <button type="button" onclick="adjustStock(50)" style="margin-right: 5px; padding: 4px 8px; font-size: 12px;">+50</button>
                                            <button type="button" onclick="adjustStock(100)" style="margin-right: 15px; padding: 4px 8px; font-size: 12px;">+100</button>
                                            
                                            <button type="button" onclick="adjustStock(-1)" style="margin-right: 5px; padding: 4px 8px; font-size: 12px;">-1</button>
                                            <button type="button" onclick="adjustStock(-10)" style="margin-right: 5px; padding: 4px 8px; font-size: 12px;">-10</button>
                                            <button type="button" onclick="setStock(0)" style="padding: 4px 8px; font-size: 12px; background: #dc3545; color: white;">Đặt về 0</button>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Mô tả sản phẩm:</b></td>
                            <td>
                                <textarea name="productDescription"><%=currentProduct.getProductDescription()%></textarea>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Hình ảnh hiện tại:</b></td>
                            <td>
                                <img style="height: 80px; border-radius: 4px; border: 1px solid #ddd;" 
                                     src="../<%=currentProduct.getProductImage()%>" />
                                <br />
                                <strong>Thay đổi hình ảnh:</strong><br>
                                <input type="file" name="productImage" accept="image/*" />
                                <div class="stock-info">
                                    Chọn file mới nếu muốn thay đổi hình ảnh (JPG, PNG, GIF)
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <td></td>
                            <td>
                                <input type="hidden" name="command" value="update" />
                                <input type="hidden" name="productID" value="<%=currentProduct.getProductID()%>" />
                                <input type="submit" class="button" value="💾 Cập nhật sản phẩm" />
                                <input type="button" class="button" value="❌ Hủy" 
                                       onclick="window.location.href='${root}/admin/manager_product.jsp'" 
                                       style="background: #6c757d; margin-left: 10px;" />
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="clear"></div>

            <jsp:include page="footer.jsp"></jsp:include>

        </div>
        
        <script>
            function adjustStock(amount) {
                var quantityInput = document.getElementById('quantity');
                var currentValue = parseInt(quantityInput.value) || 0;
                var newValue = Math.max(0, Math.min(999999, currentValue + amount));
                quantityInput.value = newValue;
                $('#quantity').trigger('input');
            }
            
            function setStock(value) {
                document.getElementById('quantity').value = value;
                $('#quantity').trigger('input');
            }
        </script>

    </body>
</html>