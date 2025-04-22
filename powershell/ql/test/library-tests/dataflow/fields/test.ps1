param($a, $arr1, $arr2, $arr3, $arr4, $arr5, $arr6, $arr7, $arr8, $arr9, $unknown, $unknown1, $unknown2, $unknown3, $unknown4, $unknown5, $unknown6, $unknown7, $unknown8)

$a.f = Source "1"
Sink $a.f # $ hasValueFlow=1

$a.f = Source "2"
$a.f = 0
Sink $a.f # clean

$arr1[3] = Source "3"
Sink $arr1[3] # $ hasValueFlow=3
Sink $arr1[4] # clean

$arr2[$unknown] = Source "4"
Sink $arr2[4] # $ hasValueFlow=4

$arr3[3] = Source "5"
Sink $arr3[$unknown] # $ hasValueFlow=5

$arr4[$unknown1] = Source "6"
Sink $arr4[$unknown2] # $ hasValueFlow=6

$arr5[$unknown3][1] = Source "7"
Sink $arr5[$unknown3][1] # $ hasValueFlow=7
Sink $arr5[$unknown3][2] # clean

$arr6[1][$unknown4] = Source "8"
Sink $arr6[1][$unknown4] # $ hasValueFlow=8
Sink $arr6[2][$unknown4] # clean

$arr7[$unknown5][$unknown6] = Source "9"
Sink $arr7[1][2] # $ hasValueFlow=9
Sink $arr7[$unknown7][$unknown8] # $ hasValueFlow=9

$x = Source "10"

$arr8 = 0, 1, $x
Sink $arr8[0] # clean
Sink $arr8[1] # clean
Sink $arr8[2] # $ hasValueFlow=10
Sink $arr8[$unknown] # $ hasValueFlow=10

$y = Source "11"

$arr9 = @(0, 1, $y)
Sink $arr9[0] # clean
Sink $arr9[1] # clean
Sink $arr9[2] # $ hasValueFlow=11
Sink $arr9[$unknown] # $ hasValueFlow=11

class MyClass {
    [string] $field

    [void]callSink() {
        Sink $this.field # $ hasValueFlow=12
    }
}

$myClass = [MyClass]::new()

$myClass.field = Source "12"

$myClass.callSink()

function produce {
    $x = Source "13"
    $y = Source "14"
    $z = Source "15"
    $x
    $y, $z
}

$x = produce
Sink $x[0] # $ hasValueFlow=13 hasValueFlow=14 hasValueFlow=15
Sink $x[1] # $ hasValueFlow=13 hasValueFlow=14 hasValueFlow=15
Sink $x[2] # $ hasValueFlow=13 hasValueFlow=14 hasValueFlow=15

$hash = @{
  a = Source "16"
  b = 2
}

Sink $hash["a"] # $ hasValueFlow=16
Sink $hash["b"] # clean

$hash["a"] = 0
Sink $hash["a"] # $ SPURIOUS: hasValueFlow=16
$hash.b = Source "17"
Sink $hash.b # $ hasValueFlow=17