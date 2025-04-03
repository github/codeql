function produce {
    $x = Source "1"
    $y = Source "2"
    $z = Source "3"
    $x
    $y, $z
}

function consumeWithProcess {
    Param([Parameter(ValueFromPipeline)] $x)

    process {
        Sink $x # $ hasValueFlow=1 hasValueFlow=2 hasValueFlow=3 hasValueFlow=4 hasValueFlow=5
    }
}

produce | consumeWithProcess

$x = Source "4"
$y = Source "5"
$x, $y | consumeWithProcess

function consumeWithProcessAnonymous {
    process {
        Sink $_ # $ hasValueFlow=6 hasValueFlow=7
    }
}

$x = Source "6"
$y = Source "7"
$x, $y | consumeWithProcessAnonymous

function consumeValueFromPipelineByPropertyNameWithoutProcess {
    Param([Parameter(ValueFromPipelineByPropertyName)] $x)

    Sink $x # $ MISSING: hasValueFlow=8
}

$x = Source "8"
[pscustomobject]@{x = $x} | consumeValueFromPipelineByPropertyNameWithoutProcess

function consumeValueFromPipelineByPropertyNameWithProcess {
    Param([Parameter(ValueFromPipelineByPropertyName)] $x)

    process {
        Sink $x # $ hasValueFlow=9 hasValueFlow=10 hasValueFlow=11
    }
}

[pscustomobject]@{x = Source "9"}, [pscustomobject]@{x = Source "10"}, [pscustomobject]@{x = Source "11"} | consumeValueFromPipelineByPropertyNameWithProcess