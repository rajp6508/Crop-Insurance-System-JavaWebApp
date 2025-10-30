<%@ page import="java.sql.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPass = "Rajp@123";

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            message = "Please enter username and password.";
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                    String sql = "SELECT * FROM admin_users WHERE username=?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, username);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                String dbPassword = rs.getString("password");
                                // For demo, plain text comparison:
                                if (dbPassword.equals(password)) {
                                    session.setAttribute("user", username);
                                    session.setAttribute("role", "admin");
                                    response.sendRedirect("admin.jsp");
                                    return;
                                } else {
                                    message = "Incorrect password.";
                                }
                            } else {
                                message = "User not found.";
                            }
                        }
                    }
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Crop Insurance Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #4CAF50;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            background: white;
            color: #333;
            padding: 30px;
            border-radius: 10px;
            width: 300px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #4CAF50;
        }
        input[type=text], input[type=password] {
            width: 100%;
            padding: 12px;
            margin: 8px 0 16px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            width: 100%;
            background: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background: #45a049;
        }
        .message {
            margin: 15px 0;
            text-align: center;
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Admin Login</h2>
    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>
    <form method="post">
        <input type="text" name="username" placeholder="Username" required autofocus>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>
</div>

</body>
</html>
