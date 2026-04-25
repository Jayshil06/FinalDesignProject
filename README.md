# 🎓 Online Placement Management System

The **Online Placement Management System** is a Java-based web application developed to automate and manage the campus placement process efficiently.

The system provides a centralized platform for **Students, Recruiters (Companies), and Admin** to manage placement activities seamlessly.

## 🚀 Quick Start

### Prerequisites
- Java Development Kit (JDK) 17 or higher
- Apache Tomcat 9.0 or higher
- MySQL Server 8.0 or higher
- NetBeans IDE (recommended)

### Setup Steps
1. **Clone/Download** the project
2. **Configure Database**:
   ```sql
   CREATE DATABASE design_engineering_portal;
   ```
3. **Update Credentials** in servlet files (database username/password)
4. **Configure JWT Secret Key** in `JwtUtil.java` (see JWT Configuration section)
5. **Build & Deploy** using NetBeans or Maven
6. **Access** at `http://localhost:8080/FinalDesignProject/`

### Default Access
- **Admin**: Use configured admin credentials
- **Company**: Register via company registration page
- **Student**: Register via student registration page

## 📌 Project Overview

This project simplifies the campus recruitment process by digitizing:

- Student registration and profile management
- Resume upload and download
- Company campus drive requests
- Job applications and tracking
- CGPA-based student filtering
- Admin approval and management
- **Secure JWT-based authentication** for all user types
- **Role-based access control** for enhanced security

The system reduces manual work and improves transparency in placement activities while maintaining robust security through modern authentication mechanisms.


## 👥 User Modules

### 👨‍🎓 Student Module
- Register and login (with JWT authentication)
- Manage profile
- Upload resume
- View company list
- Apply for jobs
- Track application status

### 🏢 Recruiter / Company Module
- Login to system (with JWT authentication)
- Request campus drive
- Add job details
- Filter students based on CGPA
- Shortlist candidates
- View applications
- Organize online aptitude tests

### 👨‍💼 Admin Module
- Admin login (with JWT authentication)
- Manage students
- Approve/reject company requests
- Manage company listings
- Monitor applications
- Download student resumes

## 🛠️ Technologies Used

### Frontend
- JSP (JavaServer Pages)
- HTML
- CSS
- JavaScript
- JWT Token Handling

### Backend
- Java Servlets
- JDBC (Java Database Connectivity)
- JWT Authentication (JSON Web Tokens)

### Database
- MySQL

### Server
- Apache Tomcat

### IDE
- NetBeans IDE

### Security & Authentication
- JWT (JSON Web Tokens) for stateless authentication
- Role-based access control (RBAC)
- Session-based authentication (backward compatibility)


## 🗂️ Project Structure

```
FinalDesignProject/
│
├── src/
│   ├── java/com/me/finaldesignproject/
│   │   ├── util/                          # Utility classes
│   │   │   └── JwtUtil.java              # JWT token generation/validation
│   │   ├── filter/                       # Security filters
│   │   │   └── JwtAuthenticationFilter.java  # JWT authentication filter
│   │   ├── *LoginServlet.java            # Login servlets (JWT-enabled)
│   │   ├── *LogoutServlet.java           # Logout servlets (JWT cleanup)
│   │   └── *Servlet.java                 # Other servlets
│   ├── webapp/
│   │   ├── js/
│   │   │   └── jwt-auth.js              # JWT authentication JavaScript library
│   │   ├── admin_login.jsp
│   │   ├── student_login.jsp
│   │   ├── company_login.jsp
│   │   ├── admin_home.jsp
│   │   ├── student_home.jsp
│   │   ├── company_home.jsp
│   │   └── *.jsp                         # Other JSP files
│
├── resumes/                              # Uploaded resume files
├── JWT_AUTHENTICATION.md                 # JWT authentication documentation
└── database.sql                          # Database structure (if included)
```

## 🔐 Authentication & Security

### JWT Authentication System

The system implements **JWT (JSON Web Token)** authentication for secure, stateless user authentication:

#### Features
- **Token-based Authentication**: Stateless authentication using JWT tokens
- **Role-based Authorization**: Three user roles with different access levels
  - **Admin**: Full system access and management
  - **Company**: Recruitment and application management
  - **Student**: Job applications and profile management
