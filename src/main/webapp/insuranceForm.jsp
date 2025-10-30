<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.DecimalFormat" %>

<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // DB Config
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPass = "Rajp@123"; // change this

    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    String cropType = "";
    String areaStr = "";
    String yieldStr = "";
    String priceStr = "";
    boolean isValid = true;
    String errorMsg = "";
    double area = 0, yield = 0, price = 0;
    double sumInsured = 0;
    double premium = 0;
    DecimalFormat df = new DecimalFormat("#.##");
    String status = "";
    boolean submitted = false;

    if (isPost) {
        cropType = request.getParameter("cropType");
        areaStr = request.getParameter("area");
        yieldStr = request.getParameter("yield");
        priceStr = request.getParameter("price");

        // Validation
        if (cropType == null || cropType.trim().isEmpty()) {
            isValid = false;
            errorMsg = "Crop type is required.";
        }

        try {
            area = Double.parseDouble(areaStr);
            yield = Double.parseDouble(yieldStr);
            price = Double.parseDouble(priceStr);

            if (area < 0.1 || area > 1000) {
                isValid = false;
                errorMsg = "Area must be between 0.1 and 1000 acres.";
            }

            if (yield < 0 || price < 0) {
                isValid = false;
                errorMsg = "Yield and Price must be non-negative.";
            }

        } catch (NumberFormatException e) {
            isValid = false;
            errorMsg = "Invalid numeric input.";
        }

        if (isValid) {
            sumInsured = area * yield * price;
            premium = sumInsured * 0.02;
            status = (area >= 1 && premium >= 1000) ? "Passed" : "Pending";

            // Store in DB
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                String sql = "INSERT INTO insurance_submissions " +
                             "(username, crop_type, area, yield, price, sum_insured, premium, status) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, user);
                ps.setString(2, cropType);
                ps.setDouble(3, area);
                ps.setDouble(4, yield);
                ps.setDouble(5, price);
                ps.setDouble(6, sumInsured);
                ps.setDouble(7, premium);
                ps.setString(8, status);
                ps.executeUpdate();

                ps.close();
                conn.close();
                submitted = true;

            } catch (Exception e) {
                errorMsg = "DB Error: " + e.getMessage();
                isValid = false;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Crop Insurance Submission</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 10px; }
        label { display: block; margin-top: 10px; font-weight: bold; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; box-sizing: border-box; }
        button { background-color: #4CAF50; color: white; padding: 10px 20px; margin-top: 20px; border: none; cursor: pointer; width: 100%; }
        .error { color: red; }
        .result { background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 20px 0; }
        a { color: #4CAF50; text-decoration: none; }
    </style>
</head>
<body>
    <h1>Crop Insurance Form</h1>
    <p>Welcome, <strong><%= user %></strong></p>

    <% if (submitted && isValid) { %>
        <div class="result">
            <h3>Submission Successful!</h3>
            <p>Crop: <%= cropType %>, Area: <%= df.format(area) %> acres</p>
            <p>Sum Insured: ₹<%= df.format(sumInsured) %>, Premium: ₹<%= df.format(premium) %></p>
            <p>Status: <strong><%= status %></strong></p>
            <p><a href="dashboard.jsp">Go to Dashboard</a></p>
        </div>
    <% } else { %>
        <% if (!isValid) { %>
            <p class="error"><%= errorMsg %></p>
        <% } %>
        <form method="post">
            <label for="cropType">Crop Type:</label>
            <select id="cropType" name="cropType" required>
                <option value="">Select</option>
                <option value="Rice" <%= "Rice".equals(cropType) ? "selected" : "" %>>Rice</option>
                <option value="Wheat" <%= "Wheat".equals(cropType) ? "selected" : "" %>>Wheat</option>
                <option value="Maize" <%= "Maize".equals(cropType) ? "selected" : "" %>>Maize</option>
                <option value="Cotton" <%= "Cotton".equals(cropType) ? "selected" : "" %>>Cotton</option>
            </select>

            <label for="area">Area (acres):</label>
            <input type="number" id="area" name="area" min="0.1" step="0.1" value="<%= areaStr %>" required>

            <label for="yield">Yield (quintals/acre):</label>
            <input type="number" id="yield" name="yield" min="0" step="0.1" value="<%= yieldStr %>" required>

            <label for="price">Price (INR/quintal):</label>
            <input type="number" id="price" name="price" min="0" step="0.01" value="<%= priceStr %>" required>

            <button type="submit">Submit</button>
        </form>
    <% } %>

    <p><a href="dashboard.jsp">Go to Dashboard</a> | <a href="home.jsp">Home</a></p>
</body>
</html>
