import java

from Method m, RefType t
where
  t = m.getDeclaringType() and
  t.getName() = ["Enum", "Enum<?>", "Enum<E>", "EnumUserKt"]
select t.getQualifiedName(), t.getName(), m.getName()

query predicate enumConstants(EnumConstant ec) { ec.fromSource() }
