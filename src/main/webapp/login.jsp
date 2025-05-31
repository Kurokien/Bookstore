<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - BookStore</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <script src="js/jquery.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <style>
            .login-form {
                max-width: 450px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            
            .form-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            }
            
            .form-group input:focus {
                border-color: #007cba;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 124, 186, 0.3);
            }
            
            .required {
                color: red;
            }
            
            .btn-login {
                width: 100%;
                padding: 15px;
                background-color: #007cba;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 10px;
                transition: background-color 0.3s;
            }
            
            .btn-login:hover {
                background-color: #005a87;
            }
            
            .btn-login:disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }
            
            .error-message {
                background-color: #ffe6e6;
                color: #721c24;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
            }
            
            .success-message {
                background-color: #e6ffe6;
                color: #155724;
                padding: 12px;
                border-radius: 4px;
                margin-bottom: 20px;
                border: 1px solid #c3e6cb;
            }
            
            .forgot-password {
                text-align: center;
                margin-top: 15px;
            }
            
            .forgot-password a {
                color: #007cba;
                text-decoration: none;
                font-size: 14px;
            }
            
            .forgot-password a:hover {
                text-decoration: underline;
            }
            
            .register-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }
            
            .register-link a {
                color: #007cba;
                text-decoration: none;
                font-weight: bold;
            }
            
            .register-link a:hover {
                text-decoration: underline;
            }
            
            .login-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .login-header h2 {
                color: #333;
                margin-bottom: 10px;
            }
            
            .login-header p {
                color: #666;
                margin: 0;
            }
            
            .remember-me {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            
            .remember-me input[type="checkbox"] {
                width: auto;
                margin-right: 8px;
            }
            
            .form-validation {
                font-size: 12px;
                margin-top: 5px;
            }
            
            .form-validation.error {
                color: #dc3545;
            }
            
            .form-validation.success {
                color: #28a745;
            }
            
            @media (max-width: 768px) {
                .login-form {
                    padding: 15px;
                    margin: 10px;
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
                        $("#email-validation").text("✓ Valid email format").removeClass("error").addClass("success");
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
                        $("#password-validation").text("✗ Password too short (minimum 6 characters)").removeClass("success").addClass("error");
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
                
                // Remember me functionality (optional)
                if (localStorage.getItem("rememberedEmail")) {
                    $("#email").val(localStorage.getItem("rememberedEmail"));
                    $("#rememberMe").prop("checked", true);
                    $("#password").focus();
                    validateForm();
                }
                
                // Save email if remember me is checked
                $("#loginForm").submit(function() {
                    if ($("#rememberMe").is(":checked")) {
                        localStorage.setItem("rememberedEmail", $("#email").val());
                    } else {
                        localStorage.removeItem("rememberedEmail");
                    }
                });
                
                // Auto-hide success/error messages after 5 seconds
                setTimeout(function() {
                    $(".success-message, .error-message").fadeOut();
                }, 5000);
            });
        </script>
    </head>
    <body>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="container">
            <div class="account">
                <div class="login-form">
                    <div class="login-header">
                        <h2 class="account-in">Welcome Back</h2>
                        <p>Sign in to your BookStore account</p>
                    </div>
                    
                    <!-- Display messages -->
                    <%if(request.getParameter("error") != null){%>
                        <div class="error-message">
                            <strong>Login Failed:</strong> <%=request.getParameter("error")%>
                        </div> 
                    <%}%>
                    
                    <%if(request.getParameter("message") != null){%>
                        <div class="success-message">
                            <%=request.getParameter("message")%>
                        </div> 
                    <%}%>
                    
                    <%if(request.getParameter("success") != null){%>
                        <div class="success-message">
                            <%=request.getParameter("success")%>
                        </div> 
                    <%}%>
                    
                    <form action="<%= request.getContextPath()%>/users" method="POST" id="loginForm">
                        
                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <input type="email" name="email" id="email" required 
                                   placeholder="Enter your email address"
                                   value="<%=request.getParameter("email") != null ? request.getParameter("email") : ""%>">
                            <div id="email-validation" class="form-validation"></div>
                        </div>
                        
                        <!-- Password -->
                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <input type="password" name="pass" id="password" required 
                                   placeholder="Enter your password">
                            <div id="password-validation" class="form-validation"></div>
                        </div>
                        
                        <!-- Remember Me -->
                        <div class="remember-me">
                            <input type="checkbox" name="rememberMe" id="rememberMe">
                            <label for="rememberMe">Remember my email</label>
                        </div>
                        
                        <!-- Submit Button -->
                        <input type="hidden" value="login" name="command">
                        <button type="submit" id="loginBtn" class="btn-login" disabled>
                            Sign In
                        </button>
                        
                        <!-- Forgot Password -->
                        <div class="forgot-password">
                            <a href="#" onclick="alert('Please contact administrator to reset password')">
                                Forgot your password?
                            </a>
                        </div>
                        
                    </form>
                    
                    <!-- Register Link -->
                    <div class="register-link">
                        <p>Don't have an account? <a href="register.jsp">Create one here</a></p>
                    </div>
                    
                    <!-- Quick Login Info (for demo) -->
                    <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border-radius: 4px; font-size: 12px;">
                        <strong>Demo Accounts:</strong><br>
                        <strong>Admin:</strong> admin@bookstore.com / admin123<br>
                        <strong>Customer:</strong> john.doe@gmail.com / 123456<br>
                        <strong>Customer:</strong> truongtungduong9x@gmail.com / 12345
                    </div>
                    
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

    </body>
</html>