<?php
include 'db_connection.php';
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        $user_id = $_POST['user_id'];
        $pet_name = $_POST['pet_name'];
        $pet_type = $_POST['pet_type'];
        $category = $_POST['category'];
        $description = $_POST['description'];
        $lat = $_POST['lat'];
        $lng = $_POST['lng'];
        $images = $_POST['images']; 

        //image
        $imagePaths = [];
        $counter = 0;
        $imagesArray =json_decode($images);
            foreach ($imagesArray as $imgBase64) {
                $decodedImage = base64_decode($imgBase64);
                $filename = $user_id . '_' . $pet_name . '_'. $counter . '_' . time() . '.png';
                $filePath = "uploads/" . $filename;

                file_put_contents($filePath, $decodedImage);
                $imagePaths[] = $filePath;
                $counter++;
            }
        
        $counter = 0;
        $imagesJson = json_encode($imagePaths);

        $stmt = $conn->prepare("INSERT INTO tbl_pets (user_id, pet_name, pet_type, category, description, image_paths, lat, lng, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())");
        $stmt->bind_param("isssssss", $user_id, $pet_name, $pet_type, $category, $description, $imagesJson, $lat, $lng);

        if ($stmt->execute()) {
            http_response_code(200);
            sendJsonResponse([
                'success' => true,
                'message' => 'Pet submitted successfully'
            ]);
        } else {
            http_response_code(500);
            sendJsonResponse([
                'success' => false,
                'message' => 'Pet submition failed'
            ]);
        }

        $stmt->close();
        $conn->close();

    }catch (Exception $e){
        http_response_code(500);
        sendJsonResponse([
            'success' => false,
            'message' => 'An error occurred: ' . $e->getMessage()
        ]);
    }
}else {
    http_response_code(400);
    sendJsonResponse(['success' => false, 'message' => 'Invalid Request']);
}


?>
