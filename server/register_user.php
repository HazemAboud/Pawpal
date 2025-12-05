<?php
    include 'db_connection.php';
    header("Access-Control-Allow-Origin: *");

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {

        $name = $_POST['name'];
        $email = $_POST['email'];
        $password = $_POST['password'];
        $phone = $_POST['phone'];
        $sqlcheckmail = "SELECT * FROM `tbl_users` WHERE `email` = '$email'";

        try{
            $result = $conn->query($sqlcheckmail);
            if ($result->num_rows > 0) {
                http_response_code(400);
                $response = array('status' => 'error', 'message' => 'Email already registered.');
                sendJsonResponse($response);
                exit;
            }else{
                $hashedpassword = sha1($password);
                $sqladduser = "INSERT INTO `tbl_users` (`name`, `email`, `password`, `phone`) 
                VALUES ('$name', '$email', '$hashedpassword', '$phone')";
                if($conn->query($sqladduser)){
                    $response = array('status' => 'success', 'message' => 'Registered successfully.');
                } else {
                    $response = array('status' => 'error', 'message' => 'Registration failed.');
                }
            }
        }catch(Exception $e){
            http_response_code(400);
            $response = array('status' => 'error', 'message' => 'An error occurred: ' . $e->getMessage());
            sendJsonResponse($response);
            exit;
        }

    }else {
        http_response_code(400);
		sendJsonResponse(array('error' => 'Invalid Request'));
        exit();
    }
    $conn->close();
    sendJsonResponse($response);

?>