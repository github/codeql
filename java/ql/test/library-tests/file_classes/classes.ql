import java

from Class c
where c.fromSource()
select c, any(boolean b | if c.isFileClass() then b = true else b = false)
