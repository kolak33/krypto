<?php

require_once("MyDatabase.php");

function isLoginInDB($login){
	return myDbSelect(myDB(),"SELECT login FROM Users WHERE login='". $login."'") != null; 
}

function isUserInDB($login, $password){
	return myDbSelect(myDB(),"SELECT login FROM Users WHERE login='". $login."' AND password='".$password."'") != null;
}

function getUser($login){
	return myDbSelect(myDB(),"SELECT login, password FROM Users WHERE login='". $login."'");
}

function addUserToDB($login, $password){
	myDB() -> query("INSERT INTO `Users`(`login`, `password`) VALUES ('".$login."','".$password."')");
}

function setTransfer($login, $nazwaOdbiorcy, $numerRachunkuOdbiorcy, $kwota, $nazwaZleceniodawcy, $tytulPrzelewu){
	myDB() -> query("INSERT INTO `przelewy`(`login`, `NazwaOdbiorcy`, `NumerRachunkuOdbiorcy`, `Kwota`, `NazwaZleceniodawcy`, `TytulPrzelewu`, `Data`) VALUES ('".$login."','".$nazwaOdbiorcy."','".$numerRachunkuOdbiorcy."','".$kwota."','".$nazwaZleceniodawcy."','".$tytulPrzelewu."',NOW())");
}

function getTransfers($login){
	return myDbSelect(myDB(), "SELECT  `login`, `NazwaOdbiorcy`, `NumerRachunkuOdbiorcy`, `Kwota`, `NazwaZleceniodawcy`, `TytulPrzelewu`, `Data` FROM przelewy WHERE login='". $login."' ORDER BY Data DESC");
}

?>