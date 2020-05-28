import csharp

query predicate test1(UnboundGenericDelegateType d) {
  d.hasName("GenericDelegate<>") and
  d.getTypeParameter(0).hasName("T") and
  d.getParameter(0).getType().hasName("T")
}

query predicate test2(Class c) {
  c.hasName("A") and
  not c instanceof UnboundGenericClass
}

query predicate test3(ConstructedClass c, UnboundGenericClass d) {
  d.hasName("A<>") and
  c.getTypeArgument(0).hasName("X") and
  c.getTypeArgument(0) instanceof TypeParameter and
  c.getUnboundGeneric() = d
}

query predicate test4(UnboundGenericClass c, string s) {
  c.fromSource() and
  not c.getName().matches("%<%>") and
  s = "Unbound generic class with inconsistent name"
}

query predicate test5(ConstructedClass c, string s) {
  c.fromSource() and
  not c.getName().matches("%<%>") and
  s = "Constructed class with inconsistent name"
}

query predicate test6(ConstructedClass at, UnboundGenericClass b, ConstructedClass bt, Field f) {
  at.hasName("A<T>") and
  b.hasName("B<>") and
  bt.hasName("B<X>") and
  at.getTypeArgument(0).hasName("T") and
  at.getTypeArgument(0) instanceof TypeParameter and
  at.getTypeArgument(0) = b.getTypeParameter(0) and
  bt.getUnboundGeneric() = b and
  f.getDeclaringType() = b and
  f.getType() = at
}

query predicate test7(ConstructedClass aString, ConstructedClass bString) {
  aString.hasName("A<String>") and
  bString.hasName("B<String>") and
  aString.getSourceDeclaration().hasName("A<>") and
  bString.getSourceDeclaration().hasName("B<>")
}

query predicate test8(ConstructedClass bString, Method m) {
  bString.hasName("B<String>") and
  m.getDeclaringType() = bString and
  m.hasName("fooParams") and
  m.getParameter(0).getType().(ArrayType).getElementType() instanceof StringType and
  m.getSourceDeclaration().getDeclaringType() = m.getDeclaringType().getSourceDeclaration()
}

query predicate test9(ConstructedClass bString, Setter sourceSetter, Setter setter) {
  exists(Property p |
    bString.hasName("B<String>") and
    p.getDeclaringType() = bString and
    p.hasName("Name") and
    p.getSourceDeclaration().getDeclaringType() = p.getDeclaringType().getSourceDeclaration() and
    p.getSetter().getParameter(0).getType() instanceof StringType and
    p.getSetter().getSourceDeclaration() = p.getSourceDeclaration().getSetter() and
    p.getGetter().getSourceDeclaration() = p.getSourceDeclaration().getGetter() and
    sourceSetter = p.getSourceDeclaration().getSetter() and
    setter = p.getSetter()
  )
}

query predicate test10(ConstructedClass bString, Event e) {
  bString.hasName("B<String>") and
  e.getDeclaringType() = bString and
  e.hasName("myEvent") and
  e.getSourceDeclaration().getDeclaringType() = e.getDeclaringType().getSourceDeclaration() and
  e.getType().(ConstructedDelegateType).getTypeArgument(0) instanceof StringType and
  e.getAddEventAccessor().getSourceDeclaration() = e.getSourceDeclaration().getAddEventAccessor() and
  e.getRemoveEventAccessor().getSourceDeclaration() =
    e.getSourceDeclaration().getRemoveEventAccessor()
}

query predicate test11(ConstructedClass bString, Operator o) {
  bString.hasName("B<String>") and
  o.getDeclaringType() = bString and
  o instanceof IncrementOperator and
  o.getSourceDeclaration().getDeclaringType() = o.getDeclaringType().getSourceDeclaration()
}

query predicate test12(ConstructedClass gridInt, Indexer i) {
  gridInt.hasName("Grid<Int32>") and
  i.getDeclaringType() = gridInt and
  i.getSourceDeclaration().getDeclaringType() = i.getDeclaringType().getSourceDeclaration() and
  i.getGetter().getSourceDeclaration() = i.getSourceDeclaration().getGetter() and
  i.getSetter().getSourceDeclaration() = i.getSourceDeclaration().getSetter()
}

query predicate test13(ConstructedClass gridInt, Indexer i) {
  gridInt.hasName("Grid<Int32>") and
  i.getDeclaringType() = gridInt and
  i.getType() instanceof IntType
}

query predicate test14(UnboundGenericClass gridInt, Indexer i) {
  gridInt.hasName("Grid<>") and
  i.getDeclaringType() = gridInt and
  i.getType() instanceof IntType
}

