<html>

<head>
  <title> HVM - REPORT</title>
</head>

<body>
<div style="overflow-x:auto;">
<?php
include 'anotheronebitesthedust.php'; //$conn = new mysqli("server", "user", "pass", "database");

$strMonth = Array("","Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez");
$strDayOfWeek = Array("o Dom de ","a Seg de ","a Ter de ","a Qua de ","a Qui de ","a Sex de ","o Sab de ");
$strDay = Array("","1","2","3","4","Ultim");

$sqlquery = "SELECT * FROM wminfo ORDER BY update_time";

if ($conn->connect_error) { die("Connection failed: " . $conn->connect_error); }

$sqlresult = mysqli_query($conn, $sqlquery);
	
echo "<table border='1'>
<tr>
<th>hostname</th>
<th>ipaddress</th>
<th>domain</th>
<th>timezone</th>
<th>bias</th>
<th>dlbias</th>
<th>tempolocal</th>
<th>hvi</th>
<th>hvf</th>
<th>hv inicio</th>
<th>hv fim</th>
<th>Sistema Operacional</th>
<th>Serial</th>     
<th>Origem Report</th>
<th>time_updated</th>
</tr>";

while($row = mysqli_fetch_array($sqlresult)){

$Serial = $row['Win32_BIOS$SerialNumber'];
$Hostname = $row['Win32_ComputerSystem$Name'];
$IPAddress = $row['Win32_NetworkAdapterConfiguration$IPAddress'];
$Domain = $row['Win32_ComputerSystem$Domain'];
$Timezone = $row['Win32_Timezone$Caption'];
$Bias = $row['Win32_Timezone$Bias'];
$DlBias = $row['Win32_Timezone$DaylightBias'];
 $LT_Year = $row['Win32_LocalTime$Year'];
 $LT_Mon = $row['Win32_LocalTime$Month'];
 $LT_Day = $row['Win32_LocalTime$Day'];
 $LT_Hour = $row['Win32_LocalTime$Hour'];
 $LT_Min = $row['Win32_LocalTime$Minute'];
 $LT_Sec = $row['Win32_LocalTime$Second'];
 $LT_CT = $row['Win32_OperatingSystem$CurrentTimeZone'];
$Tempolocal = $LT_Year . $LT_Mon . $LT_Day . $LT_Hour . $LT_Min . $LT_Sec . $LT_CT;
 $DaylightDay = $row['Win32_Timezone$DaylightDay'];
 $DaylightDayOfWeek = $row['Win32_Timezone$DaylightDayOfWeek'];
 $DaylightMonth = $row['Win32_Timezone$DaylightMonth'];
$HVI = $DaylightDay . "_" . $DaylightDayOfWeek . "_" . $DaylightMonth;
$HVIni =  $strDay[$DaylightDay] . $strDayOfWeek[$DaylightDayOfWeek] . $strMonth[$DaylightMonth];
 $StandardDay = $row['Win32_Timezone$StandardDay'];
 $StandardDayOfWeek = $row['Win32_Timezone$StandardDayOfWeek'];
 $StandardMonth = $row['Win32_Timezone$StandardMonth'];
$HVF = $StandardDay . "_" . $StandardDayOfWeek . "_" .$StandardMonth;
$HVFim = $strDay[$StandardDay] . $strDayOfWeek[$StandardDayOfWeek] . $strMonth[$StandardMonth];
$SO = $row['Win32_OperatingSystem$Caption'];
$RSource = $row['source_address'];
$Time_Updated = $row['update_time'];
	/*
	
*/	

echo "<tr>";
echo "<td>" . $Hostname . "</td>";
echo "<td>" . $IPAddress . "</td>";
echo "<td>" . $Domain . "</td>";
echo "<td>" . $Timezone . "</td>";
echo "<td>" . $Bias . "</td>";
echo "<td>" . $DlBias . "</td>";
echo "<td>" . $Tempolocal . "</td>";
echo "<td>" . $HVI . "</td>";
echo "<td>" . $HVF . "</td>";
echo "<td>" . $HVIni . "</td>";
echo "<td>" . $HVFim . "</td>";
echo "<td>" . $SO . "</td>";
echo "<td>" . $Serial . "</td>";
echo "<td>" . $RSource . "</td>";
echo "<td>" . $Time_Updated . "</td>";
echo "</tr>";


}
echo "</table>";

mysqli_close($con);

?>
</div>
</body>

</html>
