<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // JWT Token Management Script
    // This script handles JWT token storage and provides utility functions
%>
<script>
    // Store JWT token from session if available
    (function() {
        const token = '<%= session.getAttribute("jwt_token") != null ? session.getAttribute("jwt_token") : "" %>';
        if (token && token !== "") {
            localStorage.setItem('jwt_token', token);
            sessionStorage.setItem('jwt_token', token);
        }
    })();

    // Function to get JWT token for API calls
    function getAuthToken() {
        return localStorage.getItem('jwt_token') || sessionStorage.getItem('jwt_token');
    }

    // Function to set JWT token
    function setAuthToken(token) {
        localStorage.setItem('jwt_token', token);
        sessionStorage.setItem('jwt_token', token);
    }

    // Function to clear JWT token
    function clearAuthToken() {
        localStorage.removeItem('jwt_token');
        sessionStorage.removeItem('jwt_token');
    }

    // Function to check if user is authenticated
    function isAuthenticated() {
        return getAuthToken() !== null;
    }

    // Function to make authenticated API calls using fetch
    function authenticatedFetch(url, options = {}) {
        const token = getAuthToken();
        if (token) {
            options.headers = options.headers || {};
            options.headers['Authorization'] = 'Bearer ' + token;
        }
        return fetch(url, options);
    }

    // Function to make authenticated API calls using XMLHttpRequest
    function authenticatedXHR(method, url, data, callback) {
        const xhr = new XMLHttpRequest();
        const token = getAuthToken();

        xhr.open(method, url, true);
        if (token) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + token);
        }

        xhr.onload = function() {
            if (callback) callback(xhr);
        };

        xhr.onerror = function() {
            if (callback) callback(xhr);
        };

        if (data) {
            xhr.send(data);
        } else {
            xhr.send();
        }
    }

    // Function to handle logout
    function logout(redirectPage) {
        clearAuthToken();
        window.location.href = redirectPage || 'index.html';
    }

    // Auto-include JWT token in all fetch requests
    if (window.fetch) {
        const originalFetch = window.fetch;
        window.fetch = function(url, options = {}) {
            const token = getAuthToken();
            if (token) {
                options.headers = options.headers || {};
                options.headers['Authorization'] = 'Bearer ' + token;
            }
            return originalFetch(url, options);
        };
    }
</script>