$untrustedBase64 = Read-Host "Enter user input"
$formatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
$stream = [System.IO.MemoryStream]::new([Convert]::FromBase64String($untrustedBase64))
$obj = $formatter.Deserialize($stream)
