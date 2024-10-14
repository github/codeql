function callSourceOnce {
    Source "1"
}

$x = callSourceOnce
Sink $x # $ hasValueFlow=1

function callSourceTwice {
    Source "2"
    Source "3"
}

$x = callSourceTwice
Sink $x # $ hasTaintFlow=2 hasTaintFlow=3
Sink $x[0] # $ hasValueFlow=2 SPURIOUS: hasValueFlow=3
Sink $x[1] # $ hasValueFlow=3 SPURIOUS: hasValueFlow=2

function returnSource1 {
    return Source "4"
}

$x = returnSource1
Sink $x # $ hasValueFlow=4

function returnSource2 {
    $x = Source "5"
    $x
    $y = Source "6"
    return $y
}

$x = returnSource2
Sink $x[0] # $ hasValueFlow=5 SPURIOUS: hasValueFlow=6
Sink $x[1] # $ hasValueFlow=6 SPURIOUS: hasValueFlow=5

function callSourceInLoop {
    for ($i = 0; $i -lt 2; $i++) {
        Source "7"
    }
}

$x = callSourceInLoop
Sink $x[0] # $ hasValueFlow=7
Sink $x[1] # $ hasValueFlow=7