function callSourceOnce {
    Source "1"
}

$x = callSourceOnce
Sink $x # $ MISSING: hasValueFlow=1

function callSourceTwice {
    Source "2"
    Source "3"
}

$x = callSourceTwice
Sink $x # $ MISSING: hasValueFlow=2 hasValueFlow=3

function returnSource1 {
    return Source "4"
}

$x = returnSource1
Sink $x # $ MISSING: hasValueFlow=4

function returnSource2 {
    $x = Source "5"
    $x
    $y = Source "6"
    return $y
}

$x = returnSource2
Sink $x # $ MISSING: hasValueFlow=5 hasValueFlow=6