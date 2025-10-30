<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String user = (String) session.getAttribute("user");
    boolean isLoggedIn = user != null;

    // Handle logout if requested
    if ("true".equals(request.getParameter("logout"))) {
        session.invalidate();
        response.sendRedirect("home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crop Insurance Home - Secure Your Harvest</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        /* Farmer-themed styles: Earthy colors, farm background */
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background: linear-gradient(to bottom, #87CEEB 0%, #98FB98 50%, #D2B48C 100%); /* Sky to field to soil */
            margin: 0;
            padding: 0;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
            line-height: 1.6;
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }

        /* Hero Section */
        .hero {
            text-align: center;
            padding: 60px 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            animation: fadeIn 1s ease-in;
        }

        .hero h1 {
            color: #2E7D32; /* Dark green */
            font-size: 36px;
            margin-bottom: 10px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }

        .hero p {
            font-size: 18px;
            color: #8B4513; /* Brown */
            margin-bottom: 20px;
        }

        .welcome {
            color: #4CAF50;
            font-size: 20px;
            margin-bottom: 20px;
            animation: fadeIn 1.5s ease-in;
        }

        /* Feature Cards */
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 2px solid #4CAF50;
            animation: fadeInUp 1s ease-out forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(76, 175, 80, 0.3);
        }

        .card h3 {
            color: #2E7D32;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .card a {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(to right, #4CAF50, #45a049);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .card a:hover {
            background: linear-gradient(to right, #45a049, #2E7D32);
        }

        /* FAQ Section */
        .faq {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 40px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .faq h2 {
            color: #2E7D32;
            text-align: center;
            margin-bottom: 20px;
        }

        .faq-item {
            margin-bottom: 15px;
            border: 1px solid #D2B48C;
            border-radius: 10px;
            overflow: hidden;
        }

        .faq-question {
            background: #4CAF50;
            color: white;
            padding: 15px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .faq-question:hover {
            background: #45a049;
        }

        .faq-answer {
            padding: 0;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease;
            background: #F5F5DC;
        }

        .faq-answer.show {
            padding: 15px;
            max-height: 200px;
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
            font-size: 40px;
            animation: driveAcross 10s linear infinite;
        }

        .bullock-cart {
            position: absolute;
            top: 60px;
            left: -120px;
            font-size: 30px;
            animation: cartAcross 15s linear infinite reverse;
        }

        @keyframes driveAcross {
            0% { transform: translateX(-100px); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateX(calc(100vw + 100px)); opacity: 0; }
        }

        @keyframes cartAcross {
            0% { transform: translateX(-120px); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateX(calc(100vw + 120px)); opacity: 0; }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 { font-size: 28px; }
            .features { grid-template-columns: 1fr; }
            .farm-animation { display: none; }
        }
    </style>
</head>
<body>
    <!-- Farm Animations -->
    <div class="farm-animation">
        <div class="tractor">🚜</div>
    </div>
    <div class="bullock-cart">🐂🚜</div>

    <div class="container">
        <!-- Hero Section -->
        <section class="hero">
            <h1>🌾 Welcome to Crop Insurance Portal</h1>
            <p>Protect your hard-earned harvest with reliable insurance. Simple, secure, and farmer-friendly.</p>
            <% if (isLoggedIn) { %>
                <p class="welcome">👋 Hello, <%= user %>! You're ready to manage your policies.</p>
            <% } else { %>
                <p class="welcome">Join thousands of farmers securing their future today.</p>
            <% } %>
        </section>

        <!-- Feature Cards -->
        <section class="features">
            <% if (isLoggedIn) { %>
                <div class="card">
                    <h3>📋 Dashboard</h3>
                    <p>View your insurance status and history.</p>
                    <a href="dashboard.jsp">Go to Dashboard</a>
                </div>
                <div class="card">
                    <h3>📝 Submit Insurance</h3>
                    <p>Apply for new crop coverage quickly.</p>
                    <a href="insuranceForm.jsp">Submit Now</a>
                </div>
                <div class="card">
                    <h3>📞 Contact Us</h3>
                    <p>Get help from our support team.</p>
                    <a href="contact.jsp">Reach Out</a>
                </div>
                <div class="card">
                    <h3>🚪 Logout</h3>
                    <p>Securely sign out of your account.</p>
                    <a href="home.jsp?logout=true">Logout</a>
                </div>
            <% } else { %>
                <div class="card">
                    <h3>🆕 Register</h3>
                    <p>Create your free farmer account.</p>
                    <a href="register.jsp">Sign Up</a>
                </div>
                <div class="card">
                    <h3>🔑 Login</h3>
                    <p>Access your dashboard and policies.</p>
                    <a href="login.jsp">Login</a>
                </div>
                <div class="card">
                    <h3>📝 Insurance Form</h3>
                    <p>Start your application (login required).</p>
                    <a href="login.jsp">Login to Submit</a>
                </div>
                
                <div class="card">
                    <h3>📞 Contact Us</h3>
                    <p>Questions? We're here to help.</p>
                    <a href="contact.jsp">Contact Support</a>
                </div>
                
            <% } %>
        </section>

        <!-- FAQ Section (Additional Function) -->
        <section class="faq">
            <h2>❓ Frequently Asked Questions</h2>
            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">What is crop insurance?</div>
                <div class="faq-answer">Crop insurance protects farmers from losses due to natural disasters, pests, or price fluctuations. It's government-backed in many regions.</div>
            </div>
            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">How do I apply?</div>
                <div class="faq-answer">Register or login, then fill out the insurance form with your crop details. Approval is quick!</div>
            </div>
            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">What documents do I need?</div>
                <div class="faq-answer">Basic info like crop type, area, and yield estimates. No uploads required for initial quote.</div>
            </div>
            <div class="faq-item">
                <div class="faq-question"><a href="admin_login.jsp"">Admin Login</a>
                    
                
            </div>
        </section>
        
    </div>

    <script>
        // FAQ Toggle Function (Additional UX)
        function toggleFAQ(element) {
            const answer = element.nextElementSibling;
            answer.classList.toggle('show');
        }

        // Stagger card animations on load
        window.addEventListener('load', () => {
            document.querySelectorAll('.card').forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });
    </script>
</body>
</html>