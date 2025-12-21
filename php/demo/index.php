<?php

$user = $_GET["x"] ?? "";

// Intentionally dangerous calls for MVP testing.
eval($user);
assert($user);
unserialize($user);
system($user);
exec($user);
