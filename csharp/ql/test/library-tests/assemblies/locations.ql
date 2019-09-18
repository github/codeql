import csharp

from Element e, Class c, Method m, Parameter p
where
  c.hasQualifiedName("Locations.Test") and
  m.getDeclaringType() = c and
  m.getAParameter() = p and
  (e = c or e = m or e = p)
select e
