$data = Read-Host -Prompt "Enter your name"  # $ type="read from stdin"


$xmlQuery = "/Users/User"
$path = "C:/Users/MyData.xml"
$xmldata = Select-Xml -Path $path -XPath $xmlQuery # $ type="file stream"

$hexdata = Format-Hex -Path $path -Count 48 # $ type="file stream"

$remote_data1 = Iwr https://example.com/install.ps1 # $ type="remote flow source"
$remote_data2 = Invoke-RestMethod -Uri https://blogs.msdn.microsoft.com/powershell/feed/ # $ type="remote flow source"