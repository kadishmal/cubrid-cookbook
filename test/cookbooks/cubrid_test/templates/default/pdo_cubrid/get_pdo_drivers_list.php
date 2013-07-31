<?php
foreach(PDO::getAvailableDrivers() as $driver) {
	echo $driver . PHP_EOL;
}
?>
