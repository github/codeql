import csharp

from Literal l, Class c
where
  c.hasName("Literals") and
  l = c.getAField().getInitializer()
select l, l.getValue()
