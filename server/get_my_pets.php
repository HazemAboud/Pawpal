<?php
include 'db_connection.php';
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    try{
        $stmt = $conn->prepare("SELECT * FROM tbl_pets");
        $stmt->execute();

        $result = $stmt->get_result();
        $pets = [];

        while ($row = $result->fetch_assoc()) {
            $row['image_paths'] = json_decode($row['image_paths'], true);
            $pets[] = $row;
        }

        if (empty($pets)) {
           sendJsonResponse([
                'success' => true,
                'message' => 'No submissions yet',
            ]);
        } else {
            sendJsonResponse([
                'success' => true,
                'message' => 'Fetched successfully',
                'data' => $pets
            ]);
        }

        $stmt->close();
        $conn->close();

    } catch (Exception $e) {
        http_response_code(500);
        sendJsonResponse([
            'success' => false,
            'message' => 'An error occurred: ' . $e->getMessage()
        ]);
    }
} else {
    http_response_code(400);
    sendJsonResponse([
        'success' => false,
        'message' => 'Invalid Request'
    ]);
}
?>
