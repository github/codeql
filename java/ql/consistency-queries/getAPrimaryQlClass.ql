import java

from Top t
where t.getAPrimaryQlClass() = "???"
  // TypeBound doesn't extend Top (but probably should)
  and not t instanceof TypeBound
  // XMLLocatable doesn't extend Top (but probably should)
  and not t instanceof XMLLocatable
select t,
       concat(t.getAPrimaryQlClass(), ",")
