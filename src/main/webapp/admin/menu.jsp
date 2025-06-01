<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>menu</title>
        
        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        
        <style>
            .menu-icon {
                display: inline-block;
                width: 16px;
                text-align: center;
                margin-right: 8px;
            }
            
            .logout-confirm {
                color: #ff4757 !important;
            }
            
            .current-page {
                background-color: #e3f2fd !important;
                border-left: 4px solid #007cba;
                font-weight: bold;
            }
        </style>
        
        <script>
            function confirmLogout() {
                return confirm('Bạn có chắc muốn đăng xuất không?');
            }
            
            // Highlight current page
            $(document).ready(function() {
                var currentPath = window.location.pathname;
                var menuItems = $('#leftBar a');
                
                menuItems.each(function() {
                    var href = $(this).attr('href');
                    if (currentPath.includes(href.split('/').pop())) {
                        $(this).parent().addClass('current-page');
                    }
                });
            });
        </script>
    </head>
    <body>

        <div id="leftBar">
            <ul>
                <li>
                    <a href="${root}/admin/index.jsp">
                        <span class="menu-icon">🏠</span>Trang chủ
                    </a>
                </li>
                <li>
                    <a href="${root}/admin/manager_category.jsp">
                        <span class="menu-icon">📁</span>Danh mục
                    </a>
                </li>
                <li>
                    <a href="${root}/admin/stock_management.jsp">
                        <span class="menu-icon">📦</span>Quản lý kho & sản phẩm
                    </a>
                </li>
                <li>
                    <a href="${root}/admin/manager_bill.jsp">
                        <span class="menu-icon">🧾</span>Hóa đơn
                    </a>
                </li>

                <li style="margin-top: 20px; border-top: 1px solid #ddd; padding-top: 10px;">
                    <a href="${root}/LogoutServlet" class="logout-confirm" onclick="return confirmLogout()">
                        <span class="menu-icon">🚪</span>Đăng xuất
                    </a>
                </li>
            </ul>
        </div>

    </body>
</html>