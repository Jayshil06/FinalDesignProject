# JWT Authentication Implementation

## Overview
This document describes the JWT (JSON Web Token) authentication implementation added to the Online Placement Management System.

## Architecture

### Components Added

1. **JWT Utility Class** (`JwtUtil.java`)
   - Location: `src/main/java/com/me/finaldesignproject/util/JwtUtil.java`
   - Functions:
     - Token generation with custom claims
     - Token validation
     - Claim extraction
     - Expiration checking

2. **Authentication Filter** (`JwtAuthenticationFilter.java`)
   - Location: `src/main/java/com/me/finaldesignproject/filter/JwtAuthenticationFilter.java`
   - Functions:
     - Intercepts requests to protected endpoints
     - Validates JWT tokens
     - Sets user information in request attributes
     - Handles unauthorized access

3. **Frontend JavaScript Library** (`jwt-auth.js`)
   - Location: `src/main/webapp/js/jwt-auth.js`
   - Functions:
     - Token storage management
     - Authenticated fetch/XHR wrappers
     - Authentication checking
     - Logout functionality

## Updated Components

### Login Servlets
All login servlets have been updated to generate JWT tokens:

1. **AdminLoginServlet.java**
   - Generates JWT token with admin role
   - Sets token in response header
   - Stores token in session for backward compatibility

2. **CompanyLoginServlet.java**
   - Generates JWT token with company role
   - Sets token in response header
   - Stores token in session for backward compatibility

3. **StudentLoginServlet.java**
   - Generates JWT token with student role
   - Sets token in response header
   - Stores token in session for backward compatibility

### Logout Servlets
All logout servlets have been updated to clear JWT tokens:

1. **AdminLogoutServlet.java**
2. **CompanyLogoutServlet.java**
3. **LogoutServlet.java**

### Protected Servlets
Protected servlets have been updated to validate JWT tokens:

1. **CompanyApplicationsServlet.java**
   - Validates JWT token
   - Checks role authorization
   - Extracts user ID from token

2. **AdminStudentListServlet.java**
   - Validates JWT token
   - Checks admin role authorization

### Frontend Pages
Login pages have been updated to handle JWT tokens:

1. **admin_login.jsp**
2. **company_login.jsp**
3. **student_login.jsp**

## JWT Token Structure

### Token Claims
- `sub`: User email (subject)
- `role`: User role (admin/company/student)
- `user_id`: User ID in database
- `name`: User name
- Additional role-specific claims

### Token Configuration
- **Algorithm**: HS256
- **Secret Key**: 256-bit key (should be changed in production)
- **Expiration**: 24 hours
- **Issuer**: Not specified (can be added)

## Security Features

1. **Token-based Authentication**
   - Stateless authentication
   - No session storage required on server
   - Scalable architecture

2. **Role-based Authorization**
   - Admin, Company, and Student roles
   - Role checking in protected endpoints
   - Access control based on user role

3. **Token Expiration**
   - 24-hour token lifetime
   - Automatic token expiration handling
   - Secure token refresh mechanism (can be implemented)

4. **Secure Storage**
   - Tokens stored in localStorage and sessionStorage
   - Automatic token clearing on logout
   - Client-side token management

## Usage Examples

### Frontend Usage

```javascript
// Include the JWT auth library
<script src="js/jwt-auth.js"></script>

// Make authenticated API call
authenticatedFetch('/api/protected-endpoint', {
    method: 'GET',
    headers: {
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => console.log(data));

// Check if user is authenticated
if (isAuthenticated()) {
    // User is logged in
}

// Logout
logout('login.jsp');
```

### Backend Usage

```java
// In a protected servlet
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
} else {
    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token required");
}
```

## Configuration

### Secret Key
The secret key is defined in `JwtUtil.java`:
```java
private static final String SECRET_KEY = "YourSecretKeyForJWTTokenGenerationMustBeAtLeast256BitsLong";
```

**IMPORTANT**: Change this to a secure, random key in production!

### Token Expiration
Token expiration is defined in `JwtUtil.java`:
```java
private static final long EXPIRATION_TIME = 86400000; // 24 hours in milliseconds
```

## Testing

### Manual Testing Steps

1. **Test Login Flow**
   - Navigate to login page
   - Enter valid credentials
   - Verify JWT token is generated and stored
   - Check token in browser DevTools (Application > Local Storage)

2. **Test Protected Endpoints**
   - Try accessing protected endpoint without token
   - Verify 401 Unauthorized response
   - Access with valid token
   - Verify successful response

3. **Test Token Expiration**
   - Wait for token to expire (or reduce expiration time for testing)
   - Try accessing protected endpoint
   - Verify 401 Unauthorized response

4. **Test Logout**
   - Login successfully
   - Click logout
   - Verify token is cleared from storage
   - Try accessing protected endpoint
   - Verify redirect to login page

### Automated Testing

Create test cases for:
- Token generation
- Token validation
- Token expiration
- Role-based authorization
- Protected endpoint access

## Deployment Considerations

### Production Checklist

1. **Security**
   - Change JWT secret key to a secure, random value
   - Use HTTPS for all communications
   - Implement token refresh mechanism
   - Add rate limiting to prevent brute force attacks

2. **Configuration**
   - Move secret key to environment variables
   - Configure appropriate token expiration time
   - Set up secure cookie options if using cookies

3. **Monitoring**
   - Log authentication attempts
   - Monitor for suspicious activity
   - Track token usage patterns

4. **Scalability**
   - Consider using a distributed cache for token blacklisting
   - Implement token revocation if needed
   - Plan for token refresh strategy

## Troubleshooting

### Common Issues

1. **Token Not Generated**
   - Check login servlet is updated
   - Verify JWT dependencies are in pom.xml
   - Check for compilation errors

2. **Token Validation Fails**
   - Verify secret key matches between generation and validation
   - Check token hasn't expired
   - Ensure token format is correct

3. **CORS Issues**
   - Configure CORS headers if using separate frontend
   - Ensure proper preflight handling

4. **Token Not Sent in Requests**
   - Verify frontend JavaScript is including token
   - Check token storage is working
   - Ensure authenticatedFetch is being used

## Future Enhancements

1. **Token Refresh**
   - Implement refresh token mechanism
   - Add refresh endpoint
   - Handle token renewal automatically

2. **Enhanced Security**
   - Add token blacklisting for logout
   - Implement IP-based token validation
   - Add device fingerprinting

3. **Improved User Experience**
   - Remember me functionality
   - Multi-device support
   - Session management UI

4. **Monitoring and Analytics**
   - Authentication event logging
   - Security event tracking
   - User activity monitoring

## Dependencies

Added to `pom.xml`:
```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

## Conclusion

The JWT authentication implementation provides a secure, scalable authentication mechanism for the Online Placement Management System. It maintains backward compatibility with existing session-based authentication while adding modern token-based authentication capabilities.

For questions or issues, refer to the troubleshooting section or consult the JWT specification and library documentation.