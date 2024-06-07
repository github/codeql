import java

from Class c
where exists(c.getLocation().getFile().getRelativePath())
select c, any(boolean b | if c.isFileClass() then b = true else b = false)
