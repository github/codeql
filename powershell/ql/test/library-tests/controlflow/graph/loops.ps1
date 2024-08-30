function Test-While {
    $a = 0

    while($a -le 10) {
        $a = $a + 1
    }
}

function Test-Break {
    $a = 0
    while($a -le 10) {
        break
        $a = $a + 1
    }
}

function Test-Continue {
    $a = 0
    while($a -le 10) {
        continue
        $a = $a + 1
    }
}

function Test-DoWhile {
    $a = 0

    do {
        $a = $a + 1
    } while ($a -le 10)
}

function Test-DoUntil {
    $a = 0

    do {
        $a = $a + 1
    } until ($a -ge 10)
}

function Tet-For {
    $a = 0

    for ($i = 0; $i -le 10; $i = $i + 1) {
        $a = $a + 1
    }
}

function Test-ForEach {
    $letterArray = 'a','b','c','d'
    $a = 0
    foreach ($letter in $letterArray)
    {
        $a = $a + 1
    }
}