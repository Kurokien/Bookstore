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
        <title>Thêm sản phẩm</title>

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
            
            .required {
                color: red;
            }
            
            .form-group {
                margin-bottom: 15px;
            }
            
            .quantity-preview {
                margin-top: 10px;
                padding: 10px;
                background: #e3f2fd;
                border-radius: 4px;
                font-weight: bold;
                display: none;
            }
        </style>
        
        <script>
            $(document).ready(function() {
                // Quantity validation and preview
                $('#quantity').on('input', function() {
                    var quantity = parseInt($(this).val());
                    var preview = $('#quantity-preview');
                    
                    if (!isNaN(quantity) && quantity >= 0) {
                        var status = '';
                        var statusClass = '';
                        
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
                        
                        preview.html('Trạng thái: <span style="' + statusClass + '">' + status + ' (' + quantity + ' sản phẩm)</span>').show();
                    } else {
                        preview.hide();
                    }
                });
                
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
            CategoryDAO categoryDAO = new CategoryDAO();
            ArrayList<Category> categoryList = categoryDAO.getListCategory();
        %>
        
        <jsp:include page="header.jsp"></jsp:include>

        <div id="wrapper">

            <jsp:include page="menu.jsp"></jsp:include>

            <div id="rightContent">
                <h3>📚 Thêm sản phẩm mới</h3>
                
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
                                <input type="text" class="sedang" name="productName" required 
                                       placeholder="Nhập tên sản phẩm...">
                            </td>
                        </tr>

                        <tr>
                            <td style="float: right"><b>Giá bán (USD): <span class="required">*</span></b></td>
                            <td>
                                <input type="number" class="sedang" name="productPrice" 
                                       step="0.01" min="0" max="9999.99" required
                                       placeholder="0.00">
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Loại sản phẩm: <span class="required">*</span></b></td>
                            <td>
                                <select name="categoryID" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <%for(Category c : categoryList) {%>
                                        <option value="<%=c.getCategoryID()%>"><%=c.getCategoryName()%></option>
                                    <%}%>
                                </select>
                            </td>
                        </tr>
                        
                        <!-- Stock Section -->
                        <tr>
                            <td colspan="2">
                                <div class="stock-section">
                                    <h4 style="margin: 0 0 10px 0; color: #333;">📦 Quản lý kho hàng</h4>
                                    <table width="100%">
                                        <tr>
                                            <td style="float: right; width: 30%;"><b>Số lượng ban đầu: <span class="required">*</span></b></td>
                                            <td>
                                                <input type="number" class="sedang" name="quantity" id="quantity"
                                                       min="0" max="999999" required value="100"
                                                       placeholder="Nhập số lượng...">
                                                <div class="stock-info">
                                                    Nhập số lượng sản phẩm có sẵn trong kho (0 - 999,999)
                                                </div>
                                                <div id="quantity-preview" class="quantity-preview"></div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="float: right"><b>Mô tả sản phẩm:</b></td>
                            <td>
                                <textarea name="productDescription" placeholder="Nhập mô tả chi tiết về sản phẩm..."></textarea>
                            </td>
                        </tr>

                        <tr>
                            <td style="float: right"><b>Hình ảnh:</b></td>
                            <td>
                                <input type="file" name="productImage" accept="image/*" />
                                <div class="stock-info">
                                    Chọn file hình ảnh (JPG, PNG, GIF). Kích thước tối đa: 5MB
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td></td>
                            <td>
                                <input type="hidden" name="command" value="insert" />
                                <input type="submit" class="button" value="💾 Lưu sản phẩm" />
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

    </body>
</html>