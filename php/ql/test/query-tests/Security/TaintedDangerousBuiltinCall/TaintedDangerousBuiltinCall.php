<?php

// Direct uses: should be flagged

eval($_GET["x"]);
assert($_POST["x"]);
exec($_REQUEST["cmd"]);
unserialize($_COOKIE["data"]);

// Not a superglobal: should not be flagged

$local = "hello";
eval($local);

// Propagated via assignment: should be flagged

$x = $_GET["x"]; 
eval($x);

$y = $_POST["y"]; 
assert($y);

$z = $_REQUEST["cmd"]; 
exec($z);

// Superglobal used, but not as an argument: should not be flagged

$_GET["x"];
eval("constant");
