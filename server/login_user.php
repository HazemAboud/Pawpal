<?php
    include 'db_connection.php';
    header("Access-Control-Allow-Origin: *");

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $email = $_POST['email'];
        $password = $_POST['password'];
        $hashedpassword = sha1($password);

        $sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";

        try {
            $result = $conn->query($sqlcheckmail);
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                if ($row['password'] === $hashedpassword) {
                    sendJsonResponse([
                        'status' => 'success',
                        'message' => 'Login successful',
                        'user' => $row
                    ]);
                } else {
                    http_response_code(400);
                    sendJsonResponse([
                        'status' => 'error',
                        'message' => 'Incorrect password.'
                    ]);
                }
            } else {
                http_response_code(400);
                sendJsonResponse([
                    'status' => 'error',
                    'message' => 'Email not registered.'
                ]);
            }
        } catch (Exception $e) {
            http_response_code(500);
            sendJsonResponse([
                'status' => 'error',
                'message' => 'An error occurred: ' . $e->getMessage()
            ]);
        }
    } else {
        http_response_code(400);
        sendJsonResponse(['error' => 'Invalid Request']);
    }
?>