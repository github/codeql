$UserInput = Read-Host 'Please enter your secure code'
$EncryptedInput = ConvertTo-SecureString -String $UserInput -AsPlainText -Force # $ Alert

$SecureUserInput = Read-Host 'Please enter your secure code' -AsSecureString