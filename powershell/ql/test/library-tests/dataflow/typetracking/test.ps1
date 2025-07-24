class MyClass {
    [string] $field
    MyClass($val) {
        $this.field = $val
    }
}

$myClass = [MyClass]::new("hello")

Sink $myClass # $ type=myclass


$withNamedArg = New-Object -TypeName PSObject

Sink $withNamedArg # $ type=PSObject

$withPositionalArg = New-Object PSObject

Sink $withPositionalArg # $ type=PSObject
