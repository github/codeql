function test-if {
    param($myBool)

    if($myBool)
    {
        return 10;
    }
    return 11;
}

function test-if-else {
    param($myBool)

    if($myBool)
    {
        return 10;
    }
    else
    {
        return 11;
    }
}

function test-if-conj {
    param($myBool1, $myBool2)

    if($myBool1 -and $myBool2)
    {
        return 10;
    }
    return 11;
}

function test-if-else-conj {
    param($myBool1, $myBool2)

    if($myBool1 -and $myBool2)
    {
        return 10;
    }
    else
    {
        return 11;
    }
}

function test-if-disj {
    param($myBool1, $myBool2)

    if($myBool1 -or $myBool2)
    {
        return 10;
    }
    return 11;
}

function test-if-else-disj {
    param($myBool1, $myBool2)

    if($myBool1 -or $myBool2)
    {
        return 10;
    }
    else
    {
        return 11;
    }
}

function test-else-if {
    param($myBool1, $myBool2)

    if($myBool1)
    {
        return 10;
    }
    elseif($myBoo2)
    {
        return 11;
    }
    return 12;
}

function test-else-if-else {
    param($myBool1, $myBool2)

    if($myBool1)
    {
        return 10;
    }
    elseif($myBoo2)
    {
        return 11;
    }
    else
    {
        return 12;
    }
}

function test-switch($n) {
    switch($n)
    {
        0: { return 0; }
        1: { return 1; }
        2: { return 2; }
    }
}

function test-switch-default($n) {
    switch($n)
    {
        0: { return 0; }
        1: { return 1; }
        2: { return 2; }
        default: {
            Write-Output "Error!"
            return 3;
        }
    }
}

function test-switch-assign($n) {
    $a = switch($n) {
        0: { "0" }
        1: { "1" }
        2: { "2" }
    }
}