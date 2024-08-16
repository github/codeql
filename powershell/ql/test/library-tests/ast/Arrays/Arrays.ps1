$array1 = 1,2,"a",$true,$false,$null # 1-D array
$array1[1] = 3
$array1[2] = "b"

$array2 = New-Object 'object[,]' 2,2 # 2-D array
$array2[0,0] = "key1"
$array2[1,0] = "key1"
$array2[0,1] = "value1"
$array2[1,1] = $null

$array3 = @("a","b","c")
$array3.count

$array4 = [System.Collections.ArrayList]@()
$array4.Add(1)