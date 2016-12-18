<?php

	require_once("basicmysql.php");
	
	session_start();

	if (!(isset($_SESSION['login'])) OR isUserInDBLog($_SESSION['login']) OR !(isset($_GET['id']))){
		header("location: https://" . $_SERVER['HTTP_HOST'] . "/Krypto/index.php");
		exit;
	}
	confirmTransfer($_GET['id']);
	header("location: https://" . $_SERVER['HTTP_HOST'] . "/Krypto/AdminPage.php");
?>