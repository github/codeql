import csharp

class TypeRef extends @typeref {
  string toString() { hasName(result) }

  predicate hasName(string name) { typerefs(this, name) }

  Type getType() { typeref_type(this, result) }
}

class MissingType extends TypeRef {
  MissingType() { not exists(getType()) }
}

from
  Class class1, MissingType class2, MissingType class3, MissingType class4, MissingType class5,
  MissingType del2, Field a, Method b, Method c, Method d, Method e, Method f, Method g
where
  class1.hasQualifiedName("Assembly1.Class1") and
  class2.hasName("Class2") and
  class3.hasName("Class3") and
  class4.hasName("Class4") and
  class5.hasName("Class5") and
  del2.hasName("del2") and
  a.hasName("a") and
  b.hasName("b") and
  c.hasName("c") and
  d.hasName("d") and
  e.hasName("e") and
  f.hasName("f") and
  g.hasName("g") and
  a.getDeclaringType() = class1 and
  a.getDeclaringType() = class1 and
  b.getDeclaringType() = class1 and
  c.getDeclaringType() = class1 and
  not exists(c.getParameter(0).getType()) and
  not exists(a.getType()) and
  not exists(b.getReturnType()) and
  not exists(c.getReturnType()) and
  not exists(e.getReturnType()) and
  not exists(g.getReturnType()) and
  not exists(g.getParameter(0).getType())
select "Test passed"
