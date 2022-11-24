import java

from Method m
where
  m.getDeclaringType().getName() = ["Test", "CharSequence"] and
  m.getName() = ["toString", "equals", "hashCode"]
select m.getName(), m.getDeclaringType().getQualifiedName()
