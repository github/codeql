import cpp

from Variable v
select v, any(boolean b | if v.isThreadLocal() then b = true else b = false)
