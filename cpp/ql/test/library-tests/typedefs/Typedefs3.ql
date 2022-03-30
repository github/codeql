import cpp

string describe(TypedefType t) {
  t instanceof LocalTypedefType and
  result = "LocalTypedefType"
  or
  t instanceof NestedTypedefType and
  result = "NestedTypedefType"
  or
  t.(NestedTypedefType).hasSpecifier("private") and
  result = "(NestedTypedefType).isPrivate()"
  or
  t.(NestedTypedefType).hasSpecifier("protected") and
  result = "(NestedTypedefType).isProtected()"
  or
  t.(NestedTypedefType).hasSpecifier("public") and
  result = "(NestedTypedefType).isPublic()"
  or
  exists(Type base |
    base = t.getBaseType() and
    (
      result = "getBaseType() = " + base.(Declaration).getQualifiedName()
      or
      not base instanceof Declaration and
      result = "getBaseType() = " + base.toString()
    )
  )
  or
  exists(Class c |
    c.getAMember() = t and
    result = "member of " + c.toString()
  )
}

from TypedefType t
select t, t.getQualifiedName(), concat(describe(t), ", ")
