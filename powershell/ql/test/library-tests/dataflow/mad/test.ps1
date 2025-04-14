$x = Source "1"
$y = [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($x)
Sink $y # $ hasTaintFlow=1

$x = Source "2"
$y = Source "3"
$z = $x, $y | Join-String
Sink $z # $ hasTaintFlow=2 hasTaintFlow=3