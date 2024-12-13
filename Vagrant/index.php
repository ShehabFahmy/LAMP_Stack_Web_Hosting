<?php
// Include database configuration
$config = require '/vagrant/Secrets/db_config.php';

// Read the password from the Secrets file
$password = trim(file_get_contents($config['password_file']));

// Create connection
$conn = new mysqli($config['host'], $config['username'], $password, $config['dbname']);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the visitor's IP address
$ip_address = $_SERVER['REMOTE_ADDR'];

// Get the current date and time
$visit_date = date('Y-m-d H:i:s');

// Insert visitor info into the database
$sql = "INSERT INTO visitors (ip_address, visit_date) VALUES ('$ip_address', '$visit_date')";
if ($conn->query($sql) === TRUE) {
    echo "New record created successfully.<br>";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// Retrieve visitor data
$sql = "SELECT ip_address, visit_date FROM visitors ORDER BY visit_date DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>IP Address</th><th>Visit Date</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["ip_address"] . "</td><td>" . $row["visit_date"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No visitors yet.";
}

// Close the connection
$conn->close();
?>
