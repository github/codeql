$a.f = Source "1"
Sink $a.f # $ MISSING: hasValueFlow=1

$a.f = Source "2"
$a.f = 0
Sink $a.f # clean
