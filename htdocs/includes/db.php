<?php
/**
 * Database Connection Class for MySQLi (compatible with PHP 7+)
 * Works with InfinityFree hosting
 */

class Database {
    private $conn;
    
    public function __construct() {
        // Attempt connection
        $this->conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        
        // Check connection
        if ($this->conn->connect_error) {
            die("Connection failed: Error code " . $this->conn->connect_errno . 
                " - " . $this->conn->connect_error);
        }
        
        // Set charset
        $this->conn->set_charset(DB_CHARSET);
    }
    
    public function getConnection() {
        return $this->conn;
    }
    
    // Utility method for prepared statements
    public function query($sql, $params = [], $types = "") {
        $stmt = $this->conn->prepare($sql);
        if (!$stmt) {
            return false;
        }
        
        if ($params) {
            $stmt->bind_param($types, ...$params);
        }
        
        $stmt->execute();
        return $stmt;
    }
    
    // Fetch all results as associative array
    public function fetchAll($stmt) {
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
    // Fetch single row
    public function fetchOne($stmt) {
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }
    
    // Get last insert ID
    public function lastInsertId() {
        return $this->conn->insert_id;
    }
}