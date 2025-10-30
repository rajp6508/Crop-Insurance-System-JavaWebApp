<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/mydb";
    String dbUser = "root";
    String dbPass = "Rajp@123";

    String message = "";

    // Check admin session
    String user = (String) session.getAttribute("user");
    if (user == null || !"admin".equals(user)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle update request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String cropType = request.getParameter("crop_type");
            double sumInsured = Double.parseDouble(request.getParameter("sum_insured"));
            String status = request.getParameter("status");

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                String updateSQL = "UPDATE insurance_submissions SET crop_type=?, sum_insured=?, status=? WHERE id=?";
                try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
                    ps.setString(1, cropType);
                    ps.setDouble(2, sumInsured);
                    ps.setString(3, status);
                    ps.setInt(4, id);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        message = "Update successful for ID " + id;
                    } else {
                        message = "No rows updated. Check ID.";
                    }
                }
            }
        } catch (Exception e) {
            message = "Error updating submission: " + e.getMessage();
        }
    }

    // Fetch all submissions
    List<Map<String, Object>> submissions = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
            String selectSQL = "SELECT * FROM insurance_submissions";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(selectSQL)) {
                while (rs.next()) {
                    Map<String, Object> sub = new HashMap<>();
                    sub.put("id", rs.getInt("id"));
                    sub.put("username", rs.getString("username"));
                    sub.put("crop_type", rs.getString("crop_type"));
                    sub.put("sum_insured", rs.getDouble("sum_insured"));
                    sub.put("status", rs.getString("status"));
                    submissions.add(sub);
                }
            }
        }
    } catch (Exception e) {
        message = "Error fetching submissions: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - Crop Insurance Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #f7f7f7;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .hero {
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .message {
            margin-top: 10px;
            font-weight: bold;
            color: green;
        }
        .error {
            color: red;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: left;
        }
        th {
            background: #4CAF50;
            color: white;
        }
        input, select {
            padding: 5px;
            width: 100%;
        }
        button {
            background: #4CAF50;
            color: white;
            padding: 6px 12px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        button:hover {
            background: #45a049;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="hero">
        <h1>🛠️ Admin Dashboard</h1>
        <p>Manage all insurance submissions</p>
    </div>

    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Crop Type</th>
            <th>Sum Insured</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <% for (Map<String, Object> sub : submissions) { %>
            <form method="post">
                <tr>
                    <td><%= sub.get("id") %></td>
                    <td><%= sub.get("username") %></td>
                    <td><input type="text" name="crop_type" value="<%= sub.get("crop_type") %>" required></td>
                    <td><input type="number" step="0.01" name="sum_insured" value="<%= sub.get("sum_insured") %>" required></td>
                    <td>
                        <select name="status">
                            <option value="Pending" <%= "Pending".equals(sub.get("status")) ? "selected" : "" %>>Pending</option>
                            <option value="Passed" <%= "Passed".equals(sub.get("status")) ? "selected" : "" %>>Passed</option>
                            <option value="Rejected" <%= "Rejected".equals(sub.get("status")) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </td>
                    <td>
                        <input type="hidden" name="id" value="<%= sub.get("id") %>">
                        <button type="submit">Update</button>
                    </td>
                </tr>
            </form>
        <% } %>
    </table>
</div>

</body>
</html>
