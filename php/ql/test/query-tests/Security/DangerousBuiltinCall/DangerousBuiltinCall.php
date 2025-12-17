<?php

$input = $_GET["x"];
eval($input);

// Not a call.
$eval = "eval";

// Not a call (function definition).
function system($cmd) {
	return $cmd;
}

// Not a call with a static callee name.
$fn = "assert";
$fn($input);

assert($input);
unserialize($input);
exec($input);
