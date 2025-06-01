<%@page import="com.bookstore.model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Edit Profile</title>
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
      background-color: #ffe6e6;
      padding: 10px;
      border-radius: 4px;
    }

    .success-message {
      color: green;
      font-size: 12px;
      margin-top: 5px;
      background-color: #e6ffe6;
      padding: 10px;
      border-radius: 4px;
    }

    @media (max-width: 768px) {
      .form-row {
        flex-direction: column;
      }
    }
  </style>
  <%--  // Enable/disable submit button based on required fields--%>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const form = document.getElementById('editForm');
      const submitButton = form.querySelector('.btn-register');
      const fullnameInput = document.getElementById('fullname');

      function checkFormValidity() {
        const isValid = fullnameInput.value.trim() !== '';
        submitButton.disabled = !isValid;
      }

      fullnameInput.addEventListener('input', checkFormValidity);
      checkFormValidity(); // Initial check
    });
  </script>
</head>
<body>

<%
  // Retrieve the logged-in user from session
  Users user = (Users) session.getAttribute("user");

  // Redirect to login if user is not logged in
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>

<jsp:include page="header.jsp"></jsp:include>

<div class="container">
  <div class="account">
    <div class="register-form">
      <h2 class="account-in">Edit Your Profile</h2>

      <% if (request.getParameter("error") != null) { %>
      <div class="error-message">
        <strong>Error:</strong> <%= request.getParameter("error") %>
      </div>
      <% } %>

      <% if (request.getParameter("success") != null) { %>
      <div class="success-message">
        <strong>Success:</strong> <%= request.getParameter("success") %>
      </div>
      <% } %>

      <form action="<%= request.getContextPath() %>/users?command=edit" method="POST" id="editForm">
        <!-- Hidden fields -->
        <input type="hidden" name="command" value="edit">
        <input type="hidden" name="email" value="<%= user.getUserEmail() %>">

        <!-- Full Name -->
        <div class="form-group">
          <label for="fullname">Full Name <span class="required">*</span></label>
          <input type="text" name="fullname" id="fullname" required
                 value="<%= user.getUserFullname() != null ? user.getUserFullname() : "" %>"
                 placeholder="Enter your full name" maxlength="255">
        </div>

        <!-- Email (Read-only to prevent changes) -->
        <div class="form-group">
          <label for="email">Email Address <span class="required">*</span></label>
          <input type="email" name="email_display" id="email" readonly
                 value="<%= user.getUserEmail() %>"
                 placeholder="Enter your email address">
        </div>

        <!-- Phone and Country Row -->
        <div class="form-row">
          <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" name="phone" id="phone"
                   value="<%= user.getUserPhone() != null ? user.getUserPhone() : "" %>"
                   placeholder="e.g., +84 123-456-789" maxlength="20">
          </div>

          <div class="form-group">
            <label for="country">Country</label>
            <select name="country" id="country">
              <option value="">Select Country</option>
              <option value="Vietnam" <%= "Vietnam".equals(user.getUserCountry()) ? "selected" : "" %>>Vietnam</option>
              <option value="United States" <%= "United States".equals(user.getUserCountry()) ? "selected" : "" %>>United States</option>
              <option value="United Kingdom" <%= "United Kingdom".equals(user.getUserCountry()) ? "selected" : "" %>>United Kingdom</option>
              <option value="Canada" <%= "Canada".equals(user.getUserCountry()) ? "selected" : "" %>>Canada</option>
              <option value="Australia" <%= "Australia".equals(user.getUserCountry()) ? "selected" : "" %>>Australia</option>
              <option value="Japan" <%= "Japan".equals(user.getUserCountry()) ? "selected" : "" %>>Japan</option>
              <option value="South Korea" <%= "South Korea".equals(user.getUserCountry()) ? "selected" : "" %>>South Korea</option>
              <option value="Singapore" <%= "Singapore".equals(user.getUserCountry()) ? "selected" : "" %>>Singapore</option>
              <option value="Thailand" <%= "Thailand".equals(user.getUserCountry()) ? "selected" : "" %>>Thailand</option>
              <option value="Malaysia" <%= "Malaysia".equals(user.getUserCountry()) ? "selected" : "" %>>Malaysia</option>
              <option value="Philippines" <%= "Philippines".equals(user.getUserCountry()) ? "selected" : "" %>>Philippines</option>
              <option value="Indonesia" <%= "Indonesia".equals(user.getUserCountry()) ? "selected" : "" %>>Indonesia</option>
              <option value="China" <%= "China".equals(user.getUserCountry()) ? "selected" : "" %>>China</option>
              <option value="India" <%= "India".equals(user.getUserCountry()) ? "selected" : "" %>>India</option>
              <option value="Germany" <%= "Germany".equals(user.getUserCountry()) ? "selected" : "" %>>Germany</option>
              <option value="France" <%= "France".equals(user.getUserCountry()) ? "selected" : "" %>>France</option>
              <option value="Italy" <%= "Italy".equals(user.getUserCountry()) ? "selected" : "" %>>Italy</option>
              <option value="Spain" <%= "Spain".equals(user.getUserCountry()) ? "selected" : "" %>>Spain</option>
              <option value="Netherlands" <%= "Netherlands".equals(user.getUserCountry()) ? "selected" : "" %>>Netherlands</option>
              <option value="Brazil" <%= "Brazil".equals(user.getUserCountry()) ? "selected" : "" %>>Brazil</option>
              <option value="Other" <%= "Other".equals(user.getUserCountry()) ? "selected" : "" %>>Other</option>
            </select>
          </div>
        </div>

        <!-- Address -->
        <div class="form-group">
          <label for="address">Address</label>
          <textarea name="address" id="address" rows="3"
                    placeholder="Enter your full address (optional)"><%= user.getUserAddress() != null ? user.getUserAddress() : "" %></textarea>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn-register">Update Profile</button>

        <!-- Back to Profile Link -->
        <div style="text-align: center; margin-top: 20px;">
          <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>