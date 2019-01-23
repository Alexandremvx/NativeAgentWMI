<?php
	include 'anotheronebitesthedust.php';

	$sqlPrimaryQuery = 'SHOW KEYS FROM wminfo WHERE Key_name = "PRIMARY"';
	$sqlPrimary = mysqli_query($conn, $sqlPrimaryQuery);
	while($sqlPr = mysqli_fetch_array($sqlPrimary)){$sqlP = $sqlPr['Column_name'];}
	
	$sqlColumnsQuery = 'SHOW COLUMNS FROM wminfo WHERE Field like "%$%"';
	$sqlColumns = mysqli_query($conn, $sqlColumnsQuery);
	while($sqlCols = mysqli_fetch_array($sqlColumns)){$sqlCol=$sqlCol.$sqlCols['Field'].";";}
	$sqlCola = split(';',$sqlCol);
	
	if (isset($_POST[$sqlP]) ){
		echo "Action: Insert/Update\n";
		$sep="";$qi="";
		foreach ($_POST as $key => $value) {
			if (substr_count($key,'$')==1 && in_array($key,$sqlCola)) {
				echo "{$key} => {$value}\n";
				$qi = $qi . $sep . $key . ' = "' . $value . '"';
				$sep=",";
			}
		}
		
		$sqlWMIInsertQuery = 'INSERT INTO wminfo SET ' . $qi . ' ON DUPLICATE KEY UPDATE ' . $qi ;
		$sqlWMIInsert = mysqli_query($conn, $sqlWMIInsertQuery);
		echo "\nStatus = " . $sqlWMIInsert;
	} else {
		echo $sqlCol;
		echo '
		invalido
		tambem_invalido;
		super hyper invalido;
		rougue$value
		';
	}


	mysqli_close($conn);
?>




<?php
 //$conn = new mysqli("localhost", "root", "cascavel", "vw");
 //if ($conn->connect_error) { die("Connection failed: " . $conn->connect_error); }
		
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

