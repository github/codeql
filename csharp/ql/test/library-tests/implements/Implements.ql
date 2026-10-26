import csharp

from Overridable o1, Overridable o2
where
  o1.overridesOrImplements(o2) and
  o1.fromSource() and
  o2.fromSource()
select o1, o1.getDeclaringType(), o2, o2.getDeclaringType()
