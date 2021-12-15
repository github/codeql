import cpp

from Function f, Attribute a, int i
where
  a = f.getAnAttribute() and
  a.hasName("availability")
select f.getName(), i, a.getArgument(i)
