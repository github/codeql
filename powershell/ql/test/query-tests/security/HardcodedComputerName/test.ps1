Function Invoke-MyRemoteCommand ()
{
    Invoke-Command -Port 343 -ComputerName hardcoderemotehostname
}

Function Invoke-MyCommand ($ComputerName)
{
    Invoke-Command -Port 343 -ComputerName $ComputerName
}

Function Invoke-MyLocalCommand ()
{
    Invoke-Command -Port 343 -ComputerName hardcodelocalhostname
}

Function Invoke-MyLocalCommand ()
{
    Invoke-Command -Port 343 -ComputerName $env:COMPUTERNAME
}