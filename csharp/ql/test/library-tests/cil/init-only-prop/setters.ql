import semmle.code.cil.Method
import semmle.code.csharp.Location

private string getType(Setter s) { if s.isInitOnly() then result = "init" else result = "set" }

from Setter s
where s.getLocation().(Assembly).getName() = "cil-init-prop"
select s, getType(s)
