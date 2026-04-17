# https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-ntlm-blocking?tabs=powershell

#Bad Examples

Set-SmbServerConfiguration -Smb2DialectMin None # $ Alert

Set-SmbClientConfiguration -Smb2DialectMin SMB210 # $ Alert

Set-SmbServerConfiguration -encryptdata $false -rejectunencryptedaccess $false # $ Alert Alert

Set-SmbClientConfiguration -RequireEncryption $false # $ Alert

Set-SMbClientConfiguration -BlockNTLM $false # $ Alert

Set-SMbClientConfiguration -BlockNTLM $false -RequireEncryption $false -Smb2DialectMin SMB210 # $ Alert Alert Alert

Set-SmbServerConfiguration -Smb2DialectMin None -encryptdata $false -rejectunencryptedaccess $false # $ Alert Alert Alert

#Good Examples

Set-SmbServerConfiguration -Smb2DialectMin SMB300

Set-SmbClientConfiguration -Smb2DialectMin SMB300

Set-SmbServerConfiguration -encryptdata $true -rejectunencryptedaccess $true

Set-SmbClientConfiguration -RequireEncryption $true

Set-SMbClientConfiguration -BlockNTLM $true 

