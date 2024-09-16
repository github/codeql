function function-param([int]$n1, [int]$n2) {
    return $n1 + $n2
}

function param-block {
    param(
        [int]$a,
        [int]$b
    )
    return $a + $b
}