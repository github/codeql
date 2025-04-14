import java

predicate getterFor(Method m, Field f) {
  m.getName().matches("get%") and
  m.getDeclaringType() = f.getDeclaringType() and
  exists(ReturnStmt ret | ret.getEnclosingCallable() = m and ret.getResult() = f.getAnAccess())
}

predicate setterFor(Method m, Field f) {
  m.getName().matches("set%") and
  m.getDeclaringType() = f.getDeclaringType() and
  f.getAnAssignedValue() = m.getAParameter().getAnAccess() and
  m.getNumberOfParameters() = 1
}

predicate shadows(LocalVariableDecl d, Class c, Field f, Callable method) {
  d.getCallable() = method and
  method.getDeclaringType() = c and
  f = getField(c, d.getName(), d.getType()) and
  not method.isStatic() and
  not f.isStatic()
}

/**
 * Gets the field with the given name and type from the given class, if any.
 */
pragma[nomagic]
private Field getField(Class c, string name, Type t) {
  result.getDeclaringType() = c and
  result.getName() = name and
  result.getType() = t
}

predicate thisAccess(LocalVariableDecl d, Field f) {
  shadows(d, _, f, _) and
  exists(VarAccess va | va.getVariable() = f |
    va.getQualifier() instanceof ThisAccess and
    va.getEnclosingCallable() = d.getCallable()
  )
}

predicate confusingAccess(LocalVariableDecl d, Field f) {
  shadows(d, _, f, _) and
  exists(VarAccess va | va.getVariable() = f |
    not exists(va.getQualifier()) and
    va.getEnclosingCallable() = d.getCallable()
  )
}

predicate assignmentToShadowingLocal(LocalVariableDecl d, Field f) {
  shadows(d, _, _, _) and
  exists(Expr assignedValue, Expr use |
    d.getAnAssignedValue() = assignedValue and getARelevantChild(assignedValue) = use
  |
    exists(FieldAccess access | access = assignedValue | f = access.getField())
    or
    exists(MethodCall get, Method getter | get = assignedValue and getter = get.getMethod() |
      getterFor(getter, f)
    )
  )
}

predicate assignmentFromShadowingLocal(LocalVariableDecl d, Field f) {
  shadows(d, _, _, _) and
  exists(VarAccess access | access = d.getAnAccess() |
    exists(MethodCall set, Expr arg, Method setter |
      access = getARelevantChild(arg) and
      arg = set.getAnArgument() and
      setter = set.getMethod() and
      setterFor(setter, f)
    )
    or
    exists(Expr assignedValue |
      access = getARelevantChild(assignedValue) and
      assignedValue = f.getAnAssignedValue()
    )
  )
}

private Expr getARelevantChild(Expr parent) {
  exists(MethodCall ma | parent = ma.getAnArgument() and result = parent)
  or
  exists(Variable v | parent = v.getAnAccess() and result = parent)
  or
  exists(Expr mid | mid = getARelevantChild(parent) and result = mid.getAChildExpr())
}
