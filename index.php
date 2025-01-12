<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

file_put_contents('debug.log', 'Script started' . PHP_EOL, FILE_APPEND);

require_once 'config.php';

$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if ($conn->connect_error) {
    file_put_contents('debug.log', 'Connection failed: ' . $conn->connect_error . PHP_EOL, FILE_APPEND);
    die("Connection failed: " . $conn->connect_error);
}

$definition = '';
$error = '';

if (isset($_POST['search'])) {
    $word = $conn->real_escape_string($_POST['word']);
    $sql = "SELECT definition FROM words WHERE word = '$word'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $definition = $row['definition'];
    } else {
        $error = "Word not found in dictionary";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Dictionary App</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 20px auto; padding: 0 20px; }
        .result { margin-top: 20px; padding: 10px; border: 1px solid #ddd; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>Dictionary Lookup</h1>
    <form method="POST">
        <input type="text" name="word" placeholder="Enter a word" required>
        <button type="submit" name="search">Search</button>
    </form>

    <?php if ($definition): ?>
        <div class="result">
            <h3><?php echo htmlspecialchars($_POST['word']); ?></h3>
            <p><?php echo htmlspecialchars($definition); ?></p>
        </div>
    <?php endif; ?>

    <?php if ($error): ?>
        <div class="error"><?php echo $error; ?></div>
    <?php endif; ?>
</body>
</html>
