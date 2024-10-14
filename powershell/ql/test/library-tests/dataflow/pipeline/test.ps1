function produce {
    $x = Source "16"
    $y = Source "17"
    $z = Source "18"
    $x
    $y, $z
}

function consume {
    Param([Parameter(ValueFromPipeline)] $x)

    process {
        Sink $x # $ hasValueFlow=16 hasValueFlow=17 hasValueFlow=18 hasValueFlow=19 hasValueFlow=20
    }
}

produce | consume

$x = Source "19"
$y = Source "20"
$x, $y | consume

function consume2 {
    process {
        Sink $_ # $ hasValueFlow=21 hasValueFlow=22
    }
}

$x = Source "21"
$y = Source "22"
$x, $y | consume2