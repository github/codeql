import java

from Top t
where
  t.getAPrimaryQlClass() = "???" and
  // TypeBound doesn't extend Top (but probably should); part of Kotlin #6
  not t instanceof TypeBound and
  // XMLLocatable doesn't extend Top (but probably should); part of Kotlin #6
  not t instanceof XmlLocatable
select t, concat(t.getAPrimaryQlClass(), ",")
