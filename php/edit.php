<?php 

define ("HOST","localhost");
define ("DB","sampulbo_belajarparsinglogic");
define ("USER","sampulbo_belajarparsinglogic");
define ("PASS","belajarparsinglogic");

$con = mysqli_connect(HOST,USER,PASS,DB);


if($_SERVER['REQUEST_METHOD']=='POST'){
    $a = array();
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $phone = $_POST['telpon'];

    $check = "SELECT * FROM users WHERE email='$email'";
    $result = mysqli_fetch_array(mysqli_query($con, $check));

    if(isset($result)){
        $save = "UPDATE users set nama='$nama' ,telpon='$phone' WHERE email='$email'";
        if (mysqli_query($con, $save)) {
            # code...
            $a['value']=1;
            $a['pesan']="Profil has been update";
            echo json_encode($a);
        } else {
            # code...
            $a['value']=2;
            $a['pesan']="Failed to edit";
            echo json_encode($a);
        }
    }else{
        $a['value']=0;
        $a['pesan']="Profil not found";
        echo json_encode($a);
    }
    
}
?>