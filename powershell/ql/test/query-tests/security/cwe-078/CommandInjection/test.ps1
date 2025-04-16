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

#TODO: currently a FN
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
Invoke-ScriptBlockInjection1 -UserInput $input  
Invoke-ScriptBlockInjection2 -UserInput $input  
Invoke-MethodInjection1 -UserInput $input  
Invoke-MethodInjection2 -UserInput $input  
Invoke-MethodInjection3 -UserInput $input  
Invoke-PropertyInjection -UserInput $input  
Invoke-ExpandStringInjection1 -UserInput $input  
Invoke-ExpandStringInjection2 -UserInput $input

#typed input
function Invoke-InvokeExpressionInjectionSafe1
{
    param([int] $UserInput)
    Invoke-Expression "Get-Process -Name $UserInput"
}

#single quotes to treat them as string literal
function Invoke-InvokeExpressionInjectionSafe2
{
    param($UserInput)
    Invoke-Expression "Get-Process -Name '$UserInput'"
}
#EscapeSingleQuotedStringContent API
function Invoke-InvokeExpressionInjectionSafe3
{
    param([int] $UserInput)

    $UserInputClean = [System.Management.Automation.Language.CodeGeneration]::
        EscapeSingleQuotedStringContent("$UserInput")
    Invoke-Expression "Get-Process -Name $UserInputClean"
}

#EscapeSingleQuotedStringContent API 2
function Invoke-InvokeExpressionInjectionSafe4
{
    param([int] $UserInput)

    $UserInputClean = [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent("$UserInput")
    Invoke-Expression "Get-Process -Name $UserInputClean"
}

Invoke-InvokeExpressionInjectionSafe1 -UserInput $input 
Invoke-InvokeExpressionInjectionSafe2 -UserInput $input 
Invoke-InvokeExpressionInjectionSafe3 -UserInput $input 
Invoke-InvokeExpressionInjectionSafe4 -UserInput $input 