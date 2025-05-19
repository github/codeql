$data = Read-Host -Prompt "Enter your name"  # $ type="read from stdin"


$xmlQuery = "/Users/User"
$path = "C:/Users/MyData.xml"
$xmldata = Select-Xml -Path $path -XPath $xmlQuery # $ type="file stream"

$hexdata = Format-Hex -Path $path -Count 48 # $ type="file stream"