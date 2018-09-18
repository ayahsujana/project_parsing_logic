<?php 

define ("HOST","localhost");
define ("DB","sampulbo_belajarparsinglogic");
define ("USER","sampulbo_belajarparsinglogic");
define ("PASS","belajarparsinglogic");

$con = mysqli_connect(HOST,USER,PASS,DB);


if($_SERVER['REQUEST_METHOD']=='POST'){
    $a = array();
    $email = $_POST['email'];
    $pass = $_POST['password'];
    $name = $_POST['nama'];
    $phone = $_POST['telpon'];

    $save = "INSERT into users values(null,'$email','$pass','$name','$phone')";
    if (mysqli_query($con, $save)) {
        # code...
        $a['hasil']="Success register";
        echo json_encode($a);
    } else {
        # code...
        $a['hasil']="Failed register";
        echo json_encode($a);
    }
}
?>