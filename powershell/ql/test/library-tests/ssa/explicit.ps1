$glo_a = 42
$glob_b = $glob_a

function f() {
    $a = 43
    $b = $a
    return $b
}