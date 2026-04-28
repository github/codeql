Function Invoke-MyRemoteCommand ()
{
    Invoke-Command -Port 343 -ComputerName hardcoderemotehostname # $ Alert
}

Function Invoke-MyCommand ($ComputerName)
{
    Invoke-Command -Port 343 -ComputerName $ComputerName
}

Function Invoke-MyLocalCommand ()
{
    Invoke-Command -Port 343 -ComputerName hardcodelocalhostname # $ Alert
}

Function Invoke-MyLocalCommand ()
{
    Invoke-Command -Port 343 -ComputerName $env:COMPUTERNAME
}