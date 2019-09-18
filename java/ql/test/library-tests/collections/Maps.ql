import default
import semmle.code.java.Maps

from Variable v, MapType mt
where
  v.fromSource() and
  mt = v.getType()
select v, mt.toString(), mt.getKeyType().getQualifiedName(), mt.getValueType().getQualifiedName()
