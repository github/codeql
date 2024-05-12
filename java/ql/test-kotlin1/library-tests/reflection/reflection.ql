import java

// Stop external filepaths from appearing in the results
class ClassOrInterfaceLocation extends ClassOrInterface {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

class CallableLocation extends Callable {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

query predicate variableInitializerType(
  LocalVariableDecl decl, RefType t1, RefType t2, RefType t3, boolean compatible
) {
  decl.getType() = t1 and
  t1.getPackage().getName() = "kotlin.reflect" and
  decl.getInitializer().getType() = t2 and
  t2.extendsOrImplements(t3) and
  (
    compatible = true and haveIntersection(t1, t2)
    or
    compatible = false and notHaveIntersection(t1, t2)
  )
}

query predicate invocation(Call c, Callable callee) {
  c.getCallee() = callee and callee.getDeclaringType().getPackage().getName() = "kotlin.reflect"
}

query predicate functionReferences(MemberRefExpr e, Method m, Callable c) {
  e.asMethod() = m and
  e.getReferencedCallable() = c
}

query predicate propertyGetReferences(PropertyRefExpr e, Method m, Callable c) {
  e.asGetMethod() = m and
  e.getGetterCallable() = c
}

query predicate propertyFieldReferences(PropertyRefExpr e, Method m, Field f) {
  e.asGetMethod() = m and
  e.getField() = f
}

query predicate propertySetReferences(PropertyRefExpr e, Method m, Callable c) {
  e.asSetMethod() = m and
  e.getSetterCallable() = c
}

query predicate callsInsideInvocationMethods(
  ClassInstanceExpr e, AnonymousClass c, Method m, Call call, string callee
) {
  (e instanceof MemberRefExpr or e instanceof PropertyRefExpr) and
  e.getAnonymousClass() = c and
  c.getAMethod() = m and
  m.getName() = ["invoke", "get", "set"] and
  call.getEnclosingCallable() = m and
  callee = call.getCallee().getQualifiedName()
}

query predicate fieldAccessInsideInvocationMethods(
  ClassInstanceExpr e, AnonymousClass c, Method m, FieldAccess access
) {
  (e instanceof MemberRefExpr or e instanceof PropertyRefExpr) and
  e.getAnonymousClass() = c and
  c.getAMethod() = m and
  m.getName() = ["invoke", "get", "set"] and
  access.getEnclosingCallable() = m
}

query predicate modifiers(ClassInstanceExpr e, Method m, string modifier) {
  (e instanceof MemberRefExpr or e instanceof PropertyRefExpr) and
  e.getAnonymousClass().getAMethod() = m and
  m.hasModifier(modifier)
}

query predicate compGenerated(Element e, string reason) { reason = e.compilerGeneratedReason() }

query predicate propertyReferenceOverrides(PropertyRefExpr e, Method m, string overridden) {
  e.getAnonymousClass().getAMember() = m and
  exists(Method n |
    m.overrides(n) and
    overridden = n.getDeclaringType().getQualifiedName() + "." + n.getSignature()
  )
}

query predicate notImplementedInterfaceMembers(PropertyRefExpr e, string interfaceMember) {
  exists(Interface i, Method interfaceMethod |
    e.getAnonymousClass().extendsOrImplements+(i) and
    i.getAMethod() = interfaceMethod and
    interfaceMember = i.getQualifiedName() + "." + interfaceMethod.getSignature() and
    not exists(Class c, Method classMethod |
      e.getAnonymousClass().extendsOrImplements*(c) and
      c.getAMethod() = classMethod and
      classMethod.overrides(interfaceMethod)
    )
  )
}
