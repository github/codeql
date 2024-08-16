function ExecuteAThing {
    param (
        $userInput
    )
    $foo = 'cmd.exe' + $userInput;
    Invoke-Expression $foo
    [scriptblock]::Create($foo)
    & ([scriptblock]::Create($foo))
    &"$foo"
    & 'cmd.exe' @($userInput)
}