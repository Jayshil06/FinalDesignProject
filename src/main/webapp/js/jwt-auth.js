// JWT Authentication Utility Functions

// Function to get JWT token from storage
function getAuthToken() {
    return localStorage.getItem('jwt_token') || sessionStorage.getItem('jwt_token');
}

// Function to set JWT token in storage
function setAuthToken(token) {
    localStorage.setItem('jwt_token', token);
    sessionStorage.setItem('jwt_token', token);
}

// Function to clear JWT token from storage (for logout)
function clearAuthToken() {
    localStorage.removeItem('jwt_token');
    sessionStorage.removeItem('jwt_token');
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

// Function to check if user is authenticated
function isAuthenticated() {
    return getAuthToken() !== null;
}

// Function to redirect to login if not authenticated
function requireAuthentication(loginPage) {
    if (!isAuthenticated()) {
        window.location.href = loginPage || 'login.jsp';
        return false;
    }
    return true;
}

// Function to handle logout
function logout(redirectPage) {
    clearAuthToken();
    window.location.href = redirectPage || 'login.jsp';
}

// Auto-include JWT token in all fetch requests (optional)
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

// Add event listener for page load to check authentication
window.addEventListener('load', function() {
    // Check if current page requires authentication
    const requiresAuth = document.body.getAttribute('data-requires-auth');
    if (requiresAuth === 'true' && !isAuthenticated()) {
        const loginPage = document.body.getAttribute('data-login-page') || 'login.jsp';
        window.location.href = loginPage;
    }
});