import cpp

from Variable v
select v, any(boolean b | if v.isConstexpr() then b = true else b = false)
