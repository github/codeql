using namespace System.Security.Cryptography

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