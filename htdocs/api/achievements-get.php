<?php
/**
 * GET /api/achievements
 * Returns achievements with optional filtering
 */

require_once '../includes/config.php';
require_once '../includes/db.php';

header('Content-Type: application/json');

try {
    $db = new Database();
    $conn = $db->getConnection();
    
    // Base query
    $sql = "SELECT * FROM achievements WHERE 1=1";
    $params = [];
    $types = "";
    
    // Apply filters
    if (isset($_GET['associationId'])) {
        $sql .= " AND associationId = ?";
        $params[] = $_GET['associationId'];
        $types .= "s";
    }
    
    if (isset($_GET['type']) && $_GET['type'] !== 'all') {
        $sql .= " AND type = ?";
        $params[] = $_GET['type'];
        $types .= "s";
    }
    
    if (isset($_GET['year']) && $_GET['year'] !== 'all') {
        $sql .= " AND year = ?";
        $params[] = $_GET['year'];
        $types .= "s";
    }
    
    if (isset($_GET['search'])) {
        $sql .= " AND (athlete LIKE ? OR competition LIKE ? OR category LIKE ?)";
        $search = '%' . $_GET['search'] . '%';
        $params = array_merge($params, [$search, $search, $search]);
        $types .= "sss";
    }
    
    // Add ordering
    $sql .= " ORDER BY year DESC, id DESC";
    
    // Prepare and execute
    $stmt = $conn->prepare($sql);
    if ($types) {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    
    $result = $stmt->get_result();
    $achievements = [];
    
    while ($row = $result->fetch_assoc()) {
        $achievements[] = $row;
    }
    
    echo json_encode($achievements);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
