import java

from EnumType e, string isFinal
where
  e.fromSource() and
  if e.isFinal() then isFinal = "final" else isFinal = "not final"
select e, isFinal
