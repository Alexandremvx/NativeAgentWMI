<?php
	if (isset($_POST["win32_bios.serialnumber"])){ 
		var_dump($_POST);
	} else {
		$sqlquery = "DESCRIBE wminfo";
		//$conn = new mysqli("localhost", "root", "cascavel", "vw");
		include 'anotheronebitesthedust.php';
		if ($conn->connect_error) { die("Connection failed: " . $conn->connect_error); }
		$sqlresult = mysqli_query($conn, $sqlquery);

		while($row = mysqli_fetch_array($sqlresult)){
			echo $row['Field'].";";
		}
		mysqli_close($conn);

//echo "Win32_BIOS.SerialNumber;Win32_NetworkAdapterConfiguration.IPAddress;Win32_ComputerSystem.Name;Win32_TimeZone.Caption;Win32_TimeZone.Bias;Win32_TimeZone.DaylightBias;WiN32_localtime.second";
echo "
invalido
tambem_invalido;
super hyper invalido
";
	}
?>



<?php
	/*			$reqsource = $_SERVER['REMOTE_ADDR'];
				$sqlquery = "Select * FROM hvht WHERE hostname = '" . $_POST['hostname'] . "' AND sid = '" . $_POST['sid'] . "'";
				$sqlinsert = "INSERT INTO hvht (hostname, ipaddress, domain, timezone, bias, dlbias, tempolocal, hvi, hvf, hvini, hvfim, so, sid, rsource) VALUES ('" . $_POST['hostname'] . "','" . $_POST['ipaddress'] . "','" . $_POST['domain'] . "','" . $_POST['timezone'] . "','" . $_POST['bias'] . "','" . $_POST['dlbias'] . "','" . $_POST['localtime'] . "','" . $_POST['hvi'] . "','" . $_POST['hvf'] . "','" . $_POST['hvini'] . "','" . $_POST['hvfim'] . "','" . $_POST['so'] . "','" . $_POST['sid'] . "','" . $reqsource ."')";
				$sqlupdate = "UPDATE hvht SET ipaddress = '" . $_POST['ipaddress'] ."', domain = '" . $_POST['domain'] ."', timezone = '" . $_POST['timezone'] ."', bias = '" . $_POST['bias'] ."',    dlbias = '" . $_POST['dlbias'] ."', tempolocal = '" . $_POST['localtime'] ."',        hvi = '" . $_POST['hvi'] ."',        hvf = '" . $_POST['hvf'] ."',      hvini = '" . $_POST['hvini'] ."',      hvfim = '" . $_POST['hvfim'] ."',         so = '" . $_POST['so'] ."',  rsource = '" . $reqsource . "'  WHERE  hostname = '" . $_POST['hostname'] . "' AND sid = '" . $_POST['sid'] . "'";
				
				if ($dbupdate) {
					$conn = new mysqli("localhost", "hvht", "hvht", "hvht_db");
					if ($conn->connect_error) { die("Connection failed: " . $conn->connect_error); }
					$sqlcheck = mysqli_query($conn, $sqlquery);
					if($sqlcheck->num_rows > 0){
						if (mysqli_query($conn, $sqlupdate)) { echo "atualizado";};
					} else{
						if (mysqli_query($conn, $sqlinsert)) { echo "inserido";};
					}
				} else {
					echo "incio";
				}
        */
	?>


