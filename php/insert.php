<?php

include "index.php";

$image = $_FILES['image']['name'];
$title = $_POST['title'];
$imagePath = "image/".$image;
move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);

$con->query("INSERT INTO gambar (nama_gambar,file) VALUES ('".$title."','".$image."')");

?>