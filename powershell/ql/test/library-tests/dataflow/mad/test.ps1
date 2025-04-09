$x = Source "1"
$y = [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($x)
Sink $y # $ hasTaintFlow=1