class MyClass {
    [string] $field
    MyClass($val) {
        $this.field = $val
    }
}

$myClass = [MyClass]::new("hello")

Sink $myClass # $ MISSING: type=MyClass


$withNamedArg = New-Object -TypeName PSObject

Sink $withNamedArg # $ MISSING: type=PSObject

$withPositionalArg = New-Object PSObject

Sink $withPositionalArg # $ MISSING: type=PSObject
