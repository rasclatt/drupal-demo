<?php

session_start();

$_SESSION['test_counter'] = ($_SESSION['test_counter'] ?? 0) + 1;

echo 'Session ID: ' . session_id() . "\n";
echo 'Counter: ' . $_SESSION['test_counter'] . "\n";
echo 'Save path: ' . session_save_path() . "\n";
