import csharp

private class KnownType extends Type {
  KnownType() { not this instanceof UnknownType }
}

class TypeRef extends @typeref {
  string toString() { this.hasName(result) }

  predicate hasName(string name) { typerefs(this, name) }

  KnownType getType() { typeref_type(this, result) }
}

class MissingType extends TypeRef {
  MissingType() { not exists(this.getType()) }
}

from
  Class class1, MissingType class2, MissingType class3, MissingType class4, MissingType class5,
  MissingType del2, Field a, Method b, Method c, Method d, Method e, Method f, Method g
where
  class1.hasFullyQualifiedName("Assembly1", "Class1") and
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
  b.getDeclaringType() = class1 and
  c.getDeclaringType() = class1 and
  not exists(c.getParameter(0).getType().(KnownType)) and
  not exists(a.getType().(KnownType)) and
  not exists(b.getReturnType().(KnownType)) and
  not exists(c.getReturnType().(KnownType)) and
  not exists(e.getReturnType().(KnownType)) and
  not exists(g.getReturnType().(KnownType)) and
  not exists(g.getParameter(0).getType().(KnownType))
select "Test passed"
