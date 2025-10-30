<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String successMsg = "";
    String errorMsg = "";

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        if (name != null && email != null && message != null &&
            !name.trim().isEmpty() && !email.trim().isEmpty() && !message.trim().isEmpty()) {

            // For now, we'll just simulate a successful submission
            // In a real app, you'd store this in a database or send an email
            successMsg = "Thank you, " + name + "! Your message has been received.";
        } else {
            errorMsg = "All fields are required.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Crop Insurance Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f7f7f7;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .hero {
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .section {
            background: #fff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
            border: 2px solid #4CAF50;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        label {
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            background: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background: #45a049;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #4CAF50;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="hero">
        <h1>📞 Contact Us</h1>
        <p>Have questions or need help? Reach out to us!</p>
    </div>

    <div class="section">
        <% if (!successMsg.isEmpty()) { %>
            <p class="success"><%= successMsg %></p>
        <% } %>
        <% if (!errorMsg.isEmpty()) { %>
            <p class="error"><%= errorMsg %></p>
        <% } %>

        <form method="post">
            <label for="name">Your Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Your Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="message">Your Message:</label>
            <textarea id="message" name="message" rows="5" required></textarea>

            <button type="submit">Send Message</button>
        </form>

        <a class="back-link" href="dashboard.jsp">⬅ Back to Dashboard</a>
    </div>
</div>

</body>
</html>
