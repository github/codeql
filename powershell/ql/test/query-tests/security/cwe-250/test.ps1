Set-ExecutionPolicy Bypass -Force # BAD
Set-ExecutionPolicy RemoteSigned -Force # GOOD
Set-ExecutionPolicy Bypass -Scope Process -Force # GOOD
Set-ExecutionPolicy RemoteSigned -Scope Process -Force # GOOD
Set-ExecutionPolicy Bypass -Scope MachinePolicy -Force # BAD

Set-ExecutionPolicy Bypass -Force:$true # BAD
Set-ExecutionPolicy Bypass -Force:$false # GOOD

Set-ExecutionPolicy Bypass # GOOD
Set-ExecutionPolicy RemoteSigned # GOOD
Set-ExecutionPolicy Bypass -Scope Process # GOOD
Set-ExecutionPolicy RemoteSigned -Scope Process # GOOD
Set-ExecutionPolicy Bypass -Scope MachinePolicy # GOOD