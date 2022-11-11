/**
 * @name Confusing overloading of methods
 * @description Overloaded methods that have the same number of parameters, where each pair of
 *              corresponding parameter types is convertible by casting or autoboxing, may be
 *              confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/confusing-method-signature
 * @tags maintainability
 *       readability
 *       naming
 */

import java

pragma[nomagic]
private predicate confusingPrimitiveBoxedTypes(Type t, Type u) {
  t.(PrimitiveType).getBoxedType() = u or
  u.(PrimitiveType).getBoxedType() = t
}

private predicate overloadedMethods(Method n, Method m) {
  n.fromSource() and
  exists(RefType rt, string name, int numParams |
    candidateMethod(rt, m, name, numParams) and
    candidateMethod(rt, n, name, numParams)
  ) and
  n != m and
  n.getSourceDeclaration().getSignature() < m.getSourceDeclaration().getSignature()
}

private predicate overloadedMethodsMostSpecific(Method n, Method m) {
  overloadedMethods(n, m) and
  not exists(Method nSup, Method mSup |
    n.overridesOrInstantiates*(nSup) and m.overridesOrInstantiates*(mSup)
  |
    overloadedMethods(nSup, mSup) and
    (n != nSup or m != mSup)
  )
}

/**
 * A whitelist of names that are commonly overloaded in odd ways and should
 * not be reported by this query.
 */
private predicate whitelist(string name) { name = "visit" }

/**
 * Method `m` has name `name`, number of parameters `numParams`
 * and is declared in `t` or inherited from a supertype of `t`.
 */
pragma[nomagic]
private predicate candidateMethod(RefType t, Method m, string name, int numParam) {
  exists(Method n | n.getSourceDeclaration() = m | t.inherits(n)) and
  m.getName() = name and
  m.getNumberOfParameters() = numParam and
  m = m.getSourceDeclaration() and
  not m.getAnAnnotation() instanceof DeprecatedAnnotation and
  // Exclude compiler generated methods, such as Kotlin `$default` methods:
  not m.isCompilerGenerated() and
  not whitelist(name)
}

predicate paramTypePair(Type t1, Type t2) {
  exists(Method n, Method m, int i |
    overloadedMethodsMostSpecific(n, m) and
    t1 = n.getParameterType(i) and
    t2 = m.getParameterType(i)
  )
}

// handle simple cases separately
predicate potentiallyConfusingTypesSimple(Type t1, Type t2) {
  paramTypePair(t1, t2) and
  (
    t1 = t2
    or
    t1 instanceof TypeObject and t2 instanceof RefType
    or
    t2 instanceof TypeObject and t1 instanceof RefType
    or
    confusingPrimitiveBoxedTypes(t1, t2)
  )
}

// check erased types first
predicate potentiallyConfusingTypesRefTypes(RefType t1, RefType t2) {
  paramTypePair(t1, t2) and
  not potentiallyConfusingTypesSimple(t1, t2) and
  haveIntersection(t1, t2)
}

// then check hasSubtypeOrInstantiation
predicate potentiallyConfusingTypes(Type t1, Type t2) {
  potentiallyConfusingTypesSimple(t1, t2)
  or
  potentiallyConfusingTypesRefTypes(t1, t2) and
  exists(RefType commonSubtype | hasSubtypeOrInstantiation*(t1, commonSubtype) |
    hasSubtypeOrInstantiation*(t2, commonSubtype)
  )
}

private predicate hasSubtypeOrInstantiation(RefType t, RefType sub) {
  hasSubtype(t, sub) or
  sub.getSourceDeclaration() = t
}

private predicate confusinglyOverloaded(Method m, Method n) {
  overloadedMethodsMostSpecific(n, m) and
  forall(int i, Parameter p, Parameter q | p = n.getParameter(i) and q = m.getParameter(i) |
    potentiallyConfusingTypes(p.getType(), q.getType())
  ) and
  // There is no possibility for confusion between two methods with identical behavior.
  not exists(Method target | delegate*(m, target) and delegate*(n, target))
}

private predicate wrappedAccess(Expr e, MethodAccess ma) {
  e = ma or
  wrappedAccess(e.(CastingExpr).getExpr(), ma)
}

private predicate delegate(Method caller, Method callee) {
  exists(MethodAccess ma | ma.getMethod() = callee |
    exists(Stmt stmt | stmt = caller.getBody().(SingletonBlock).getStmt() |
      wrappedAccess(stmt.(ExprStmt).getExpr(), ma) or
      wrappedAccess(stmt.(ReturnStmt).getResult(), ma)
    ) and
    forex(Parameter p, int i, Expr arg | p = caller.getParameter(i) and ma.getArgument(i) = arg |
      // The parameter is propagated without modification.
      arg = p.getAnAccess()
      or
      // The parameter is cast to a supertype.
      arg.(CastingExpr).getExpr() = p.getAnAccess() and
      arg.getType().(RefType).getASubtype() = p.getType()
    )
  )
}

from Method m, Method n, string messageQualifier
where
  confusinglyOverloaded(m, n) and
  (
    if m.getDeclaringType() = n.getDeclaringType()
    then messageQualifier = ""
    else messageQualifier = m.getDeclaringType().getName() + "."
  )
select n,
  "Method " + n.getDeclaringType() + "." + n +
    "(..) could be confused with overloaded method $@, since dispatch depends on static types.",
  m.getSourceDeclaration(), messageQualifier + m.getName()
