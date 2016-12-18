<?php
	if(isset($_SESSION['login'])){
		header("location: http://" . $_SERVER['HTTP_HOST'] ."/Krypto/UserMainPage.php");
		exit;
	}
		
	require_once("ModelPHP.php");
	echo getHeader();
?>

<h1>Rejestracja</h1>
<a href="Register.php">zarejestruj sie</a>

<form id="registerForm" action="CheckUserRegister.php" method="post">
  Login:<br>
  <input type="text" name="login">
  <br>
  Haslo:<br>
  <input type="password" name="password">
  <br><br>
  <input type="submit" value="Zarejestruj">
</form>

<br>
<a href="index.php">Wroc</a></br>

<?php
	echo getFooter();
?>