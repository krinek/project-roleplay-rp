<?php
session_start();
ob_start();

@ini_set('magic_quotes_runtime', 0);

require_once("includes/config.php");
require_once("includes/classes.php");

// sprawdzmy czy rejestracja
if (!isset($_GET['panel']))
{
	Header("Location: /panel/rejestracja/");
	die();
}

elseif (isset($_GET['panel']))
{
	require_once("includes/ucp_functions.php");
	switch ($_GET['panel'])
	{
		case 'rejestracja-ukonczona':
			require_once("strony/ucp/rejestracja-ukonczona.php");	
			break;
		case 'rejestracja':
			require_once("strony/ucp/rejestracja.php");	
			break;
		default:
			echo "Panie naprawiê jak znajdê :D .";
			break;
	}
}
?>