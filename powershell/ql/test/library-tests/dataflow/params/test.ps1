function Foo($a) {
    Sink $a # $ hasValueFlow=1
}

$x = Source "1"
Foo $x

function ThreeArgs($x, $y, $z) {
    Sink $x # $ hasValueFlow=x
    Sink $y # $ hasValueFlow=y
    Sink $z # $ hasValueFlow=z
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

function Invoke-InvokeExpressionInjection2
{
    param($UserInput)
    Sink $UserInput # $ hasValueFlow=1
}

$input = Source "1"
Invoke-InvokeExpressionInjection2 -UserInput $input  