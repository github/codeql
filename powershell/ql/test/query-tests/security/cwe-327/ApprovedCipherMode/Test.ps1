
$aes = [System.Security.Cryptography.Aes]::Create()

$aesManaged = New-Object "System.Security.Cryptography.AesManaged"

#Setting weak modes via CipherMode enum
$badMode = [System.Security.Cryptography.CipherMode]::OBC
$aes.Mode = $badMode
$aesManaged.Mode = $badMode

$aes.Mode = [System.Security.Cryptography.CipherMode]::OBC
$aesManaged.Mode = [System.Security.Cryptography.CipherMode]::OBC

# Setting weak modes directly
$aes.Mode = "obc"
$aesManaged.Mode = "obc"