import java

query predicate callArgs(Call gc, Expr arg, int idx) {
  arg.getParent() = gc and idx = arg.getIndex()
}

query predicate genericTypes(GenericType rt, TypeVariable param) {
  rt.getPackage().getName() = "extlib" and
  param = rt.getATypeParameter()
}

query predicate paramTypes(ParameterizedType rt, string typeArg) {
  rt.getPackage().getName() = "extlib" and
  typeArg = rt.getATypeArgument().toString()
}

query predicate constructors(Constructor c, string signature) {
  c.getDeclaringType().getPackage().getName() = "extlib" and
  signature = c.getSignature()
}

query predicate methods(Method m, RefType declType, string signature) {
  declType = m.getDeclaringType() and
  signature = m.getSignature() and
  declType.getPackage().getName() = "extlib"
}

query predicate nestedTypes(NestedType nt, RefType parent) {
  nt.getPackage().getName() = "extlib" and
  parent = nt.getEnclosingType()
}

query predicate javaKotlinCalleeAgreement(MethodCall javaMa, MethodCall kotlinMa, Callable callee) {
  javaMa.getCallee() = callee and
  kotlinMa.getCallee() = callee and
  javaMa.getFile().getExtension() = "java" and
  kotlinMa.getFile().getExtension() = "kt"
}

query predicate javaKotlinConstructorAgreement(
  ClassInstanceExpr javaCie, ClassInstanceExpr kotlinCie, Constructor constructor
) {
  javaCie.getConstructor() = constructor and
  kotlinCie.getConstructor() = constructor and
  javaCie.getFile().getExtension() = "java" and
  kotlinCie.getFile().getExtension() = "kt"
}

query predicate javaKotlinLocalTypeAgreement(
  LocalVariableDecl javaDecl, LocalVariableDecl kotlinDecl, RefType agreedType
) {
  javaDecl.getType() = agreedType and
  kotlinDecl.getType() = agreedType and
  javaDecl.getFile().getExtension() = "java" and
  kotlinDecl.getFile().getExtension() = "kt" and
  agreedType.getPackage().getName() = "extlib"
}

from ClassInstanceExpr cie
where cie.getFile().isSourceFile()
select cie, cie.getConstructedType(), cie.getConstructor(), cie.getATypeArgument()
