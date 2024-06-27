import java

from ClassOrInterface c, CompanionObject cco, Field f
where
  c.fromSource() and
  cco = c.getCompanionObject() and
  f = cco.getInstance()
select c, f, cco, f.getDeclaringType(), concat(f.getAModifier().toString(), ",")
