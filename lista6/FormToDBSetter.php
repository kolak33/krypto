<?php

	require_once("basicmysql.php");
	require_once("FormData.php");
	$formData = getFormData();
	
	session_start();

	for($i=0 ; $i<count($formData) ; $i++){
		if(!(	isset($_POST[str_replace(" ", "", $formData[$i])]))){
			header("location: http://" . $_SERVER['HTTP_HOST'] . "/Krypto/UserMainPage.php");
			exit;
		}
	}
	
	setTransfer(	$_SESSION['login'], 
						$_POST[str_replace(" ", "", $formData[0])], 
						$_POST[str_replace(" ", "", $formData[1])],
						$_POST[str_replace(" ", "", $formData[2])],
						$_POST[str_replace(" ", "", $formData[3])],
						$_POST[str_replace(" ", "", $formData[4])]	);
?>

<form id="setTransferDBForm" action="Transfer.php" method="post">
	<?php
		for($i=0 ; $i<count($formData) ; $i++){
			echo "<input type=\"hidden\" name=\"".str_replace(" ", "", $formData[$i])."\" value =\"".$_POST[str_replace(" ", "", $formData[$i])]."\" readonly><br>";
		}
	?>
</form>

<script>
	document.getElementById("setTransferDBForm").submit();
</script>