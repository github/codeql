import java

from ClassObject co, Field f
where
  co.fromSource() and
  f = co.getInstance()
select co, f, concat(f.getAModifier().toString(), ",")
