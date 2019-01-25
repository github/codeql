import cpp

from Function f
select f, f.getFullSignature(),
       any(boolean b | if f.isDeclaredConstexpr() then b = true else b = false),
       any(boolean b | if f.isConstexpr() then b = true else b = false)
