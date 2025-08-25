import java

from Type t
where
  t.fromSource()
  or
  exists(TypeAccess ta | ta.fromSource() and ta.getType() = t)
select t.toString(), concat(t.getAPrimaryQlClass(), ", ")
