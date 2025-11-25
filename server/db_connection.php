<?php

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "pawpal_db";
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die(json_encode(['status' => 'error', 'message' => 'Database error']));
    }

    function sendJsonResponse($sentArray){
        header('Content-Type: application/json');
        echo json_encode($sentArray);
        exit;
    }

?>