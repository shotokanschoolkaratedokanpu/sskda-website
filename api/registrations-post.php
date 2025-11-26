<?php
/**
 * POST /api/championship-registration
 * Handles championship registration form submission
 */

require_once '../includes/config.php';
require_once '../includes/db.php';

header('Content-Type: application/json');

try {
    // Parse JSON input
    $data = json_decode(file_get_contents('php://input'), true);
    if (!$data) {
        $data = $_POST; // Fallback to form data
    }
    
    // Validate required fields
    $required = ['firstName', 'lastName', 'dob', 'gender', 'email', 'phone', 'associationId', 'belt', 'category', 'ageGroup', 'emergencyName', 'emergencyPhone'];
    foreach ($required as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            http_response_code(400);
            echo json_encode(['error' => "Missing required field: $field"]);
            exit;
        }
    }
    
    // Validate association ID format
    if (!preg_match('/^KA[0-9]{3}$/', $data['associationId'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid Association ID format. Must be KA followed by 3 digits']);
        exit;
    }
    
    // Generate registration ID
    $registrationId = 'CHAMP' . time();
    
    // Insert into database
    $db = new Database();
    $conn = $db->getConnection();
    
    $sql = "INSERT INTO championship_registrations (
        firstName, lastName, dob, gender, email, phone, associationId, belt, category, ageGroup, emergencyName, emergencyPhone, registrationId
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param(
        "sssssssssssss",
        $data['firstName'],
        $data['lastName'],
        $data['dob'],
        $data['gender'],
        $data['email'],
        $data['phone'],
        $data['associationId'],
        $data['belt'],
        $data['category'],
        $data['ageGroup'],
        $data['emergencyName'],
        $data['emergencyPhone'],
        $registrationId
    );
    
    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Registration successful',
            'registrationId' => $registrationId
        ]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to save registration']);
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
