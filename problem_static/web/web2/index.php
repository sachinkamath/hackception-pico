
<html>
<center>
<h4> Click me not </h4>
<br>
<p>
Username is : admin </br>
Password is : password </br>
All you have to do is submit it. Yes! But, oh wait.. <br><br></br>
</p>
<form action="" method="post">
    <input type="hidden" name="action" value="submit" />
    <input type="text" placeholder="Username" name="user"><br><br>
	<input type="password" placeholder="Password" name="passwd"><br><br>
<!-- 
make sure all html elements that have an ID are unique and name the buttons submit 
-->
    <input id="tea-submit" type="submit" name="submit" value="Submit" disabled="true">
</form>
</center>
</html>

<?php
if (isset($_POST['action'])) {
    echo '<br><br>flag{source_modification_is_awesome}';
}
?>

