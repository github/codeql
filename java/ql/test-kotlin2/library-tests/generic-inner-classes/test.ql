import java

query predicate callArgs(Call gc, Expr arg, int idx) {
  arg.getParent() = gc and idx = arg.getIndex()
}

query predicate genericTypes(GenericType rt, TypeVariable param) {
  rt.getPackage().getName() = "testuser" and
  param = rt.getATypeParameter()
}

query predicate paramTypes(ParameterizedType rt, string typeArg) {
  rt.getPackage().getName() = "testuser" and
  typeArg = rt.getATypeArgument().toString()
}

query predicate constructors(Constructor c) {
  c.getDeclaringType().getPackage().getName() = "testuser"
}

query predicate nestedTypes(NestedType nt, RefType parent) {
  nt.getPackage().getName() = "testuser" and
  parent = nt.getEnclosingType()
}

from ClassInstanceExpr cie
where cie.getFile().isSourceFile()
select cie, cie.getConstructedType(), cie.getConstructor(), cie.getATypeArgument()
