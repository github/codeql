function Invoke-InvokeExpressionInjection1
{
    param($UserInput)
    Invoke-Expression "Get-Process -Name $UserInput"
}

function Invoke-InvokeExpressionInjection2
{
    param($UserInput)
    iex "Get-Process -Name $UserInput"
}

function Invoke-InvokeExpressionInjection3
{
    param($UserInput)
    $executionContext.InvokeCommand.InvokeScript("Get-Process -Name $UserInput")
}

function Invoke-InvokeExpressionInjection4
{
    param($UserInput)
    $host.Runspace.CreateNestedPipeline("Get-Process -Name $UserInput", $false).Invoke()
}

function Invoke-InvokeExpressionInjection5
{
    param($UserInput)
    [PowerShell]::Create().AddScript("Get-Process -Name $UserInput").Invoke()
}

function Invoke-InvokeExpressionInjection6
{
    param($UserInput)
    Add-Type "public class Foo { $UserInput }"
}

function Invoke-InvokeExpressionInjection7
{
    param($UserInput)
    Add-Type -TypeDefinition "public class Foo { $UserInput }"
}

function Invoke-InvokeExpressionInjection8
{
    param($UserInput)

    $code = "public class Foo { $UserInput }"
    Add-Type -TypeDefinition $code
}

function Invoke-InvokeExpressionInjectionFP
{
    param($UserInput)

    $code = @"
    public class BasicTest
    {
      public static int Add(int a, int b)
        {
            return (a + b);
        }
      public int Multiply(int a, int b)
        {
        return (a * b);
        }
    }
"@
    Add-Type -TypeDefinition $code
}

function Invoke-ExploitableCommandInjection1
{
    param($UserInput)

    powershell -command "Get-Process -Name $UserInput"
}

function Invoke-ExploitableCommandInjection2
{
    param($UserInput)

    powershell "Get-Process -Name $UserInput"
}

function Invoke-ExploitableCommandInjection3
{
    param($UserInput)

    cmd /c "ping $UserInput"
}

#Allowed
function Invoke-ExploitableCommandInjectionFP
{
    param($UserInput)

    cmd /c "ping localhost"
}

function Invoke-ScriptBlockInjection1
{
    param($UserInput)

    ## Often used when making remote connections

    $sb = [ScriptBlock]::Create("Get-Process -Name $UserInput")
    Invoke-Command RemoteServer $sb
}

function Invoke-ScriptBlockInjection2
{
    param($UserInput)

    ## Often used when making remote connections

    $sb = $executionContext.InvokeCommand.NewScriptBlock("Get-Process -Name $UserInput")
    Invoke-Command RemoteServer $sb
}

function Invoke-MethodInjection1
{
    param($UserInput)

    Get-Process | Foreach-Object $UserInput
}

function Invoke-MethodInjection2
{
    param($UserInput)

    (Get-Process -Id $pid).$UserInput()
}

function Invoke-MethodInjection3
{
    param($UserInput)

    (Get-Process -Id $pid).$UserInput.Invoke()
}

#ALLOWED , uses script block
function Invoke-MethodInjectionFP1
{
    param($UserInput)

    Get-Process | Foreach-Object { $_.Name }
}
#ALLOWED, uses constant member access
function Invoke-MethodInjectionFP2
{
    param($UserInput)

    Get-Process | Foreach-Object "Name"
}

function Invoke-PropertyInjection
{
    param($UserInput)

    [DateTime]::$UserInput
}

function Invoke-ExpandStringInjection1
{
    param($UserInput)

    ## Used to attempt a variable resolution
    $executionContext.InvokeCommand.ExpandString($UserInput)
}

function Invoke-ExpandStringInjection2
{
    param($UserInput)

    ## Used to attempt a variable resolution
    $executionContext.SessionState.InvokeCommand.ExpandString($UserInput)
}

function Invoke-UnsafeEscape1
{
    param($UserInput)

    $escaped = $UserInput -replace "'", "''"
    Invoke-Expression "Get-Process -Name '$escaped'"
}

function Invoke-UnsafeEscape2
{
    param($UserInput)

    $escaped = $UserInput -replace '"', '`"'
    Invoke-Expression "Get-Process -Name `"$escaped`""
}

$input = Read-Host "enter input"

Invoke-InvokeExpressionInjection1 -UserInput $input  
Invoke-InvokeExpressionInjection2 -UserInput $input  
Invoke-InvokeExpressionInjection3 -UserInput $input  
Invoke-InvokeExpressionInjection4 -UserInput $input  
Invoke-InvokeExpressionInjection5 -UserInput $input  
Invoke-InvokeExpressionInjection6 -UserInput $input  
Invoke-InvokeExpressionInjection7 -UserInput $input  
Invoke-InvokeExpressionInjection8 -UserInput $input  
Invoke-InvokeExpressionInjectionFP -UserInput $input  
Invoke-ExploitableCommandInjection1 -UserInput $input  
Invoke-ExploitableCommandInjection2 -UserInput $input  
Invoke-ExploitableCommandInjection3 -UserInput $input  
Invoke-ExploitableCommandInjectionFP -UserInput $input  
Invoke-ScriptBlockInjection1 -UserInput $input  
Invoke-ScriptBlockInjection2 -UserInput $input  
Invoke-MethodInjection1 -UserInput $input  
Invoke-MethodInjection2 -UserInput $input  
Invoke-MethodInjection3 -UserInput $input  
Invoke-MethodInjectionFP1 -UserInput $input  
Invoke-MethodInjectionFP2 -UserInput $input  
Invoke-PropertyInjection -UserInput $input  
Invoke-ExpandStringInjection1 -UserInput $input  
Invoke-ExpandStringInjection2 -UserInput $input  
Invoke-UnsafeEscape1 -UserInput $input  
Invoke-UnsafeEscape2 -UserInput $input