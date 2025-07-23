# https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-ntlm-blocking?tabs=powershell

#Bad Examples

Set-SmbServerConfiguration -Smb2DialectMin None

Set-SmbClientConfiguration -Smb2DialectMin SMB210

Set-SmbServerConfiguration -encryptdata $false -rejectunencryptedaccess $false

Set-SmbClientConfiguration -RequireEncryption $false

Set-SMbClientConfiguration -BlockNTLM $false 

Set-SMbClientConfiguration -BlockNTLM $false -RequireEncryption $false -Smb2DialectMin SMB210 

Set-SmbServerConfiguration -Smb2DialectMin None -encryptdata $false -rejectunencryptedaccess $false

#Good Examples

Set-SmbServerConfiguration -Smb2DialectMin SMB300

Set-SmbClientConfiguration -Smb2DialectMin SMB300

Set-SmbServerConfiguration -encryptdata $true -rejectunencryptedaccess $true

Set-SmbClientConfiguration -RequireEncryption $true

Set-SMbClientConfiguration -BlockNTLM $true 

