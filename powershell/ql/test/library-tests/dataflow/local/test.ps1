$a1 = Source
Sink $a1

$b = GetBool
if($b) {
    $a2 = Source
}
Sink $a2

$c = [string]$b
Sink $c

$d = ($c)
Sink $d

$e = $d + 1
Sink $e

$f = Source

Sink "here is a string: $f"

$input = Read-Host "enter input"
Sink -UserInput $input