import csharp
import semmle.code.csharp.commons.Util
import semmle.code.csharp.frameworks.test.NUnit

MethodCall getAnAccessByReflection(Method m) {
  exists(TypeofExpr typeof |
    typeof.getTypeAccess().getType() = m.getDeclaringType() and
    result.getTarget().hasName("GetMethod") and
    result.getQualifier() = typeof and
    result.getArgument(0).getValue() = m.getName()
  )
}

Expr getAnAccessByDynamicCall(Method m) {
  exists(DynamicMethodCall call, Type receiverType |
    call.getLateBoundTargetName() = m.getName() and
    call.getQualifier().getType() = receiverType and
    (
      receiverType instanceof DynamicType
      or
      m.getDeclaringType().getABaseType*() = receiverType
    ) and
    result = call
  )
  or
  exists(MethodCall mc, Method target |
    target = mc.getTarget() and
    target.hasName("InvokeMember") and
    target.getDeclaringType().hasQualifiedName("System.Type") and
    mc.getArgument(0).(StringLiteral).getValue() = m.getName() and
    mc.getArgument(3).getType().(RefType).hasMethod(m) and
    result = mc
  )
}

Expr getAMethodAccess(Method m) {
  result = getAnAccessByDynamicCall(m) or
  result = getAnAccessByReflection(m) or
  result.(MethodCall).getTarget().getUnboundDeclaration() = m or
  result.(MethodAccess).getTarget().getUnboundDeclaration() = m
}

predicate potentiallyAccessedByForEach(Method m) {
  m.hasName("GetEnumerator") and
  m.getDeclaringType().getABaseType+().hasQualifiedName("System.Collections.IEnumerable")
  or
  foreach_stmt_desugar(_, m, 1)
}

predicate isRecursivelyLiveExpression(Expr e) {
  exists(Callable c | c = e.getEnclosingCallable() |
    isRecursivelyLiveMethod(c) or not c instanceof Method
  )
}

predicate isRecursivelyLiveMethod(Method m) {
  not m.isPrivate()
  or
  isRecursivelyLiveExpression(getAMethodAccess(m))
  or
  m instanceof MainMethod
  or
  // Explicit implementations should be considered public
  m.implementsExplicitInterface()
  or
  potentiallyAccessedByForEach(m)
  or
  isRecursivelyLiveMethod(m.(ConstructedMethod).getUnboundDeclaration())
  or
  nunitValueSource(m)
  or
  exists(TestClass tc |
    tc.getAMethod() = m and
    exists(m.getAnAttribute())
  )
}

predicate nunitValueSource(Method m) {
  exists(ValueSourceAttribute attribute | attribute.getSourceMethod() = m)
}

predicate nunitTestCaseSource(Declaration f) {
  exists(TestCaseSourceAttribute attribute | attribute.getUnboundDeclaration() = f)
}

predicate isDeadMethod(Method m) {
  not isRecursivelyLiveMethod(m) and
  m.isSourceDeclaration()
}

predicate isDeadField(Field f) {
  f.isPrivate() and
  not f.getDeclaringType() instanceof AnonymousClass and
  f.getUnboundDeclaration() = f and
  not nunitTestCaseSource(f) and
  forall(FieldAccess fc | fc.getTarget().getUnboundDeclaration() = f |
    isDeadMethod(fc.getEnclosingCallable())
    or
    not fc instanceof FieldRead and not fc.isRefArgument()
  )
}
