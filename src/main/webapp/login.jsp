<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/mydb";  // Replace 'mydb' with your DB name
    String dbUser  = "root";                             // Replace with your DB username
    String dbPass = "Rajp@123";                         // Replace with your DB password

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String errorMsg = "";
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if (isPost && username != null && password != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(dbURL, dbUser , dbPass)) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            session.setAttribute("user", username);
                            response.sendRedirect("home.jsp");
                            return;
                        } else {
                            errorMsg = "Invalid username or password.";
                        }
                    }
                }
            }
        } catch (Exception e) {
            errorMsg = "Database error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Crop Insurance Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Farmer-themed styles: Earthy colors, farm background */
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background: linear-gradient(to bottom, #87CEEB 0%, #98FB98 50%, #D2B48C 100%); /* Sky to field to soil */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Subtle farm background elements */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="80" r="2" fill="%23FFD700"/><circle cx="80" cy="85" r="1.5" fill="%23FFD700"/><rect x="10" y="90" width="80" height="10" fill="%238B4513" opacity="0.3"/></svg>'); /* Simple crop/sun/soil pattern */
            background-size: 100px 100px;
            opacity: 0.1;
            z-index: -1;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95); /* Semi-transparent white for form */
            max-width: 400px;
            width: 90%;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-align: center;
            position: relative;
            z-index: 1;
            border: 2px solid #4CAF50; /* Green border for farm feel */
        }

        h2 {
            color: #2E7D32; /* Dark green */
            margin-bottom: 30px;
            font-size: 28px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }

        .farm-title {
            font-size: 18px;
            color: #8B4513; /* Brown */
            margin-bottom: 20px;
            font-weight: 400;
        }

        input {
            width: 100%;
            padding: 15px;
            margin: 10px 0;
            border: 2px solid #D2B48C; /* Earthy border */
            border-radius: 10px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background-color: #F5F5DC; /* Beige background for inputs */
        }

        input:focus {
            border-color: #4CAF50;
            box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
            outline: none;
        }

        button {
            width: 100%;
            padding: 15px;
            background: linear-gradient(to right, #4CAF50, #45a049); /* Green gradient */
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 20px;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
        }

        .error {
            color: #D32F2F; /* Red for errors */
            margin: 15px 0;
            padding: 10px;
            background: rgba(255, 235, 235, 0.8);
            border-radius: 5px;
            border-left: 4px solid #D32F2F;
            display: none; /* Hidden by default, shown via JS */
        }

        .success {
            color: #388E3C; /* Green for success */
            margin: 15px 0;
            padding: 10px;
            background: rgba(235, 255, 235, 0.8);
            border-radius: 5px;
            border-left: 4px solid #388E3C;
        }

        .links {
            margin-top: 20px;
            font-size: 14px;
        }

        a {
            color: #4CAF50;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #2E7D32;
            text-decoration: underline;
        }

        /* Animations: Tractor and Bullock Cart */
        .farm-animation {
            position: absolute;
            top: 20px;
            left: -100px;
            width: 100px;
            height: 50px;
            z-index: 0;
            opacity: 0.7;
        }

        .tractor {
            font-size: 40px; /* Using emoji for simplicity */
            animation: driveAcross 10s linear infinite;
        }

        .bullock-cart {
            position: absolute;
            top: 60px;
            left: -120px;
            font-size: 30px;
            animation: cartAcross 15s linear infinite reverse; /* Reverse direction */
        }

        @keyframes driveAcross {
            0% {
                transform: translateX(-100px);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateX(calc(100vw + 100px));
                opacity: 0;
            }
        }

        @keyframes cartAcross {
            0% {
                transform: translateX(-120px);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateX(calc(100vw + 120px));
                opacity: 0;
            }
        }

        /* Responsive for mobile */
        @media (max-width: 480px) {
            .login-container {
                padding: 20px;
                margin: 10px;
            }
            .farm-animation {
                display: none; /* Hide animations on small screens for performance */
            }
        }

        /* Show error message if present */
        .error.show {
            display: block;
        }
    </style>
</head>
<body>
    <!-- Farm Animations: Tractor and Bullock Cart moving across the top -->
    <div class="farm-animation">
        <div class="tractor">🚜</div> <!-- Tractor emoji animating -->
    </div>
    <div class="bullock-cart">🐂🚜</div> <!-- Bullock cart (bull + cart) animating in reverse -->

    <div class="login-container">
        <h2>🌾 Crop Insurance Portal</h2>
        <p class="farm-title">Secure Your Harvest Today – Login for Farmers</p>

        <% if (!errorMsg.isEmpty()) { %>
            <p class="error show"><%= errorMsg %></p>
        <% } %>

        <form method="post">
            <input type="text" name="username" placeholder="👨‍🌾 Username" required />
            <input type="password" name="password" placeholder="🔒 Password" required />
            <button type="submit">🚜 Login to Dashboard</button>
        </form>

        <div class="links">
            <p>
                <a href="register.jsp">🌱 New Farmer? Register Here</a> | 
                <a href="home.jsp">🏠 Back to Home</a>
            </p>
        </div>
    </div>

    <script>
        // Simple JS to enhance UX (no logic change)
        document.querySelector('form').addEventListener('submit', function() {
            // Add a subtle shake on submit if needed, but keep minimal
            document.body.style.animation = 'none';
        });
    </script>
</body>
</html>