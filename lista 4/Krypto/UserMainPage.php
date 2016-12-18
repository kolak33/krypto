<?php
	session_start();
	if (!(isset($_SESSION['login']))){
		header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	require_once("ModelPHP.php");
	echo getHeader();
?>

<!DOCTYPE html>
<html>
<body>
<h1>WITAJ <?php echo $_SESSION['login']; ?> ! </h1>
<a href="Logout.php">Wyloguj sie</a>
<a href="Formularz.php">Wykonaj przelew</a>
<a href="HistoriaPrzelewow.php">Historia przelewow</a>

<?php
	echo getFooter();
?>