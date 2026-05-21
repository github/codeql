
$aes = [System.Security.Cryptography.Aes]::Create()

$aesManaged = New-Object "System.Security.Cryptography.AesManaged"

#Setting weak modes via CipherMode enum
$badMode = [System.Security.Cryptography.CipherMode]::ECB # $ Source
$aes.Mode = $badMode # $ Alert
$aesManaged.Mode = $badMode # $ Alert

$aes.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert
$aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert

# Setting weak modes directly
$aes.Mode = "ecb" # $ Alert
$aesManaged.Mode = "ecb" # $ Alert

# Other symmetric algorithm types
$rijndael = New-Object "System.Security.Cryptography.RijndaelManaged"
$rijndael.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert

$tripleDes = New-Object "System.Security.Cryptography.TripleDESCryptoServiceProvider"
$tripleDes.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert

# [Type]::new() constructor pattern
$aesCsp = [System.Security.Cryptography.AesCryptoServiceProvider]::new()
$aesCsp.Mode = [System.Security.Cryptography.CipherMode]::ECB # $ Alert

# Partial/short type names
$aesShort = New-Object AesManaged
$aesShort.Mode = "ecb" # $ Alert

# Integer cipher mode values (ECB = 2)
$aes2 = [System.Security.Cryptography.Aes]::Create()
$aes2.Mode = 2 # $ Alert

# Safe: CBC mode (should not be flagged)
$aesSafe = [System.Security.Cryptography.Aes]::Create()
$aesSafe.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aesSafe.Mode = "cbc"
$aesSafe.Mode = 1
