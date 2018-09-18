<?php 

define ("HOST","localhost");
define ("DB","sampulbo_belajarparsinglogic");
define ("USER","sampulbo_belajarparsinglogic");
define ("PASS","belajarparsinglogic");

$con = mysqli_connect(HOST,USER,PASS,DB);


if($_SERVER['REQUEST_METHOD']=='POST'){
    $a = array();
    $user = $_POST['email'];
    $pass = $_POST['password'];

    $check = "SELECT * FROM users WHERE email='$user' AND password='$pass' ";
    $result = mysqli_fetch_array(mysqli_query($con, $check));

    if (isset($result)) {
        # code...
        $a['hasil']="success";
        $a['value']= 1;
        $a['name']=$result['nama'];
        $a['email']=$result['email'];
        $a['password']=$result['password'];
        $a['telpon']=$result['telpon'];
        echo json_encode($a);
    } else {
        # code...
        $a['hasil']="failed to login";
        $a['value']=0;
        echo json_encode($a);
    }
    
}
?>