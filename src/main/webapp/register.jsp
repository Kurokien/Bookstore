<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register - BookStore</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <script src="js/jquery.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <style>
            .register-form {
                max-width: 600px;
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
            
            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                box-sizing: border-box;
            }
            
            .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
                border-color: #007cba;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 124, 186, 0.3);
            }
            
            .required {
                color: red;
            }
            
            .form-row {
                display: flex;
                gap: 15px;
            }
            
            .form-row .form-group {
                flex: 1;
            }
            
            .email-check {
                margin-top: 5px;
                min-height: 20px;
                font-size: 12px;
            }
            
            .password-strength {
                margin-top: 5px;
                font-size: 12px;
            }
            
            .password-match {
                margin-top: 5px;
                font-size: 12px;
            }
            
            .btn-register {
                width: 100%;
                padding: 15px;
                background-color: #007cba;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
            }
            
            .btn-register:hover {
                background-color: #005a87;
            }
            
            .btn-register:disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }
            
            .error-message {
                color: red;
                font-size: 12px;
                margin-top: 5px;
            }
            
            .success-message {
                color: green;
                font-size: 12px;
                margin-top: 5px;
            }
            
            @media (max-width: 768px) {
                .form-row {
                    flex-direction: column;
                }
            }
        </style>
        
        <script type="text/javascript">
            $(document).ready(function () {
                var isEmailValid = false;
                var isPasswordMatch = false;
                
                // Email validation
                $("#email").keyup(function (e) {
                    var email = $(this).val();
                    var emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

                    if (email.length > 0) {
                        if (emailRegex.test(email)) {
                            $("#email-result").html('<span class="success-message">✓ Valid email format</span>');
                            isEmailValid = true;
                        } else {
                            $("#email-result").html('<span class="error-message">✗ Invalid email format</span>');
                            isEmailValid = false;
                        }
                    } else {
                        $("#email-result").html("");
                        isEmailValid = false;
                    }
                    updateSubmitButton();
                });

                // Password strength check
                $("#password").keyup(function() {
                    var password = $(this).val();
                    var strength = checkPasswordStrength(password);
                    $("#password-strength").html(strength.message).attr('class', 'password-strength ' + strength.class);
                    checkPasswordMatch();
                });
                
                // Confirm password check
                $("#confirmPassword").keyup(function() {
                    checkPasswordMatch();
                });
                
                function checkPasswordStrength(password) {
                    if (password.length < 6) {
                        return {message: "Password too short (minimum 6 characters)", class: "error-message"};
                    } else if (password.length < 8) {
                        return {message: "Password strength: Weak", class: "error-message"};
                    } else if (password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)) {
                        return {message: "Password strength: Strong", class: "success-message"};
                    } else {
                        return {message: "Password strength: Medium", class: "password-strength"};
                    }
                }
                
                function checkPasswordMatch() {
                    var password = $("#password").val();
                    var confirmPassword = $("#confirmPassword").val();
                    
                    if (confirmPassword.length > 0) {
                        if (password === confirmPassword) {
                            $("#password-match").html("✓ Passwords match").attr('class', 'success-message');
                            isPasswordMatch = true;
                        } else {
                            $("#password-match").html("✗ Passwords do not match").attr('class', 'error-message');
                            isPasswordMatch = false;
                        }
                    } else {
                        $("#password-match").html("");
                        isPasswordMatch = false;
                    }
                    updateSubmitButton();
                }
                
                // Form validation
                function updateSubmitButton() {
                    var isFormValid = isEmailValid && isPasswordMatch && 
                                     $("#fullname").val().length > 0 && 
                                     $("#email").val().length > 0 &&
                                     $("#password").val().length >= 6;
                    
                    $("#registerBtn").prop("disabled", !isFormValid);
                }
                
                // Check required fields
                $("#fullname, #email, #password, #confirmPassword").keyup(function() {
                    updateSubmitButton();
                });
                
                // Phone number formatting
                $("#phone").keyup(function() {
                    var phone = $(this).val().replace(/\D/g, '');
                    if (phone.length > 0) {
                        if (phone.length <= 10) {
                            phone = phone.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                        }
                        $(this).val(phone);
                    }
                });
                
                // Form submission validation
                // Form submission validation
                $("#registerForm").submit(function(e) {
                    if (!isEmailValid) {
                        alert("Please use a valid email address.");
                        e.preventDefault();
                        return false;
                    }
                    
                    if (!isPasswordMatch) {
                        alert("Passwords do not match.");
                        e.preventDefault();
                        return false;
                    }
                    
                    if ($("#password").val().length < 6) {
                        alert("Password must be at least 6 characters long.");
                        e.preventDefault();
                        return false;
                    }
                    
                    return true;
                });
            });
        </script>
    </head>
    <body>

        <jsp:include page="header.jsp"></jsp:include>

        <div class="container">
            <div class="account">
                <div class="register-form">
                    <h2 class="account-in">Create Your Account</h2>
                    
                    <%if(request.getParameter("error") != null){%>
                        <div class="error-message" style="background-color: #ffe6e6; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
                            <strong>Error:</strong> <%=request.getParameter("error")%>
                        </div> 
                    <%}%>
                    
                    <%if(request.getParameter("success") != null){%>
                        <div class="success-message" style="background-color: #e6ffe6; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
                            <strong>Success:</strong> <%=request.getParameter("success")%>
                        </div> 
                    <%}%>
                    
                    <form action="<%= request.getContextPath()%>/users" method="POST" id="registerForm">
                        
                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullname">Full Name <span class="required">*</span></label>
                            <input type="text" name="fullname" id="fullname" required 
                                   placeholder="Enter your full name" maxlength="255">
                        </div>
                        
                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <input type="email" name="email" id="email" required 
                                   placeholder="Enter your email address" maxlength="255">
                            <div id="email-result" class="email-check"></div>
                        </div>
                        
                        <!-- Phone and Country Row -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" name="phone" id="phone" 
                                       placeholder="e.g., +84 123-456-789" maxlength="20">
                            </div>
                            
                            <div class="form-group">
                                <label for="country">Country</label>
                                <select name="country" id="country">
                                    <option value="">Select Country</option>
                                    <option value="Vietnam">Vietnam</option>
                                    <option value="United States">United States</option>
                                    <option value="United Kingdom">United Kingdom</option>
                                    <option value="Canada">Canada</option>
                                    <option value="Australia">Australia</option>
                                    <option value="Japan">Japan</option>
                                    <option value="South Korea">South Korea</option>
                                    <option value="Singapore">Singapore</option>
                                    <option value="Thailand">Thailand</option>
                                    <option value="Malaysia">Malaysia</option>
                                    <option value="Philippines">Philippines</option>
                                    <option value="Indonesia">Indonesia</option>
                                    <option value="China">China</option>
                                    <option value="India">India</option>
                                    <option value="Germany">Germany</option>
                                    <option value="France">France</option>
                                    <option value="Italy">Italy</option>
                                    <option value="Spain">Spain</option>
                                    <option value="Netherlands">Netherlands</option>
                                    <option value="Brazil">Brazil</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Address -->
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea name="address" id="address" rows="3" 
                                      placeholder="Enter your full address (optional)"></textarea>
                        </div>
                        
                        <!-- Password Row -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="password">Password <span class="required">*</span></label>
                                <input type="password" name="password" id="password" required 
                                       placeholder="Enter your password" minlength="6">
                                <div id="password-strength" class="password-strength"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                                <input type="password" name="confirmPassword" id="confirmPassword" required 
                                       placeholder="Confirm your password">
                                <div id="password-match" class="password-match"></div>
                            </div>
                        </div>
                        
                        <!-- Terms and Conditions -->
                        <div class="form-group">
                            <label>
                                <input type="checkbox" name="terms" id="terms" required style="width: auto; margin-right: 8px;">
                                I agree to the <a href="#" target="_blank">Terms and Conditions</a> and <a href="#" target="_blank">Privacy Policy</a> <span class="required">*</span>
                            </label>
                        </div>
                        
                        <!-- Submit Button -->
                        <input type="hidden" value="insert" name="command">
                        <button type="submit" id="registerBtn" class="btn-register" disabled>
                            Create Account
                        </button>
                        
                        <!-- Login Link -->
                        <div style="text-align: center; margin-top: 20px;">
                            <p>Already have an account? <a href="login.jsp">Sign in here</a></p>
                        </div>
                        
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp"></jsp:include>

    </body>
</html>