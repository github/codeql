import cpp

from string name, Type arg
where
  exists(Function f | name = f.getName() and arg = f.getATemplateArgument())
  or
  exists(Class c | name = c.getName() and arg = c.getATemplateArgument())
select name, arg.explain()
