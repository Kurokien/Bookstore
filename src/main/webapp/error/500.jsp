<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true" %>
<%@page import="java.io.PrintWriter" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>500 - Internal Server Error</title>
    <link href="../css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <script src="../js/jquery.min.js"></script>
    <link href="../css/style.css" rel="stylesheet" type="text/css" media="all" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="keywords" content="Bonfire Responsive web template, Bootstrap Web Templates, Flat Web Templates, Android Compatible web template,
              Smartphone Compatible web template, free webdesigns for Nokia, Samsung, LG, SonyEricsson, Motorola web design" />
    <script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
    <link href='http://fonts.googleapis.com/css?family=Exo:100,200,300,400,500,600,700,800,900' rel='stylesheet' type='text/css'>
    <script type="text/javascript" src="../js/move-top.js"></script>
    <script type="text/javascript" src="../js/easing.js"></script>
    <script src="../js/responsiveslides.min.js"></script>
    <style>
        .error-details {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 15px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 14px;
            color: #721c24;
        }
        .error-details pre {
            margin: 0;
            white-space: pre-wrap;
        }
        .toggle-details {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        .toggle-details:hover {
            background-color: #c82333;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<center>
    <div class="single_top">
        <div class="container">
            <div class="error-500 text-center">
                <h1>500</h1>
                <p>Internal Server Error</p>
                <%
                    // Determine if in development mode (you can set this via a system property or config)
                    boolean isDevelopmentMode = "true".equalsIgnoreCase(System.getProperty("app.development.mode", "false"));
                    if (isDevelopmentMode && exception != null) {
                %>
                <div class="error-details">
                    <h3>Error Details</h3>
                    <p><strong>Timestamp:</strong> <%= new Date() %></p>
                    <p><strong>Request URL:</strong> <%= request.getRequestURL() %></p>
                    <p><strong>Request Method:</strong> <%= request.getMethod() %></p>
                    <p><strong>Exception Message:</strong> <%= exception.getMessage() != null ? exception.getMessage() : "No message available" %></p>

                    <h4>Request Parameters:</h4>
                    <ul>
                        <%
                            Enumeration<String> params = request.getParameterNames();
                            if (!params.hasMoreElements()) {
                                out.println("<li>No parameters</li>");
                            } else {
                                while (params.hasMoreElements()) {
                                    String paramName = params.nextElement();
                                    out.println("<li>" + paramName + ": " + request.getParameter(paramName) + "</li>");
                                }
                            }
                        %>
                    </ul>

                    <button class="toggle-details" onclick="toggleStackTrace()">Show Stack Trace</button>
                    <div id="stackTrace" class="hidden error-details">
                        <h4>Stack Trace:</h4>
                        <pre>
                                    <%
                                        StringBuilder stackTrace = new StringBuilder();
                                        PrintWriter pw = new PrintWriter(stackTrace);
                                        exception.printStackTrace(pw);
                                        pw.flush();
                                        out.print(stackTrace.toString());
                                    %>
                                </pre>
                    </div>
                </div>
                <% } else { %>
                <p>An unexpected error occurred. Please contact the administrator if the issue persists.</p>
                <% } %>
                <a class="b-home" href="../index.jsp">Back to Home</a>
            </div>
        </div>
    </div>
</center>

<script>
    function toggleStackTrace() {
        var stackTraceDiv = document.getElementById("stackTrace");
        if (stackTraceDiv.classList.contains("hidden")) {
            stackTraceDiv.classList.remove("hidden");
            document.querySelector(".toggle-details").textContent = "Hide Stack Trace";
        } else {
            stackTraceDiv.classList.add("hidden");
            document.querySelector(".toggle-details").textContent = "Show Stack Trace";
        }
    }
</script>
</body>
</html>