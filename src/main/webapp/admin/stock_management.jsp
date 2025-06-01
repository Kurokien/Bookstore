<%@page import="java.util.ArrayList"%>
<%@page import="com.bookstore.model.Product"%>
<%@page import="com.bookstore.dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý sản phẩm</title>

    <c:set var="root" value="${pageContext.request.contextPath}"/>
    <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
    <script src="${root}/js/jquery.min.js"></script>
    
    <style>
        .stock-summary {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .summary-card {
            background: white;
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            text-align: center;
            flex: 1;
            min-width: 150px;
        }
        
        .summary-card h3 {
            margin: 0 0 5px 0;
            font-size: 24px;
            color: #333;
        }
        
        .summary-card.warning { border-left: 4px solid #ffc107; }
        .summary-card.danger { border-left: 4px solid #dc3545; }
        .summary-card.success { border-left: 4px solid #28a745; }
        
        .filter-section {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        
        .stock-badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .in-stock { background-color: #d4edda; color: #155724; }
        .low-stock { background-color: #fff3cd; color: #856404; animation: pulse 2s infinite; }
        .out-of-stock { background-color: #f8d7da; color: #721c24; }
        
        .alert {
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .actions-cell {
            font-size: 11px;
        }
        
        .actions-cell a {
            color: #007cba;
            text-decoration: none;
            margin: 0 2px;
        }
        
        .actions-cell a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <%
        // Bỏ phần check authentication vì AdminAuthFilter đã xử lý
        
        ProductDAO productDAO = new ProductDAO();
        
        // Get filter parameters
        String filterStatus = request.getParameter("status");
        String searchName = request.getParameter("search");
        if (filterStatus == null) filterStatus = "all";
        if (searchName == null) searchName = "";
        
        // Get products based on filter
        ArrayList<Product> allProducts = productDAO.getAllProduct();
        ArrayList<Product> filteredProducts = new ArrayList<>();
        
        // Apply filters
        for (Product p : allProducts) {
            boolean matchesSearch = searchName.isEmpty() || 
                                  p.getProductName().toLowerCase().contains(searchName.toLowerCase());
            boolean matchesStatus = false;
            
            switch (filterStatus) {
                case "all":
                    matchesStatus = true;
                    break;
                case "in-stock":
                    matchesStatus = p.isInStock() && !p.hasLowStock();
                    break;
                case "low-stock":
                    matchesStatus = p.hasLowStock();
                    break;
                case "out-of-stock":
                    matchesStatus = p.isOutOfStock();
                    break;
            }
            
            if (matchesSearch && matchesStatus) {
                filteredProducts.add(p);
            }
        }
        
        // Calculate summary statistics
        int totalProducts = allProducts.size();
        int inStockCount = 0;
        int lowStockCount = 0;
        int outOfStockCount = 0;
        
        for (Product p : allProducts) {
            if (p.isOutOfStock()) {
                outOfStockCount++;
            } else if (p.hasLowStock()) {
                lowStockCount++;
            } else {
                inStockCount++;
            }
        }
    %>

    <jsp:include page="header.jsp"></jsp:include>

    <div id="wrapper">

        <jsp:include page="menu.jsp"></jsp:include>

        <div id="rightContent">
            <h3>📦 Quản lý sản phẩm & kho hàng</h3>
            
            <!-- Display messages -->
            <c:if test="${param.success != null}">
                <div class="alert alert-success">
                    ✅ ${param.success}
                </div>
            </c:if>
            
            <c:if test="${param.error != null}">
                <div class="alert alert-danger">
                    ❌ ${param.error}
                </div>
            </c:if>
            
            <!-- Add Product Button -->
            <div style="margin-bottom: 15px;">
                <a href="${root}/admin/insert_product.jsp" class="button">➕ Thêm sản phẩm mới</a>
            </div>
            
            <!-- Summary Cards -->
            <div class="stock-summary">
                <div class="summary-card success">
                    <h3><%=totalProducts%></h3>
                    <p>Tổng sản phẩm</p>
                </div>
                <div class="summary-card success">
                    <h3><%=inStockCount%></h3>
                    <p>Còn hàng</p>
                </div>
                <div class="summary-card warning">
                    <h3><%=lowStockCount%></h3>
                    <p>Sắp hết</p>
                </div>
                <div class="summary-card danger">
                    <h3><%=outOfStockCount%></h3>
                    <p>Hết hàng</p>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-section">
                <form method="GET" action="">
                    <table width="100%">
                        <tr>
                            <td width="20%">
                                <strong>Lọc theo trạng thái:</strong>
                                <select name="status" onchange="this.form.submit()">
                                    <option value="all" <%="all".equals(filterStatus) ? "selected" : ""%>>Tất cả</option>
                                    <option value="in-stock" <%="in-stock".equals(filterStatus) ? "selected" : ""%>>Còn hàng</option>
                                    <option value="low-stock" <%="low-stock".equals(filterStatus) ? "selected" : ""%>>Sắp hết</option>
                                    <option value="out-of-stock" <%="out-of-stock".equals(filterStatus) ? "selected" : ""%>>Hết hàng</option>
                                </select>
                            </td>
                            <td width="30%">
                                <strong>Tìm kiếm:</strong>
                                <input type="text" name="search" value="<%=searchName%>" placeholder="Tên sản phẩm...">
                            </td>
                            <td>
                                <input type="submit" class="button" value="🔍 Tìm">
                                <input type="button" class="button" value="🔄 Reset" onclick="window.location.href='?'" style="background: #6c757d;">
                            </td>
                        </tr>
                    </table>
                </form>
            </div>

            <!-- Stock Table -->
            <table class="data">
                <tr class="data">
                    <th class="data" width="40px">STT</th>
                    <th class="data">Sản phẩm</th>
                    <th class="data" width="80px">Giá</th>
                    <th class="data" width="80px">Tồn kho</th>
                    <th class="data" width="100px">Trạng thái</th>
                    <th class="data" width="120px">Tùy chọn</th>
                </tr>

                <%if(filteredProducts.isEmpty()) {%>
                    <tr class="data">
                        <td colspan="6" class="data" style="text-align: center; padding: 30px; color: #666;">
                            Không tìm thấy sản phẩm phù hợp với điều kiện lọc.
                        </td>
                    </tr>
                <%} else {%>
                    <%
                        int count = 0;
                        for(Product product : filteredProducts) {
                            count++;
                            String stockClass = product.getStockStatusClass();
                            boolean isOutOfStock = product.isOutOfStock();
                    %>
                    <tr class="data">
                        <td class="data" width="40px"><%=count%></td>
                        <td class="data">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <img src="../<%=product.getProductImage()%>" 
                                     alt="<%=product.getProductName()%>" 
                                     style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                <div>
                                    <strong><%=product.getProductName()%></strong>
                                    <br><small style="color: #666;">ID: <%=product.getProductID()%></small>
                                </div>
                            </div>
                        </td>
                        <td class="data" width="80px">
                            <strong><%=String.format("%.2f", product.getProductPrice())%> VND</strong>
                        </td>
                        <td class="data" width="80px" style="text-align: center;">
                            <strong style="font-size: 16px; color: <%=isOutOfStock ? "#dc3545" : (product.hasLowStock() ? "#ffc107" : "#28a745")%>">
                                <%=product.getQuantity()%>
                            </strong>
                        </td>
                        <td class="data" width="100px" style="text-align: center;">
                            <span class="stock-badge <%=stockClass%>">
                                <%=product.getStockStatus()%>
                            </span>
                        </td>
                        <td class="data actions-cell" width="120px">
                            <center>
                                <a href="${root}/admin/update_product.jsp?command=update&product_id=<%=product.getProductID()%>">✏️ Sửa</a>
                                <br>
                                <a href="${root}/ManagerProductServlet?product_id=<%=product.getProductID()%>" 
                                   onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')" 
                                   style="color: #dc3545;">🗑️ Xóa</a>
                            </center>
                        </td>
                    </tr>
                    <%}%>
                <%}%>
            </table>
            
            <!-- Summary Info -->
            <div style="margin-top: 15px; padding: 10px; background: #f8f9fa; border-radius: 5px; text-align: center;">
                <strong>Hiển thị <%=filteredProducts.size()%> / <%=totalProducts%> sản phẩm</strong>
                <%if(!filterStatus.equals("all") || !searchName.isEmpty()) {%>
                    | <a href="?" style="color: #007cba;">Xem tất cả</a>
                <%}%>
            </div>
        </div>
        <div class="clear"></div>

        <jsp:include page="footer.jsp"></jsp:include>

    </div>

    <script>
        // Auto-hide alerts after 3 seconds
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 3000);
    </script>
</body>
</html>