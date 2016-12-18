<?php

	require_once("basicmysql.php");

	/*haslo sklada sie z k znakow salta oraz 64 znaki hashu salt+password*/
	function createPassword($pass){
		$salt = rand(32,511);
		$protect_form = $salt.hash('sha256', $salt.$pass); 
		return $protect_form;
	}
	
	/*Funkcja sprawdzaja*/
	function checkPassword($login, $password){
		$user_data = getUser($login);
		$hash = substr($user_data[0]['password'], strlen($user_data[0]['password'])-64, 64);
		$salt = substr($user_data[0]['password'], 0, strlen($user_data[0]['password'])-64);
		return hash('sha256', $salt.$password) == $hash;
	}
?>