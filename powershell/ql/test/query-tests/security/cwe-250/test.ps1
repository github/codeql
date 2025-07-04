Set-ExecutionPolicy Bypass # BAD
Set-ExecutionPolicy RemoteSigned # GOOD
Set-ExecutionPolicy Bypass -Scope Process # GOOD
Set-ExecutionPolicy RemoteSigned -Scope Process # GOOD
Set-ExecutionPolicy Bypass -Scope MachinePolicy # BAD