query predicate test15(ConstructedDelegateType d) {
  d.hasName("GenericDelegate<String>") and
  d.getTypeArgument(0) instanceof StringType and
  d.getParameter(0).getType() instanceof StringType
}

query predicate test16(Class c, Method m) {
  c.hasName("Subtle") and
  count(c.getAMethod()) = 3 and
  m = c.getAMethod()
}

query predicate test17(
  Class c, TypeParameter p, UnboundGenericMethod m, TypeParameter q, UnboundGenericMethod n,
  int numParams
) {
  c.hasName("Subtle") and
  m = c.getAMethod() and
  m.getATypeParameter() = p and
  n = c.getAMethod() and
  n.getATypeParameter() = q and
  m != n and
  p != q and
  numParams = m.getNumberOfParameters()
}

query predicate test18(
  Class c, Method m, Parameter p, int numArgs, string typeName, int numParams, int numTypes
) {
  c.getName().matches("A<%") and
  m = c.getAMethod() and
  p = m.getAParameter() and
  numArgs = count(m.(ConstructedMethod).getATypeArgument()) and
  typeName = p.getType().getName() and
  numParams = count(m.getAParameter()) and
  numTypes = count(m.getAParameter().getType())
}

/** Test that locations are populated for the type parameters of generic methods. */
query predicate test19(UnboundGenericMethod m, TypeParameter tp, int hasLoc) {
  m.hasName("fs") and
  tp = m.getATypeParameter() and
  if exists(tp.getLocation()) then hasLoc = 1 else hasLoc = 0
}

/** Test that locations are populated for unbound generic types. */
query predicate test20(UnboundGenericType t, string s) {
  not type_location(t, _) and s = "Missing location"
}

/**
 *  This tests a regression in the extractor where the following failed to extract:
 *
 *    class Foo<T>
 *    {
 *        enum E { a };
 *    }
 */
query predicate test21(Enum e, Class c) {
  c.hasName("Param<>") and
  e.hasName("E") and
  e.getDeclaringType() = c
}

query predicate test22(ConstructedMethod m, string tpName) {
  m.getName().matches("CM%") and
  tpName = m.getATypeArgument().getName()
}

query predicate test23(Class c, Interface i) {
  c.getName().matches("Inheritance%") and
  i = c.getABaseInterface()
}

query predicate test24(UnboundGenericInterface ugi, TypeParameter tp, string s) {
  ugi.fromSource() and
  ugi.getATypeParameter() = tp and
  (
    tp.isOut() and s = "out"
    or
    tp.isIn() and s = "in"
  )
}

query predicate test25(ConstructedMethod cm) {
  cm.hasName("CM3") and
  cm.getParameter(0).getType() instanceof DoubleType and
  cm.getParameter(1).getType() instanceof IntType and
  cm.getReturnType() instanceof DoubleType and
  exists(Method sourceDeclaration |
    sourceDeclaration = cm.getSourceDeclaration() and
    sourceDeclaration.getParameter(0).getType().(TypeParameter).hasName("T2") and
    sourceDeclaration.getParameter(1).getType().(TypeParameter).hasName("T1") and
    sourceDeclaration.getReturnType().(TypeParameter).hasName("T2")
  ) and
  exists(Method unbound |
    unbound = cm.getUnboundGeneric() and
    unbound.getParameter(0).getType().(TypeParameter).hasName("T2") and
    unbound.getParameter(1).getType() instanceof IntType and
    unbound.getReturnType().(TypeParameter).hasName("T2")
  )
}

query predicate test26(ConstructedGeneric cg, string s) {
  // Source declaration and unbound generic must be unique
  (
    strictcount(cg.getSourceDeclaration+()) > 1 or
    strictcount(cg.getUnboundGeneric()) > 1
  ) and
  s = "Non-unique source decl or unbound generic"
}

query predicate test27(ConstructedType ct, UnboundGenericType ugt, UnboundGenericType sourceDecl) {
  ct instanceof NestedType and
  ugt = ct.getUnboundGeneric() and
  sourceDecl = ct.getSourceDeclaration() and
  ugt != sourceDecl
}

query predicate test28(UnboundGeneric ug, string s) {
  ug.fromSource() and
  s = ug.getQualifiedNameWithTypes()
}

query predicate test29(ConstructedGeneric cg, string s) {
  cg.fromSource() and
  s = cg.getQualifiedNameWithTypes()
}

query predicate test30(Declaration d, string s) {
  d.fromSource() and
  d instanceof @generic and
  s = d.getQualifiedNameWithTypes() and
  d != d.getSourceDeclaration() and
  not d instanceof Generic
}

query predicate test31(ConstructedGeneric cg, string s) {
  not exists(cg.getUnboundGeneric()) and
  s = "Missing unbound generic"
}
