import csharp

from Class c, Interface i
where
  c.getName().matches("Inheritance%") and
  i = c.getABaseInterface()
select c, i
