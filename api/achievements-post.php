<?php
/**
 * POST /submit-achievement
 * Handles achievement form submission with file upload
 */

require_once '../includes/config.php';
require_once '../includes/db.php';

header('Content-Type: application/json');

// Remove any JSON content type from POST
if ($_SERVER['CONTENT_TYPE'] === 'application/json') {
    $_POST = json_decode(file_get_contents('php://input'), true);
}

try {
    // Validate required fields
    $required = ['athlete', 'competition', 'category', 'achievement', 'year', 'type', 'associationId'];
    foreach ($required as $field) {
        if (!isset($_POST[$field]) || empty($_POST[$field])) {
            http_response_code(400);
            echo json_encode(['error' => "Missing required field: $field"]);
            exit;
        }
    }
    
    // Validate association ID
    $associationId = $_POST['associationId'];
    if (!preg_match('/^KA[0-9]{3}$/', $associationId)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid Association ID format. Must be KA followed by 3 digits']);
        exit;
    }
    
    // Handle file upload
    $imagePath = '';
    if (isset($_FILES['achievementImage']) && $_FILES['achievementImage']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = '../uploads/';
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }
        
        $file = $_FILES['achievementImage'];
        $filename = time() . '-' . basename($file['name']);
        $uploadPath = $uploadDir . $filename;
        
        // Validate file type
        $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
        if (!in_array($file['type'], $allowedTypes)) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid file type. Only JPG, PNG, GIF allowed']);
            exit;
        }
        
        // Validate file size (max 5MB)
        if ($file['size'] > 5 * 1024 * 1024) {
            http_response_code(400);
            echo json_encode(['error' => 'File too large. Maximum 5MB allowed']);
            exit;
        }
        
        if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
            $imagePath = '/uploads/' . $filename;
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'File upload failed']);
            exit;
        }
    }
    
    // Extract medal from achievement text
    $achievementText = strtolower($_POST['achievement']);
    $medal = '';
    if (strpos($achievementText, 'gold') !== false) $medal = 'gold';
    elseif (strpos($achievementText, 'silver') !== false) $medal = 'silver';
    elseif (strpos($achievementText, 'bronze') !== false) $medal = 'bronze';
    
    // Insert into database
    $db = new Database();
    $conn = $db->getConnection();
    
    $sql = "INSERT INTO achievements (athlete, competition, category, achievement, year, type, medal, associationId, image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param(
        "sssssssss",
        $_POST['athlete'],
        $_POST['competition'],
        $_POST['category'],
        $_POST['achievement'],
        $_POST['year'],
        $_POST['type'],
        $medal,
        $_POST['associationId'],
        $imagePath
    );
    
    if ($stmt->execute()) {
        // Redirect to member achievements page
        $redirectUrl = SITE_URL . "/member-achievements.html?associationId=" . urlencode($associationId) . "&success=1";
        echo json_encode(['success' => true, 'redirect' => $redirectUrl]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to save achievement']);
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Server error: ' . $e->getMessage()]);
}
