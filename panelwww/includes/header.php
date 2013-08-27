<HTML>

	</HEAD>
	<BODY>
		<div id="framework">
			<div id="header">
				<?php
if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{					
	echo"				\r\n";	
} else {
	echo"				<div class=\"nav-links-right\">Witaj ponownie, ".$_SESSION['ucp_username']." | <a href=\"/ucp/main/\">Panel Gracza</a></div>\r\n";		
}	
?>
			</div>
		
			<div id="ticker">&nbsp;</div>
			<div id="main">
				<div id="sidebarleft">
					
				</div>
				<div id="content">
