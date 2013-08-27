<?php
if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	if (!isset($_POST['register']))
	{
		require_once("includes/header.php");
		header('Content-Type: text/html; charset=utf-8');

?>		
								 
								<html lang="pl">
  <head>
    <title>Rejestracja konta - P-RP GPLv2</title>
	
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
    <script src="http://twojadres.pl/js/jquery.min.js"></script>
    <script src="http://twojadres.pl/js/bootstrap.js" type="text/javascript"></script>

    <link rel='stylesheet' href='http://twojadres.pl/js/bootstrap.min.css' type='text/css' />	
	<script src='http://twojadres.pl/js/jquery.validate.min.js' type='text/javascript'></script>
	<script src='http://twojadres.pl/js/prp.js' type='text/javascript'></script>

</head><body>
<div class="container">

        
            <h1>Project-Roleplay-rp GPLv2</h1>
      
<h2>Rejestracja konta</h2>

<p class='lead'>Załóż konto aby móc zalogować się na serwerze gry i na forum.</p>
<p>Przy rejestracji konieczne jest wypełnienie <b>podstawowego</b> testu znajomości zasad serwera. Podanie błędnych odpowiedzi blokuje dostęp do rejestracji z Twojego adresu IP na okres 1 godziny.</p>

<fieldset><form method='POST' class='form-horizontal'>
											<div class='control-group'>
											<label class="control-label" >Login:</label>
											<div class='controls'>
											<input type='text' name='username' value='' />
											</div>
											</div>
											
											<div class='control-group'>
											<label class="control-label" >Hasło:</label>
											<div class='controls'>
											<input type='password' name='password' />
											</div>
											</div>
																	
											<div class='control-group'>
											<label class="control-label" >Powtórz hasło:</label>
											<div class='controls'>
											<input type='password' name='password2' />
											</div>
											</div>
											
											<div class='control-group'>
											<label class="control-label" >Adres e-mail:</label>
											<div class='controls'>
											<input type='text' name='emailaddress' value='' />
											</div>
											</div>
											
											<div class='control-group'>
											<div class='controls'>Na podany adres e-mail przyjdzie link potwierdzający rejestrację.</div>
											</div>
											
											<div class='control-group'><label class="control-label" >Skrót RP oznacza:</label>										
											<div class='controls'><select name='pyt_1'><option value=''>-</option>
											<option value='1'>Real Players</option>
											<option value='2'>Role-Play</option>
											<option value='3'>Random Position</option>
											</select>
											</div>
											</div>
										
											<div class='control-group'><label class="control-label" >Nazwy postaci na serwerze RP:</label>
											<div class='controls'><select name='pyt_2'><option value=''>-</option>
											<option value='1'>Mogą być dowolne</option>
											<option value='2'>Mogą być dowolne, ale bez wulgaryzmów.</option>
											<option value='3'>Muszą zawierać rok urodzenia np. Wiktor1985</option>
											<option value='4'>Muszą zawierać wymyślone imię i nazwisko</option>
											</select>
											</div>
											</div>
											
											<div class='control-group'><label class="control-label" >W przypadku śmierci postaci:</label>
											<div class='controls'><select name='pyt_3'><option value=''>-</option>
											<option value='1'>Postać pozostaje martwa i nie można już nią grać.</option>
											<option value='2'>Trzeba napisać do admina by zrespawnować postać.</option>
											<option value='3'>Postać odradza się sama</option>
											<option value='4'>Postać traci trochę gotówki i się odradza.</option>
											</select>
											</div>
											</div>
										
											
											<div class='control-group'><div class='controls'>
											<button type='submit' class='btn btn-primary' name="register" id="register">Załóż konto</button>
											</div></div>

	
											</form></fieldset>
								 
								<?php
									if (isset($_SESSION["reg:errno"]))
										$errno = $_SESSION["reg:errno"];
									else
										$errno = 0;
										
									if ($errno==1)
										echo "<p>Konto o podanej nazwie istnieje!</p><br />";
									elseif ($errno==2)
										echo "<p>Nieznany błąd - Prosimy zgłoś go na forum!</p><br />";
									elseif ($errno==3)
										echo "<p>Konto z tym adresem mailowym już istnieje</p><br />";
									elseif ($errno==4)
										echo "<p>Nie uzupełniłeś wszystkich pól. Wszystkie są wymagane.</p><br />";
									elseif ($errno==5)
										echo "<p>Hasła nie pasują do siebie.</p><br />";
									elseif ($errno==6)
										echo "<p>Podany adres mailowy jest niepoprawny.</p><br />";
									elseif ($errno==7)
										echo "<p>W tym momencie serwer rejestracji jest wyłączony. Prosimy spróbować później.</p><br />";
										
									unset($_SESSION["reg:errno"]);
								?>
							</div>
						</div>
					</div>
				</div>
<?php
		require_once("includes/footer.php");
	} else {
		if (isset($_POST['username']) and isset($_POST['password']) and isset($_POST['password2']) and isset($_POST['emailaddress']))
		{
			if ($_POST['password'] != $_POST['password2'])
			{
				$_SESSION["reg:errno"] = 5;
				header("Location: /panel/rejestracja/");
			}
			else { // passwords match
				if (check_email_address($_POST['emailaddress'])) // Is the mail address vailid?
				{
					$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
					if (!$MySQLConn) {
						$_SESSION["reg:errno"] = 7;
						header("Location: /panel/rejestracja/");
					}
					else {
						$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
						// Got a server connection
						
						// escape some stuff
						$username = mysql_real_escape_string($_POST['username'], $MySQLConn);
						$password = $_POST['password'];
						$emailaddress = mysql_real_escape_string($_POST['emailaddress'], $MySQLConn);
						$ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR'], $MySQLConn);
						
						$mQuery1 = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='" . $username . "' LIMIT 1", $MySQLConn);
						if (mysql_num_rows($mQuery1) == 0)
						{ // username is free
							$mQuery2 = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='" . $username . "' LIMIT 1", $MySQLConn);
							if (mysql_num_rows($mQuery2) == 0)
							{ // e-mail address is not used yet
								// make the account
								$mQuery3 = mysql_query("INSERT INTO `accounts` SET `username`='" . $username . "', `password`= MD5('" . $password . "'), email='" . $emailaddress. "', registerdate=NOW(), ip='" . $ip . "', country='SC', friendsmessage='Hi!'", $MySQLConn);
								
								// Welcome mail
								$smtp = new SMTP($Config['SMTP']['hostname'], 25, false, 5);
								$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
								$smtp->mail_from($Config['SMTP']['from']);

								$smtp->send($emailaddress, 'Project-Roleplay Dziękujemy za rejestracje konta do gry!', 'Witaj!
								
Dziękujemy za dołączenie do naszego serwera. Poniżej znajdziesz Dane do twojego konta:

Użytkownik: '.$username.'
Hasło: '.$_POST['password'].'
FORUM: http://project-roleplay.pl/

Proszę przechowuj te dane ostrożnie, Gdy ktoś dokona włamania może być ciężko o przywrócenie tych danych.
								
Pozdrawiamy,
Project-Roleplay Zespół reklamy');

								$_SESSION['errno'] = 7;
								header("Location: /panel/rejestracja-ukonczona/");
							}
							else 
							{
								$_SESSION["reg:errno"] = 3;
								header("Location: /panel/rejestracja/");
							}
						}
						else
						{
							$_SESSION["reg:errno"] = 1;
							header("Location: /panel/rejestracja/");
						}
						
					}
				}
				else {
					$_SESSION["reg:errno"] = 6;
					header("Location: /panel/rejestracja/");
				}
			}
		}
		else {
			$_SESSION["reg:errno"] = 4;
			header("Location: /panel/rejestracja/");
		}
	}
}
else {
	header("Location: /ucp/main/");
}
?>