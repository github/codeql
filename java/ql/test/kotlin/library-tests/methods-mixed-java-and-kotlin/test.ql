import java

from Method m
where m.getName() = "foo"
select m, m.getQualifiedName(), m.getSignature(), m.getSourceDeclaration(),
  m.getSourceDeclaration().getQualifiedName()