- **Secure Token Storage**: Tokens stored in localStorage/sessionStorage
- **Automatic Token Expiration**: 24-hour token lifetime for enhanced security
- **Backward Compatibility**: Maintains session-based authentication alongside JWT

#### Authentication Flow
1. User logs in via respective login page
2. Server validates credentials and generates JWT token
3. Token stored client-side and sent with subsequent requests
4. Server validates token on each protected endpoint
5. Access granted based on user role and permissions

#### Security Features
- **HMAC-SHA256** token signing algorithm
- **256-bit secret key** for token generation (configurable)
- **Role-based access control** on protected endpoints
- **Automatic token cleanup** on logout
- **Request validation** through authentication filter

#### Configuration
- **Secret Key**: Configure in `JwtUtil.java` (change for production!)
- **Token Expiration**: 24 hours (configurable in `JwtUtil.java`)
- **Protected Endpoints**: All `/admin/*`, `/company/*`, `/student/*` paths

For detailed implementation guide, see [JWT_AUTHENTICATION.md](JWT_AUTHENTICATION.md)

## 🗄️ Database Configuration

1. Install MySQL Server.
2. Create a database:

```sql
CREATE DATABASE design_engineering_portal;
```

3. Update database credentials inside your Servlet files:

```java
DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/design_engineering_portal",
    "root",
    "your_password"
);
```

## ⚙️ JWT Configuration

### Security Setup (Important!)

Before deploying to production, update the JWT security configuration:

1. **Update Secret Key** in `src/main/java/com/me/finaldesignproject/util/JwtUtil.java`:

```java
private static final String SECRET_KEY = "YOUR_SECURE_RANDOM_256_BIT_KEY_HERE";
```

2. **Configure Token Expiration** (optional):

```java
private static final long EXPIRATION_TIME = 86400000; // 24 hours in milliseconds
```

3. **Enable HTTPS** in production for secure token transmission

### Development Notes
- The current secret key is for development only
- Generate a secure random key for production deployment
- Consider using environment variables for sensitive configuration
- See [JWT_AUTHENTICATION.md](JWT_AUTHENTICATION.md) for detailed setup

## 🚀 How to Run the Project (Using NetBeans)

### Step 1: Install Required Software
- NetBeans IDE
- Apache Tomcat Server
- MySQL Server

### Step 2: Open Project in NetBeans
1. Open NetBeans.
2. Click **File → Open Project**.
3. Select the project folder.
4. Configure **Apache Tomcat** in Services if not already configured.

### Step 3: Configure Database
- Start MySQL server.
- Import or create required tables.
- Ensure database name and credentials match your code.

### Step 4: Run the Project
1. Right-click the project.
2. Click **Run**.
3. The project will deploy automatically on Tomcat.
4. Open in browser:

```
http://localhost:8080/FinalDesignProject/
```

## 🧪 Testing

The system was tested for:

### Functional Testing
- Registration & Login (with JWT authentication)
- JWT token generation and validation
- Role-based access control
- Resume Upload & Download
- Company Management
- Job Application Process
- CGPA Filtering
- Application Tracking

### Security Testing
- JWT token expiration handling
- Unauthorized access prevention
- Role-based authorization
- Token storage and cleanup
- Session management

### Integration Testing
- End-to-end user workflows
- Database operations
- Frontend-backend integration
- Error handling and validation

All modules were verified for correct functionality including JWT authentication.

## 💻 API Usage & Integration

### Frontend Integration

Include the JWT authentication library in your JSP pages:

```html
<script src="js/jwt-auth.js"></script>
```

### Making Authenticated Requests

```javascript
// Using the provided authentication library
authenticatedFetch('/api/protected-endpoint', {
    method: 'GET',
    headers: {
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => console.log(data));

// Check authentication status
if (isAuthenticated()) {
    // User is logged in
}

// Logout functionality
logout('login.jsp');
```

### Backend Integration

```java
// In protected servlets
String authHeader = request.getHeader("Authorization");
if (authHeader != null && authHeader.startsWith("Bearer ")) {
    String token = authHeader.substring(7);
    try {
        String role = JwtUtil.extractClaim(token, "role");
        int userId = JwtUtil.extractClaimAsInt(token, "user_id");

        // Process request with authenticated user
    } catch (Exception e) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid token");
    }
}
```

