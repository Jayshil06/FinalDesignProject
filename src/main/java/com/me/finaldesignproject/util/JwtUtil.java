package com.me.finaldesignproject.util;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtUtil {

    private static final String SECRET_KEY = "YourSecretKeyForJWTTokenGenerationMustBeAtLeast256BitsLong";
    private static final long EXPIRATION_TIME = 86400000; // 24 hours in milliseconds

    private static Key getSigningKey() {
        return Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    }

    public static String generateToken(String subject, Map<String, Object> claims) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME);

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public static Claims validateToken(String token) throws JwtException {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public static String extractSubject(String token) throws JwtException {
        return validateToken(token).getSubject();
    }

    public static boolean isTokenExpired(String token) {
        try {
            Claims claims = validateToken(token);
            return claims.getExpiration().before(new Date());
        } catch (JwtException e) {
            return true;
        }
    }

    public static String extractClaim(String token, String claimName) throws JwtException {
        Claims claims = validateToken(token);
        return claims.get(claimName, String.class);
    }

    public static int extractClaimAsInt(String token, String claimName) throws JwtException {
        Claims claims = validateToken(token);
        return claims.get(claimName, Integer.class);
    }
}