<?php 

define ("HOST","localhost");
define ("DB","sampulbo_belajarparsinglogic");
define ("USER","sampulbo_belajarparsinglogic");
define ("PASS","belajarparsinglogic");

$con = mysqli_connect(HOST,USER,PASS,DB);

$response = array();
$select = mysqli_query($con, "SELECT * FROM gambar");
while ($a = mysqli_fetch_array($select)) {
    # code...
    $value['id'] = $a['id'];
    $value['imageName'] = $a['nama_gambar'];
    $value['fileName'] = $a['file'];
    $value['createDate'] = $a['created_date'];

    array_push($response, $value);
}

echo json_encode($response);

?>