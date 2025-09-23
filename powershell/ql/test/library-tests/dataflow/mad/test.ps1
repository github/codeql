$x = Source "1"
$y = [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($x)
Sink $y # $ hasTaintFlow=1

$x = Source "2"
$y = Source "3"
$z = $x, $y | Join-String
Sink $z # $ hasTaintFlow=2 hasTaintFlow=3

$z1 = Join-Path -Path $x ""
Sink $z1 # $ hasTaintFlow=2

$z2 = Join-Path -ChildPath $x ""
Sink $z2 # $ hasTaintFlow=2

$z3 = Join-Path -AdditionalChildPath $x ""
Sink $z3 # $ hasTaintFlow=2

$z4 = Join-Path $x
Sink $z4 # $ hasTaintFlow=2

$z5 = Join-Path "" $x
Sink $z5 # $ hasTaintFlow=2

$z6 = Join-Path "" "" $x
Sink $z6 # $ hasTaintFlow=2

$z7 = [System.IO.Path]::GetFullPath($x)
Sink $z7 # $ hasTaintFlow=2