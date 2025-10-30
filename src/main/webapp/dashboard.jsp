<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    // --- DB CONNECTION CONFIG ---
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser  = "root";
    String dbPass = "Rajp@123"; // change to your password

    // --- AUTH CHECK ---
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- HANDLE FORM SUBMISSION ---
  String successMsg = "";
    String errorMsg = "";
    // Check if this is a POST request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String cropType = request.getParameter("crop_type");
        String areaStr = request.getParameter("area");
        String yieldStr = request.getParameter("yield");
        String priceStr = request.getParameter("price");

        if (cropType != null && areaStr != null && yieldStr != null && priceStr != null) {
            try {
                double area = Double.parseDouble(areaStr);
                double yield = Double.parseDouble(yieldStr);
                double price = Double.parseDouble(priceStr);

                double sumInsured = area * yield * price;
                double premium = sumInsured * 0.02; // 2% premium

                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                    String insertSQL = "INSERT INTO insurance_submissions (username, crop_type, area, yield, price, sum_insured, premium, status, submitted_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
                    try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                        ps.setString(1, user);
                        ps.setString(2, cropType);
                        ps.setDouble(3, area);
                        ps.setDouble(4, yield);
                        ps.setDouble(5, price);
                        ps.setDouble(6, sumInsured);
                        ps.setDouble(7, premium);
                        ps.setString(8, "Pending");

                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            successMsg = "Insurance request submitted successfully!";
                        } else {
                            errorMsg = "Failed to submit the request.";
                        }
                    }
                }
            } catch (Exception e) {
                errorMsg = "Error: " + e.getMessage();
            }
        } else {
            errorMsg = "All fields are required.";
        }
    }



    // --- FETCH USER SUBMISSIONS AND PROFILE ---
    List<Map<String, Object>> userSubs = new ArrayList<>();
    Map<String, Object> userProfile = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser , dbPass)) {

            // Fetch user submissions
          String selectSQL = "SELECT crop_type, area, yield, price, sum_insured, premium, status, submitted_at FROM insurance_submissions WHERE username = ?";
try (PreparedStatement ps = conn.prepareStatement(selectSQL)) {
    ps.setString(1, user);
    try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Map<String, Object> submission = new HashMap<>();
            submission.put("cropType", rs.getString("crop_type"));
            submission.put("area", rs.getDouble("area"));
            submission.put("yield", rs.getDouble("yield"));
            submission.put("price", rs.getDouble("price"));
            submission.put("sumInsured", rs.getDouble("sum_insured"));
            submission.put("premium", rs.getDouble("premium"));
            submission.put("status", rs.getString("status"));
            submission.put("submittedAt", rs.getTimestamp("submitted_at"));
            userSubs.add(submission);
        }
    }
}

            // Fetch latest user profile (latest insurance submission)
            String profileSQL = "SELECT crop_type, area, yield, price, sum_insured, premium, status, submitted_at FROM insurance_submissions WHERE username = ? ORDER BY submitted_at DESC LIMIT 1";
            try (PreparedStatement psProfile = conn.prepareStatement(profileSQL)) {
                psProfile.setString(1, user);
                try (ResultSet rsProfile = psProfile.executeQuery()) {
                    if (rsProfile.next()) {
                        userProfile = new HashMap<>();
                        userProfile.put("cropType", rsProfile.getString("crop_type"));
                        userProfile.put("area", rsProfile.getDouble("area"));
                        userProfile.put("yield", rsProfile.getDouble("yield"));
                        userProfile.put("price", rsProfile.getDouble("price"));
                        userProfile.put("sumInsured", rsProfile.getDouble("sum_insured"));
                        userProfile.put("premium", rsProfile.getDouble("premium"));
                        userProfile.put("status", rsProfile.getString("status"));
                        userProfile.put("submittedAt", rsProfile.getTimestamp("submitted_at"));
                    }
                }
            }
        }
    } catch (Exception e) {
        errorMsg = "Error fetching submissions/profile: " + e.getMessage();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard - Crop Insurance Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f7f7f7;
            padding: 20px;
        }
        .container {
            max-width: 960px;
            margin: 0 auto;
        }
        .hero {
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .logout-btn {
            float: right;
            color: white;
            text-decoration: none;
        }
        .profile-section {
            background: #fff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
            border: 2px solid #4CAF50;
        }
        .profile-table {
            width: 100%;
        }
        .form-section, .submissions-section {
            background: #fff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
        }
        .success {
            color: green;
        }
        .error {
            color: red;
        }
        .submission-card {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px 0;
            border-radius: 8px;
        }
        .status.passed { color: green; }
        .status.pending { color: orange; }
        .status.rejected { color: red; }
    </style>
</head>
<body>

<div class="container">
    <section class="hero">
        <h1>🌾 Farmer Dashboard</h1>
        <p>Welcome back, <%= user %>!</p>
        <a href="login.jsp?logout=true" class="logout-btn">🚪 Logout</a>
    </section>

    <!-- Profile Section -->
    <section class="profile-section">
        <h2>👨‍🌾 Your Latest Insurance Profile</h2>
        <% if (userProfile != null) { %>
            <table class="profile-table">
                <tr><th>Crop Type</th><td><%= userProfile.get("cropType") %></td></tr>
                <tr><th>Area (acres)</th><td><%= userProfile.get("area") %></td></tr>
                <tr><th>Yield (tons)</th><td><%= userProfile.get("yield") %></td></tr>
                <tr><th>Price (per ton)</th><td><%= userProfile.get("price") %></td></tr>
                <tr><th>Sum Insured</th><td><%= userProfile.get("sumInsured") %></td></tr>
                <tr><th>Premium</th><td><%= userProfile.get("premium") %></td></tr>
               
                <tr><th>Last Submitted</th><td><%= sdf.format((java.util.Date) userProfile.get("submittedAt")) %>
</td></tr>
            </table>
        <% } else { %>
            <p>No recent insurance profile found.</p>
        <% } %>
    </section>

    <!-- Form Section -->
   

    <!-- Submissions Section -->
    <section class="submissions-section">
        <h2>📋 Your Insurance Submissions</h2>
        <% if (userSubs.isEmpty()) { %>
            <p>No submissions found. Submit your first request above.</p>
        <% } else { %>
            <% for (Map<String, Object> sub : userSubs) { %>
                <div class="submission-card">
                    <h3><%= sub.get("cropType") %></h3>
                    <p><strong>sumInsured:</strong> <%= sub.get("sumInsured") %></p>
                    <p><strong>Submitted At:</strong> <%= sdf.format((java.util.Date) userProfile.get("submittedAt")) %>
</p>
                    <p><strong>Status:</strong> 
                        <span class="status <%= "Passed".equals(sub.get("status")) ? "passed" : ("Pending".equals(sub.get("status")) ? "pending" : "rejected") %>">
                            <%= sub.get("status") != null ? sub.get("status") : "Pending" %>
                        </span>
                    </p>
                </div>
            <% } %>
        <% } %>
    </section>
</div>

</body>
</html>
