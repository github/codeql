
$aes = [System.Security.Cryptography.Aes]::Create()

$aesManaged = New-Object "System.Security.Cryptography.AesManaged"

#Setting weak modes via CipherMode enum
$badMode = [System.Security.Cryptography.CipherMode]::ECB
$aes.Mode = $badMode
$aesManaged.Mode = $badMode

$aes.Mode = [System.Security.Cryptography.CipherMode]::ECB
$aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB

# Setting weak modes directly
$aes.Mode = "ecb"
$aesManaged.Mode = "ecb"