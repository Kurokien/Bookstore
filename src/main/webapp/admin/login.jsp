<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Login - BookStore</title>
        
        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            
            .login-container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                width: 400px;
                text-align: center;
            }
            
            .login-header {
                margin-bottom: 30px;
            }
            
            .login-header h2 {
                color: #333;
                margin-bottom: 10px;
            }
            
            .login-header img {
                width: 80px;
                height: 80px;
                margin-bottom: 15px;
            }
            
            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 5px;
                color: #555;
                font-weight: bold;
            }
            
            .form-group input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e1e1e1;
                border-radius: 5px;
                font-size: 16px;
                transition: border-color 0.3s;
                box-sizing: border-box;
            }
            
            .form-group input:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .login-btn {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: transform 0.2s;
            }
            
            .login-btn:hover {
                transform: translateY(-2px);
            }
            
            .message {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 5px;
                text-align: center;
            }
            
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            
            .home-link {
                margin-top: 20px;
                text-align: center;
            }
            
            .home-link a {
                color: #667eea;
                text-decoration: none;
            }
            
            .home-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <img src="${root}/images/admin-icon.png" alt="Admin" onerror="this.style.display='none'"/>
                <h2>Admin Login</h2>
                <p>BookStore Management System</p>
            </div>
            
            <!-- Display messages -->
            <c:if test="${param.message == 'logout_success'}">
                <div class="message success">
                    Đăng xuất thành công! Hẹn gặp lại.
                </div>
            </c:if>
            
            <c:if test="${param.error == 'logout_failed'}">
                <div class="message error">
                    Có lỗi xảy ra khi đăng xuất.
                </div>
            </c:if>
            
            <c:if test="${param.error == 'invalid'}">
                <div class="message error">
                    Email hoặc mật khẩu không đúng!
                </div>
            </c:if>
            
            <c:if test="${param.error == 'access_denied'}">
                <div class="message error">
                    Bạn cần đăng nhập để truy cập trang quản trị!
                </div>
            </c:if>
            
            <form action="${root}/LoginServlet" method="post">
                <input type="hidden" name="action" value="admin_login"/>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required 
                           placeholder="admin@bookstore.com" 
                           value="${param.email}"/>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Nhập mật khẩu"/>
                </div>
                
                <button type="submit" class="login-btn">Đăng nhập</button>
            </form>
            
            <div class="home-link">
                <a href="${root}/">← Quay về trang chủ</a>
            </div>
        </div>
        
        <script>
            // Auto focus vào email field
            document.getElementById('email').focus();
            
            // Auto hide messages after 5 seconds
            setTimeout(function() {
                const messages = document.querySelectorAll('.message');
                messages.forEach(function(msg) {
                    msg.style.display = 'none';
                });
            }, 5000);
        </script>
    </body>
</html>