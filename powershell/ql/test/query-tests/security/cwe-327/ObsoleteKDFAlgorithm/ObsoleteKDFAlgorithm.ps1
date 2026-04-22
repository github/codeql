# ObsoleteKDFAlgorithm.Tests.ps1
# PowerShell version of ObsoleteKDFAlgorithm security tests
# Tests for detection of obsolete key derivation algorithms

using namespace System.Security.Cryptography

<#
.SYNOPSIS
    Test PasswordDeriveBytes CryptDeriveKey - BAD: Uses obsolete algorithm PBKDF1
#>
function Test-PasswordDeriveBytesCryptDeriveKey {
    [CmdletBinding()]
    param()
    
    $password = "TestPassword123"
    $salt = New-Object byte[] 8
    $iv = New-Object byte[] 8
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($salt)
    $rng.GetBytes($iv)
    $rng.Dispose()
    
    # BAD: Using PasswordDeriveBytes.CryptDeriveKey
    $pdb = New-Object System.Security.Cryptography.PasswordDeriveBytes($password, $salt)

    try {
        $key = $pdb.CryptDeriveKey("TripleDES", "SHA1", 192, $iv)
        return $key
    }
    catch {
        Write-Warning "CryptDeriveKey not available: $_"
        return $null
    }
    finally {
        $pdb.Dispose()
    }
}

<#
.SYNOPSIS
    Test Rfc2898DeriveBytes usage - BAD: Uses obsolete algorithm PBKDF1
#>
function Test-Rfc2898DeriveBytes {
    [CmdletBinding()]
    param()
    
    $password = "TestPassword123"
    $salt = New-Object byte[] 8
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($salt)
    $rng.Dispose()
    
    $kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($password, $salt)
    
    try {
        $key = $kdf.CryptDeriveKey("TripleDES", "SHA1", 192, $iv)
        return $key
    }
    catch {
        Write-Warning "CryptDeriveKey not available: $_"
        return $null
    }
    finally {
        $kdf.Dispose()
    }
    
    return $key
}