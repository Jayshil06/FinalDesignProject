<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact Us - 𝕿𝔞𝔩𝔢𝔫𝔱𝕹𝔢𝔰𝔱</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      transition: all 0.3s ease;
    }

    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #0c0c36, #123456, #1c5d82);
      color: #e0e0e0;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      position: relative;
      cursor: url('https://www.google.com/cse/static/arrow.cur'), auto;
    }

    body::before {
      content: "";
      position: fixed;
      top: 50%;
      left: 50%;
      width: 700px;
      height: 700px;
      background: url('images/handshake-logo.jpg') no-repeat center center;
      background-size: cover;
      border-radius: 50%;
      opacity: 0.08;
      transform: translate(-50%, -50%) scale(1);
      z-index: 0;
      pointer-events: none;
      animation: pulse 12s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { transform: translate(-50%, -50%) scale(1); }
      50% { transform: translate(-50%, -50%) scale(1.07); }
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(255, 255, 255, 0.07);
      padding: 14px 40px;
      margin: 20px;
      border-radius: 15px;
      z-index: 1;
      animation: fadeInHeader 1s ease-out;
    }

    @keyframes fadeInHeader {
      0% { opacity: 0; transform: translateY(-20px); }
      100% { opacity: 1; transform: translateY(0); }
    }

    .logo-container {
      display: flex;
      align-items: center;
      gap: 10px;
      animation: slideInLogo 1s ease-out;
    }

    @keyframes slideInLogo {
      0% { opacity: 0; transform: translateX(-50px); }
      100% { opacity: 1; transform: translateX(0); }
    }

    .logo-container img {
      width: 70px;
      height: 70px;
      object-fit: cover;
      border-radius: 12px;
      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
    }

    .logo-container h1 {
      font-size: 24px;
      font-weight: 700;
      color: #ffffff;
      letter-spacing: 1px;
    }

    nav {
      display: flex;
      align-items: center;
      gap: 25px;
    }

    nav a {
      color: #e0e0e0;
      text-decoration: none;
      font-weight: 500;
      font-size: 16px;
      position: relative;
    }

    nav a:hover {
      color: #1abc9c;
    }

    nav a:hover::before {
      content: '';
      position: absolute;
      bottom: -5px;
      left: 0;
      width: 100%;
      height: 2px;
      background-color: #1abc9c;
      animation: underlineEffect 0.3s ease-in-out forwards;
    }

    @keyframes underlineEffect {
      0% { width: 0; }
      100% { width: 100%; }
    }

    .login-btn {
      background-color: #00b894;
      padding: 8px 18px;
      border-radius: 8px;
      text-decoration: none;
      color: white;
      font-weight: 600;
      font-size: 16px;
      transition: background-color 0.3s;
    }

    .login-btn:hover {
      background-color: #00a383;
      transform: scale(1.05);
    }

    main {
      flex: 1;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 60px 20px;
      position: relative;
      z-index: 1;
    }

    .contact-box {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      border-radius: 16px;
      padding: 40px;
      max-width: 600px;
      width: 100%;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
      animation: fadeIn 1s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .contact-box h2 {
      font-size: 28px;
      margin-bottom: 20px;
      color: #ffdd57;
      text-align: center;
    }

    .contact-box p {
      font-size: 17px;
      line-height: 1.6;
      margin-bottom: 12px;
      color: #dddddd;
    }

    .contact-box a {
      color: #1abc9c;
      text-decoration: none;
    }

    .contact-box a:hover {
      text-decoration: underline;
    }

    footer {
      text-align: center;
      padding: 30px 0;
      font-size: 14px;
      color: #aaaaaa;
      background-color: rgba(0, 0, 0, 0.15);
      margin-top: 40px;
      opacity: 0;
      transform: translateY(80px);
      animation: slideUp 1.3s ease-out forwards;
      animation-delay: 1.2s;
    }

    @keyframes slideUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (max-width: 768px) {
      nav {
        flex-direction: column;
        gap: 10px;
      }

      .contact-box {
        padding: 20px;
      }

      .contact-box h2 {
        font-size: 24px;
      }
    }
  </style>
</head>
<body>
  <header>
    <div class="logo-container">
      <img src="images/handshake-logo.jpg" alt="TalentNest Logo">
      <h1>𝕿𝔞𝔩𝔢𝔫𝔱𝕹𝔢𝔰𝔱</h1>
    </div>
    <nav>
      <a href="index.html">Home</a>
      <a href="aboutus.jsp">About Us</a>
      <a href="contactus.jsp">Contact</a>
      <a href="login.jsp" class="login-btn">Login/Sign Up</a>
    </nav>
  </header>

  <main>
    <div class="contact-box">
      <h2>Get in Touch</h2>
      <p>We'd love to hear from you! If you have any questions, feedback, or partnership inquiries, feel free to reach out.</p>
      <p><strong>Email:</strong> <a href="mailto:placement@ldrp.ac.in">placement@ldrp.ac.in</a></p>
      <p><strong>Address:</strong> LDRP-ITR, Gandhinagar, Gujarat, India</p>
      <p><strong>Phone:</strong> +91 12345 67890</p>
    </div>
  </main>

  <footer>
    <p>© 2026 TalentNest. All rights reserved.</p>
    <p>LDRP-ITR, Gandhinagar, Gujarat, India</p>
    <p><a href="mailto:placement@ldrp.ac.in">Contact Us: placement@ldrp.ac.in</a></p>
  </footer>
</body>
</html>
