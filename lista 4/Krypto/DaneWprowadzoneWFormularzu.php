<?php
	session_start();
	require_once("FormData.php");
	$formData = getFormData();
	
	require_once("ModelPHP.php");
	echo getHeader();
?>

<h1>Dane wprowadzone do formularza:</h1>

<?php
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
?>

<form id="acceptFormForm" action="FormToDBSetter.php" method="post">
<?php
	for($i=0 ; $i<count($formData) ; $i++){
		echo $formData[$i].": <input type=\"text\" name=\"".str_replace(" ", "", $formData[$i])."\" value =\"".$_POST[str_replace(" ", "", $formData[$i])]."\" readonly><br>";
	}
?>
<input type="submit" value="AKCEPTUJE">
</form>

<a href="Formularz.php">Wróć</a>

<?php
	echo getFooter();
?>