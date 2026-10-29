import java

from Annotatable a, Annotation ann
where
  (
    a.(Method).hasQualifiedName("java.lang", "Character", "isJavaLetter") or
    a.(ClassOrInterface).fromSource()
  ) and
  ann = a.getAnAnnotation() and
  ann.getType().getName() = "Deprecated"
select a.toString(), a.getAnAnnotation().getType().getQualifiedName()
