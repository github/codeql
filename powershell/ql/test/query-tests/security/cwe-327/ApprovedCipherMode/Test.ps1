
$aes = [System.Security.Cryptography.Aes]::Create()

$aesManaged = New-Object "System.Security.Cryptography.AesManaged"

#Setting weak modes via CipherMode enum
$badMode = [System.Security.Cryptography.CipherMode]::ECB # $ Source
$aes.Mode = $badMode
$aesManaged.Mode = $badMode # $ Alert

$aes.Mode = [System.Security.Cryptography.CipherMode]::ECB
$aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert

# Setting weak modes directly
$aes.Mode = "ecb"
$aesManaged.Mode = "ecb" # $ Alert