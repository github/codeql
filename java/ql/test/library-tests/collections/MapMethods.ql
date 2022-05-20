import default
import semmle.code.java.Maps

from Call c, MapMethod mm
where mm = c.getCallee()
select c, mm.getDeclaringType().getQualifiedName() + "." + mm.getSignature(),
  mm.getReceiverKeyType().getQualifiedName(), mm.getReceiverValueType().getQualifiedName()
