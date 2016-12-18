<?php 
	session_start();
	
	//w przypadku gdy ktos chce tutaj wejsc nie bedac zalogowanym to przekieruj go do strony logowania
	if(!isset($_SESSION['login'])){
		header("location: http://" . $_SERVER['HTTP_HOST'] ."/Krypto/index.php");
		exit;
	}
	//wylacz wszystkie zmienne sesyjne
	unset($_SESSION['login']);
	
	require_once("ModelPHP.php");
	echo getHeader();
?>
	<h1>Zostales pomyslnie wylogowany ze strony</h1>
	<a href="index.php">Wroc do strony glownej</a></br>
<?php
	echo getFooter();
?>