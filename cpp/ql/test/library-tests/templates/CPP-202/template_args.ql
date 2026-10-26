import cpp

from Class c, string arg
where
  if exists(c.getATemplateArgument())
  then arg = c.getATemplateArgument().toString()
  else arg = "<none>"
select c, arg
