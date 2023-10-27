import java

from Method m, Type t
where
  t = m.getDeclaringType() and
  t.getName() = ["Enum<E>", "EnumUserKt"]
select t.getName(), m.getName()

query predicate enumConstants(EnumConstant ec) { ec.fromSource() }
