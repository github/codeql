
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
$aesManaged.Mode = "ecb"

# Other symmetric algorithm types
$rijndael = New-Object "System.Security.Cryptography.RijndaelManaged"
$rijndael.Mode = [System.Security.Cryptography.CipherMode]::ECB

$tripleDes = New-Object "System.Security.Cryptography.TripleDESCryptoServiceProvider"
$tripleDes.Mode = [System.Security.Cryptography.CipherMode]::ECB

# [Type]::new() constructor pattern
$aesCsp = [System.Security.Cryptography.AesCryptoServiceProvider]::new()
$aesCsp.Mode = [System.Security.Cryptography.CipherMode]::ECB

# Partial/short type names
$aesShort = New-Object AesManaged
$aesShort.Mode = "ecb"

# Integer cipher mode values (ECB = 2)
$aes2 = [System.Security.Cryptography.Aes]::Create()
$aes2.Mode = 2

# Safe: CBC mode (should not be flagged)
$aesSafe = [System.Security.Cryptography.Aes]::Create()
$aesSafe.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aesSafe.Mode = "cbc"
$aesSafe.Mode = 1
