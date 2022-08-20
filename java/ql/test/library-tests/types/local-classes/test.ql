import java

from ClassOrInterface ci
where
  ci.getSourceDeclaration().fromSource() and
  ci.isLocal()
select ci
