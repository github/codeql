import java

from Method c, Method d
where
  c.getSourceDeclaration().fromSource() and
  c.overrides(d)
select c.getDeclaringType(), c.getStringSignature(), d.getDeclaringType(), d.getStringSignature()
