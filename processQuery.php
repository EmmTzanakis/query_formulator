<?php
	/* P-T natural language to SQL translator
	 * Christopher Prasatzakis (csd3442)
	 * Manos Tzanakis (csd1746)
	 * csd3442@csd.uoc.gr
	 * csd1746@csd.uoc.gr
	 * HTML/PHP interface for sample implementation. */
?>

<head>
	<title>Query results</title>
</head>

<?php
	//Function that tosses stopwords of NL query and prepares it to be "fed" to the translator.
	function transformQuery($query) {
		$stopwords = array("ME", "THE", "WHOSE", "OF", "HIS", "WITH", "AN", "A", "ABOUT");
		$punct = "!.,";
		
		$tok = strtok($query, " ");
	
		$nlquery = "";
	
		while (!($tok === false)) {
			if (is_numeric($tok)) {
				$nlquery = $nlquery . $tok . " ";
				$tok = strtok(" ");
				continue;
			}
				
			$tok = strtoupper(rtrim($tok, ",!."));
		
			if (!(in_array($tok, $stopwords))) $nlquery = $nlquery . $tok . " ";
			$tok = strtok(" ");
		}
		
		return $nlquery;
	}
	
	//Connect to CCC database.
	$servername = "localhost";
	$username = "root";
	$dbname = "ccc";

	$conn = mysqli_connect($servername, $username, '', $dbname);
	
	if (!$conn) {
		echo "Connection failed: " . mysqli_connect_error();
		die();
	}
	
	echo "Original query: " . $_POST["query"] . "<br>";
	
	//Transform query.
	$query = transformQuery($_POST["query"]);
	
	echo "Manipulated query: " . $query . "<br>";
	
	$file = fopen("query", "w");
	fwrite($file, $query);
	fclose($file);
	
	//Generate SQL query from transformed NL query.
	$sql = exec("ccc.exe query");
	
	echo "SQL query: " . $sql . "<br><br>";
	
	//Run generated SQL query and display its results.
	$result = mysqli_query($conn, $sql);
	
	if (mysqli_num_rows($result) <= 0)
		die("Account not found!");
	
	while ($row = mysqli_fetch_assoc($result)) {
		foreach (array_keys($row) as $i) {
			echo $i . ": " . $row[$i] . "<br>";
		}
		
		echo "<br>";
	}
	
	mysqli_close($conn);
	
	die();
?>