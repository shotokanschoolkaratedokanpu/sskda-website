<?php
/**
 * GET /api/championship-registrations
 * Returns championship registrations with optional filtering
 */

require_once '../includes/config.php';
require_once '../includes/db.php';

header('Content-Type: application/json');

try {
    $db = new Database();
    $conn = $db->getConnection();
    
    $sql = "SELECT * FROM championship_registrations WHERE 1=1";
    $params = [];
    $types = "";
    
    if (isset($_GET['associationId'])) {
        $sql .= " AND associationId = ?";
        $params[] = $_GET['associationId'];
        $types .= "s";
    }
    
    $sql .= " ORDER BY registrationDate DESC";
    
    $stmt = $conn->prepare($sql);
    if ($types) {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    
    $result = $stmt->get_result();
    $registrations = [];
    
    while ($row = $result->fetch_assoc()) {
        $registrations[] = $row;
    }
    
    echo json_encode($registrations);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
