function Foo($a) {
    Sink $a # $ MISSING: hasValueFlow=1
}

$x = Source "1"
Foo $x

function ThreeArgs($x, $y, $z) {
    Sink $x # $ MISSING: hasValueFlow=x
    Sink $y # $ MISSING: hasValueFlow=y
    Sink $z # $ MISSING: hasValueFlow=z
}

$first = Source "x"
$second = Source "y"
$third = Source "z"

ThreeArgs $first $second $third
ThreeArgs $second -x $first $third
ThreeArgs -x $first $second $third
ThreeArgs $first -y $second $third
ThreeArgs -y $second $first $third
ThreeArgs $second -x $first -z $third
ThreeArgs -x $first $second -z $third
ThreeArgs $first -y $second -z $third
ThreeArgs -y $second $first -z $third
ThreeArgs $second -x $first -z $third
ThreeArgs -x $first -z $third $second
ThreeArgs $first -y $second -z $third
ThreeArgs -y $second -z $third $first
ThreeArgs $second -z $third -x $first
ThreeArgs -x $first -z $third $second
ThreeArgs $first -z $third -y $second
ThreeArgs -y $second -z $third $first
ThreeArgs -z $third -y $second $first
ThreeArgs -z $third $second -x $first
ThreeArgs -z $third -x $first $second
ThreeArgs -z $third $first -y $second
ThreeArgs -z $third -y $second $first