<?php
	session_start();
	require_once("FormData.php");
	$formData = getFormData();
	require_once("ModelPHP.php");
	echo getHeader();
?>

<h1>Wykonywanie przelewu:</h1>

<?php

	function wykonajPrzelew($dane){
		//wykonywanie przelewu
	}

	if (!(isset($_SESSION['login']))){
		header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	for($i=0 ; $i<count($formData) ; $i++){
		if(!(	isset($_POST[str_replace(" ", "", $formData[$i])]))){
			header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/UserMainPage.php");
			exit;
		}
	}
	
	$transfer_data = [];
	for($i=0 ; $i<count($formData) ; $i++){
		array_push($transfer_data, $_POST[str_replace(" ", "", $formData[$i])]);
	}
	
	wykonajPrzelew($transfer_data);

?>
Poprawnie wykonany przelew dla danych:<br>
<form id="transferDataForm">
<?php
	for($i=0 ; $i<count($formData) ; $i++){
			echo "<input type=\"text\" name=\"".str_replace(" ", "", $formData[$i])."\" value =\"".$transfer_data[$i]."\" readonly><br>";
	}
?>
</form>

<a href="UserMainPage.php">Wroc do strony glownej</a>

<?php
	echo getFooter();
?>