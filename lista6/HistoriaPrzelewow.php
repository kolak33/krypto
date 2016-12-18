<?php

	require_once("ModelPHP.php");
	echo getHeader();
	
	session_start();
	if (!(isset($_SESSION['login']))){
		header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	
	require_once("basicmysql.php");
	require_once("FormData.php");
	$formData = getFormData();
	
	$transfers = getTransfers($_SESSION['login']);
	
	for($i=0 ; $i<count($transfers) ;$i++){
		for($j=0 ; $j<count($formData) ; $j++){
			echo $formData[$j].": ".$transfers[$i][str_replace(" ", "", $formData[$j])]."<br>";
		}
		echo "Data: ".$transfers[$i]['Data']."<br><br>";
	}
	
?>

<a href="UserMainPage.php">Wroc</a>

<?php
	echo getFooter();
?>