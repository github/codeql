import cpp

string describeType(Type t) {
  t instanceof TypedefType and
  result = "TypedefType"
  or
  t instanceof PointerType and
  result = "PointerType"
  or
  t instanceof VoidPointerType and
  result = "VoidPointerType"
  or
  t instanceof ReferenceType and
  result = "ReferenceType"
  or
  exists(Type base |
    base = t.(DerivedType).getBaseType() and
    result = "base: " + base.getName()
  )
  or
  t instanceof IntType and
  result = "IntType"
  or
  t instanceof CharType and
  result = "CharType"
  or
  t instanceof DoubleType and
  result = "DoubleType"
  or
  t instanceof Size_t and
  result = "Size_t"
  or
  t instanceof Ssize_t and
  result = "Ssize_t"
  or
  t instanceof Ptrdiff_t and
  result = "Ptrdiff_t"
  or
  t instanceof Wchar_t and
  result = "Wchar_t"
  or
  t.isConst() and
  result = "isConst"
}

string describeVar(Variable v) {
  v.isConst() and
  result = "isConst"
  or
  v instanceof LocalVariable and
  result = "LocalVariable"
  or
  v instanceof Parameter and
  result = "Parameter"
}

from Variable v, Type t
where v.getType() = t
select v, concat(describeVar(v), ", "), t, concat(describeType(t), ", ")
