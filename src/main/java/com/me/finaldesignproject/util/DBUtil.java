package com.me.finaldesignproject.util;

import java.sql.*;

/**
 * Utility class for managing database connections and resources.
 */
public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/design_engineering_portal";
    private static final String USER = "root";
    private static final String PASS = "root";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Returns a new connection to the database.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Safely closes the given database resources.
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("Error closing ResultSet: " + e.getMessage());
        }
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing Statement: " + e.getMessage());
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing Connection: " + e.getMessage());
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
