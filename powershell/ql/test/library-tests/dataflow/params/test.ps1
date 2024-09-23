function Foo($a) {
    Sink $a # $ MISSING: hasValueFlow=1
}

$x = Source "1"
Foo $x