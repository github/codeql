import java

from ClassOrInterface c, ClassCompanionObject cco, Field f
where c.fromSource()
  and cco = c.getCompanionObject()
  and f = cco.getInstance()
select c, f, cco, concat(f.getAModifier().toString(), ",")
