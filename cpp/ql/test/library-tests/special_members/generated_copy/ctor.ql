import cpp

from Class c
where
  not c.getName().charAt(0) = "_" and
  not c instanceof TemplateClass
select c.getQualifiedName(),
  any(string s | if c.implicitCopyConstructorDeleted() then s = "can NOT" else s = "can"),
  any(string s | if c.hasImplicitCopyConstructor() then s = "does" else s = "does NOT"),
  "have implicit copy constructor"
