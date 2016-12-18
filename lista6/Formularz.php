<?php
	session_start();
	require_once("FormData.php");
	if (!(isset($_SESSION['login']))){
		header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	$formData = getFormData();
	require_once("ModelPHP.php");
	echo getHeader();
?>

<h1>Wypełnij formularz</h1>

<form id="formularzForm" action="DaneWprowadzoneWFormularzu.php" method="post">
	<?php
	for($i=0 ; $i<count($formData) ; $i++){
		echo $formData[$i].":<br>
				<input type=\"text\" name=\"".str_replace(" ", "", $formData[$i])."\">
				<br>";
	}
	?>
	<br>
	<input type="submit" value="PRZEJDZ DALEJ">
</form>
<br>
<a href="UserMainPage.php">Wróć</a>

<?php
	echo getFooter();
?>