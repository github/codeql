import java

string paramTypeIfPresent(Callable m) {
  if exists(m.getAParamType())
  then result = m.getAParamType().toString()
  else result = "No parameters"
}

query predicate calls(
  MethodCall ma, Callable caller, RefType callerType, Callable called, RefType calledType
) {
  ma.getEnclosingCallable() = caller and
  ma.getCallee() = called and
  caller.fromSource() and
  callerType = caller.getDeclaringType() and
  calledType = called.getDeclaringType()
}

query predicate constructors(
  RefType t, Constructor c, string signature, string paramType, string returnType,
  RefType sourceDeclType, Constructor sourceDecl
) {
  t.getSourceDeclaration().fromSource() and
  c.getDeclaringType() = t and
  signature = c.getSignature() and
  paramType = paramTypeIfPresent(c) and
  returnType = c.getReturnType().toString() and
  sourceDecl = c.getSourceDeclaration() and
  sourceDeclType = sourceDecl.getDeclaringType()
}

query predicate constructorCalls(ConstructorCall cc, Constructor callee) {
  callee = cc.getConstructor() and
  callee.getSourceDeclaration().fromSource()
}

query predicate refTypes(RefType rt) { rt.fromSource() }

from RefType t, Method m, Method sourceDecl, RefType sourceDeclType
where
  t.getSourceDeclaration().fromSource() and
  m.getDeclaringType() = t and
  sourceDecl = m.getSourceDeclaration() and
  sourceDeclType = sourceDecl.getDeclaringType()
select t, m, m.getSignature(), paramTypeIfPresent(m), m.getReturnType().toString(), sourceDeclType,
  sourceDecl
