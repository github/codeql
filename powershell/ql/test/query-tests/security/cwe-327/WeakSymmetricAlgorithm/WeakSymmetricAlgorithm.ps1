# WeakSymmetricAlgorithm.Tests.ps1
# PowerShell version of WeakSymmetricAlgorithm security tests
# Tests for detection of weak symmetric encryption algorithm usage

using namespace System.Security.Cryptography

<#
.SYNOPSIS
    Test RC2 creation - BAD: RC2 is a weak symmetric algorithm
#>
function Test-CreateRC2 {
    [CmdletBinding()]
    param()
    
    # BAD: RC2 created
    $r1 = [System.Security.Cryptography.RC2]::Create()
    
    # BAD: RC2 created via SymmetricAlgorithm
    $r2 = [System.Security.Cryptography.SymmetricAlgorithm]::Create("RC2")
    
    # BAD: RC2 created with explicit name
    $r3 = [System.Security.Cryptography.RC2]::Create("RC2")
    
    # BAD: RC2 created with full type name
    $r4 = [System.Security.Cryptography.SymmetricAlgorithm]::Create("System.Security.Cryptography.RC2")
    
    # BAD: RC2CryptoServiceProvider created
    $r5 = New-Object System.Security.Cryptography.RC2CryptoServiceProvider
    
    # BAD: RC2 created using CryptoConfig.CreateFromName
    $r6 = [System.Security.Cryptography.CryptoConfig]::CreateFromName("RC2")
    
    return $r5
}

<#
.SYNOPSIS
    Test AES creation - GOOD: AES is an approved symmetric algorithm
#>
function Test-CreateAES {
    [CmdletBinding()]
    param()
    
    # GOOD: AES created
    $a1 = [System.Security.Cryptography.Aes]::Create()
    
    # GOOD: AES created via SymmetricAlgorithm
    $a2 = [System.Security.Cryptography.SymmetricAlgorithm]::Create("AES")
    
    # GOOD: AES created with full type name
    $a3 = [System.Security.Cryptography.SymmetricAlgorithm]::Create("System.Security.Cryptography.Aes")
    
    return $a1
}

<#
.SYNOPSIS
    Test weak algorithm with encryption - BAD: Using DES for actual encryption
#>
function Test-EncryptWithDES {
    [CmdletBinding()]
    param(
        [string]$PlainText = "Test data to encrypt"
    )
    
    # BAD: Using DES for encryption
    $des = New-Object System.Security.Cryptography.DESCryptoServiceProvider
    $des.GenerateKey()
    $des.GenerateIV()
    
    $encryptor = $des.CreateEncryptor()
    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    
    $ms = New-Object System.IO.MemoryStream
    $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
    $cs.Write($plainBytes, 0, $plainBytes.Length)
    $cs.FlushFinalBlock()
    
    $encrypted = $ms.ToArray()
    
    $cs.Dispose()
    $ms.Dispose()
    $encryptor.Dispose()
    $des.Dispose()
    
    return $encrypted
}

<#
.SYNOPSIS
    Test approved algorithm with encryption - GOOD: Using AES for encryption
#>
function Test-EncryptWithAES {
    [CmdletBinding()]
    param(
        [string]$PlainText = "Test data to encrypt"
    )
    
    # GOOD: Using AES for encryption
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.GenerateKey()
    $aes.GenerateIV()
    
    $encryptor = $aes.CreateEncryptor()
    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    
    $ms = New-Object System.IO.MemoryStream
    $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
    $cs.Write($plainBytes, 0, $plainBytes.Length)
    $cs.FlushFinalBlock()
    
    $encrypted = $ms.ToArray()
    
    $cs.Dispose()
    $ms.Dispose()
    $encryptor.Dispose()
    $aes.Dispose()
    
    return $encrypted
}
