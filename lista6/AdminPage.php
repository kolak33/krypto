<?php

	require_once("ModelPHP.php");
	echo getHeader();
	
	session_start();
	if (!(isset($_SESSION['login'])) AND isUserInDBLog($_SESSION['login'])){
		header("location: https://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	
	require_once("basicmysql.php");
	require_once("FormData.php");
	$formData = getFormData();
	
	$transfers = getUnconfirmedTransfers();
	
	for($i=0 ; $i<count($transfers) ;$i++){
		echo "<form action='ZatwierdzPrzelew.php' method='get'>";
		echo "<input type=\"hidden\" name='id' value =\"".$transfers[$i]['ID']."\" readonly><br>";
		echo "ID: ".$transfers[$i]['ID']."<br>";
		for($j=0 ; $j<count($formData) ; $j++){
			echo $formData[$j].": ".$transfers[$i][str_replace(" ", "", $formData[$j])]."<br>";
		}
		echo "Data: ".$transfers[$i]['Data']."<br>";
		echo "Status: ".$transfers[$i]['Status']."<br>";
		echo "<input type=\"submit\" value=\"Zatwierdź\">";
		echo "</form>";
	}
	
?>
<br><br>
<a href="Logout.php">Wyloguj</a>

<?php
	echo getFooter();
?>