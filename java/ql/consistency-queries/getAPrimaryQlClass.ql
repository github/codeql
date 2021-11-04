import java

from Top t
where t.getAPrimaryQlClass() = "???"
  // TypeBound doesn't extend Top (but probably should)
  and not t instanceof TypeBound
  // XMLLocatable doesn't extend Top (but probably should)
  and not t instanceof XMLLocatable
  // Kotlin bug:
  and not t.(Type).toString() = "string"
select t,
       concat(t.getAPrimaryQlClass(), ",")
