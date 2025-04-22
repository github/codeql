$UserInput = Read-Host 'Please enter your secure code'
$EncryptedInput = ConvertTo-SecureString -String $UserInput -AsPlainText -Force

$SecureUserInput = Read-Host 'Please enter your secure code' -AsSecureString