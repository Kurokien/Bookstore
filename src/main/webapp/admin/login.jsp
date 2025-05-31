<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Login - BookStore</title>
        
        <c:set var="root" value="${pageContext.request.contextPath}"/>
        <link href="${root}/css/mos-style.css" rel='stylesheet' type='text/css' />
        <script src="${root}/js/jquery.min.js"></script>
        
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            
            .login-container {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
                width: 400px;
                text-align: center;
            }
            
            .login-header {
                margin-bottom: 30px;
            }
            
            .login-header h2 {
                color: #333;
                margin-bottom: 10px;
                font-size: 24px;
            }
            
            .login-header .logo {
                width: 80px;
                height: 80px;
                margin: 0 auto 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 32px;
                font-weight: bold;
            }
            
            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 5px;
                color: #555;
                font-weight: 600;
            }
            
            .form-group input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e1e1e1;
                border-radius: 8px;
                font-size: 16px;
                transition: all 0.3s;
                box-sizing: border-box;
            }
            
            .form-group input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 10px rgba(102, 126, 234, 0.3);
            }
            
            .login-btn {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s;
                margin-top: 10px;
            }
            
            .login-btn:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }
            
            .login-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }
            
            .message {
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 8px;
                text-align: center;
                font-weight: 500;
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
                margin-top: 25px;
                text-align: center;
            }
            
            .home-link a {
                color: #667eea;
                text-decoration: none;
                font-size: 14px;
                transition: color 0.3s;
            }
            
            .home-link a:hover {
                color: #764ba2;
                text-decoration: underline;
            }
            
            .required {
                color: #e74c3c;
            }
            
            .form-validation {
                font-size: 12px;
                margin-top: 5px;
            }
            
            .form-validation.error {
                color: #e74c3c;
            }
            
            .form-validation.success {
                color: #27ae60;
            }
            
            .quick-login {
                margin-top: 20px;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 8px;
                font-size: 12px;
                text-align: left;
            }
            
            .quick-login strong {
                color: #333;
            }
            
            @media (max-width: 480px) {
                .login-container {
                    width: 90%;
                    padding: 30px 20px;
                }
            }
        </style>
        
        <script type="text/javascript">
            $(document).ready(function () {
                var isFormValid = false;
                
                // Email validation
                $("#email").on('input', function() {
                    var email = $(this).val();
                    var emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                    
                    if (email.length === 0) {
                        $("#email-validation").text("").removeClass("error success");
                    } else if (emailRegex.test(email)) {
                        $("#email-validation").text("✓ Valid admin email format").removeClass("error").addClass("success");
                    } else {
                        $("#email-validation").text("✗ Invalid email format").removeClass("success").addClass("error");
                    }
                    
                    validateForm();
                });
                
                // Password validation
                $("#password").on('input', function() {
                    var password = $(this).val();
                    
                    if (password.length === 0) {
                        $("#password-validation").text("").removeClass("error success");
                    } else if (password.length < 6) {
                        $("#password-validation").text("✗ Password too short").removeClass("success").addClass("error");
                    } else {
                        $("#password-validation").text("✓ Password length OK").removeClass("error").addClass("success");
                    }
                    
                    validateForm();
                });
                
                // Form validation
                function validateForm() {
                    var email = $("#email").val();
                    var password = $("#password").val();
                    var emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                    
                    isFormValid = email.length > 0 && 
                                  password.length >= 6 && 
                                  emailRegex.test(email);
                    
                    $("#loginBtn").prop("disabled", !isFormValid);
                }
                
                // Form submission
                $("#loginForm").submit(function(e) {
                    if (!isFormValid) {
                        e.preventDefault();
                        alert("Please fill in all fields correctly.");
                        return false;
                    }
                    
                    // Show loading state
                    $("#loginBtn").prop("disabled", true).text("Signing in...");
                });
                
                // Auto focus on email field
                $("#email").focus();
                
                // Auto-hide messages after 5 seconds
                setTimeout(function() {
                    $(".message").fadeOut();
                }, 5000);
                
                // Quick login functionality
                $(".quick-email").click(function(e) {
                    e.preventDefault();
                    var email = $(this).text();
                    $("#email").val(email).trigger('input');
                    $("#password").focus();
                });
            });
        </script>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <div class="logo">👨‍💼</div>
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
            
            <c:if test="${param.error == 'empty_fields'}">
                <div class="message error">
                    Vui lòng nhập đầy đủ email và mật khẩu!
                </div>
            </c:if>
            
            <c:if test="${param.error == 'system_error'}">
                <div class="message error">
                    Có lỗi hệ thống, vui lòng thử lại sau!
                </div>
            </c:if>
            
            <form action="${root}/LoginServlet" method="post" id="loginForm">
                <input type="hidden" name="action" value="admin_login"/>
                
                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email" id="email" name="email" required 
                           placeholder="admin@bookstore.com" 
                           value="${param.email}"/>
                    <div id="email-validation" class="form-validation"></div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password <span class="required">*</span></label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Enter your admin password"/>
                    <div id="password-validation" class="form-validation"></div>
                </div>
                
                <button type="submit" id="loginBtn" class="login-btn" disabled>
                    🔐 Sign In as Admin
                </button>
            </form>
            
            <div class="home-link">
                <a href="${root}/">← Back to Customer Site</a>
            </div>
            
            <!-- Quick Login Info (for demo) -->
            <div class="quick-login">
                <strong>Demo Admin Account:</strong><br>
                Email: <a href="#" class="quick-email" style="color: #667eea;">admin@bookstore.com</a><br>
                Password: <strong>admin123</strong>
            </div>
        </div>
    </body>
</html>