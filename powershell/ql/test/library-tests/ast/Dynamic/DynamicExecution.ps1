$foo = 'cmd.exe'
Invoke-Expression $foo
[scriptblock]::Create($foo)
& ([scriptblock]::Create($foo))
&"$foo"