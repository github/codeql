function WriteToEnvVar {
    $env:x = Source "1"
}

function ReadFromEndVar {
    Sink $Env:x # $ hasValueFlow=1 hasValueFlow=3
}

function WriteAndThenOverWriteEnvVar {
    $env:x = Source "2"
    $env:x = 0
}

function MaybeWriteToEnvVar($b) {
    if($b -eq $true) {
        $env:x = Source "3"
    } else {
        $env:x = 0
    }
}