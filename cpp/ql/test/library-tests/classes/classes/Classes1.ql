import cpp

from Class c, string isFinal
where
  c.getName() != "__va_list_tag" and
  if c.isFinal() then isFinal = "final" else isFinal = "-----"
select c, isFinal