### Token Structure

JWT tokens contain the following claims:
- `sub`: User email (subject)
- `role`: User role (admin/company/student)
- `user_id`: User ID in database
- `name`: User name
- `iat`: Issued at timestamp
- `exp`: Expiration timestamp

For more details, see [JWT_AUTHENTICATION.md](JWT_AUTHENTICATION.md)

## ⚠️ Limitations

- **No email/SMS notifications** for application updates
- **Designed for institutional use only** (single organization)
- **Limited scalability** for very large concurrent user bases
- **No token refresh mechanism** (requires re-login after 24 hours)
- **Basic password security** (no password complexity requirements)
- **No two-factor authentication** support
- **Limited audit logging** for security events

**Note**: JWT authentication significantly improves security over the original session-based approach, but some advanced security features are not yet implemented.

## 🔮 Future Scope

### Planned Enhancements
- **Email/SMS notifications** for application status updates
- **Real-time alerts** for new job postings and application updates
- **Token refresh mechanism** for seamless user experience
- **Two-factor authentication** (2FA) for enhanced security
- **Password complexity requirements** and password reset functionality
- **Advanced analytics dashboard** with placement statistics
- **Integration with external job portals** (LinkedIn, Naukri, etc.)
- **Mobile application** for on-the-go access
- **Cloud deployment support** (AWS, Azure, Google Cloud)

### Security Improvements
- **Token blacklisting** for immediate logout across devices
- **IP-based token validation** for enhanced security
- **Device fingerprinting** for suspicious activity detection
- **Comprehensive audit logging** for security monitoring
- **Rate limiting** to prevent brute force attacks
- **HTTPS enforcement** for all communications

### User Experience
- **Remember me functionality** with extended token lifetime
- **Multi-device session management**
- **Profile customization** and user preferences
- **Advanced search and filtering** for job listings
- **Interview scheduling** and calendar integration

### Scalability
- **Load balancing** for high-traffic scenarios
- **Database optimization** for large datasets
- **Caching layer** for improved performance
- **Microservices architecture** for better modularity

## 🐛 Troubleshooting

### Common Issues

#### JWT Token Issues
- **Problem**: "Invalid or expired token" error
- **Solution**: Check token expiration, verify secret key configuration, ensure token format is correct

#### Database Connection Issues
- **Problem**: "Database error: Access denied"
- **Solution**: Verify MySQL credentials, check database exists, ensure MySQL service is running

#### Compilation Errors
- **Problem**: JWT classes not found
- **Solution**: Ensure JWT dependencies are in `pom.xml`, run `mvn clean install`

#### Authentication Filter Issues
- **Problem**: Protected endpoints not requiring authentication
- **Solution**: Check `@WebFilter` annotation, verify URL patterns in filter configuration

#### Frontend Token Storage
- **Problem**: Tokens not being stored after login
- **Solution**: Check browser console for JavaScript errors, verify localStorage/sessionStorage is enabled

### Getting Help

- Check [JWT_AUTHENTICATION.md](JWT_AUTHENTICATION.md) for detailed JWT implementation guide
- Review server logs for detailed error messages
- Verify all configuration files are properly set up
- Ensure all dependencies are correctly installed

## 📚 Documentation

- **[JWT_AUTHENTICATION.md](JWT_AUTHENTICATION.md)**: Comprehensive JWT authentication implementation guide
- **[README.md](README.md)**: This file - project overview and setup guide
- **Code Comments**: Detailed inline documentation in source files

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is developed for educational purposes. Please contact the developer for licensing information.

## 👨‍💻 Developed By

**Jayshil**

### Project Information
- **Version**: 2.0 (with JWT Authentication)
- **Last Updated**: April 2026
- **Status**: Production Ready (with security configuration)

### Acknowledgments
- JWT library by [io.jsonwebtoken](https://github.com/jwtk/jjwt)
- Jakarta EE platform
- Apache Tomcat community
- MySQL database community

---

**Note**: This project implements modern JWT authentication while maintaining backward compatibility with existing session-based authentication. For production deployment, ensure proper security configuration including HTTPS, secure secret keys, and appropriate token expiration settings.  
