$a.f = Source "1"
Sink $a.f # $ hasValueFlow=1

$a.f = Source "2"
$a.f = 0
Sink $a.f # clean

$arr1[3] = Source "3"
Sink $arr1[3] # $ MISSING: hasValueFlow=3
Sink $arr1[4] # clean

$arr2[$unknown] = Source "4"
Sink $arr2[4] # $ MISSING: hasValueFlow=4

$arr3[3] = Source "5"
Sink $arr3[$unknown] # $ MISSING: hasValueFlow=5

$arr4[$unknown1] = Source "6"
Sink $arr4[$unknown2] # $ MISSING: hasValueFlow=6

$arr5[$unknown3][1] = Source "7"
Sink $arr5[$unknown3][1] # $ MISSING: hasValueFlow=7
Sink $arr5[$unknown3][2] # clean

$arr6[1][$unknown4] = Source "8"
Sink $arr6[1][$unknown4] # $ MISSING: hasValueFlow=8
Sink $arr6[2][$unknown4] # clean

$arr7[$unknown5][$unknown6] = Source "9"
Sink $arr7[1][2] # $ MISSING: hasValueFlow=9
Sink $arr7[$unknown7][$unknown8] # $ MISSING: hasValueFlow=9