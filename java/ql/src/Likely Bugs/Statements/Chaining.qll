import java

/**
 * Find methods that always return `this`, or interface methods that are
 * overridden by such methods.
 *
 * For native or compiled methods (which have no body), we approximate this by
 * requiring that the method returns a subtype of its declaring type, is not
 * declared in an immutable type, and that every method overriding it is also
 * designed for chaining.
 */
predicate designedForChaining(Method m) { not nonChaining(m) }

private predicate nonChaining(Method m) {
  // The method has a body, and at least one of the return values is not suitable for chaining.
  exists(ReturnStmt ret | ret.getEnclosingCallable() = m | nonChainingReturn(m, ret))
  or
  // The method has no body, and is not chaining because ...
  not exists(m.getBody()) and
  (
    // ... it has the wrong return type, ...
    not hasDescendant(m.getReturnType(), m.getDeclaringType())
    or
    // ... it is defined on an immutable type, or ...
    m.getDeclaringType() instanceof ImmutableType
    or
    // ... it has an override that is non-chaining.
    exists(Method override | override.overrides(m) | nonChaining(override))
  )
}

private predicate nonChainingReturn(Method m, ReturnStmt ret) {
  // The wrong `this` is returned.
  ret.getResult() instanceof ThisAccess and
  ret.getResult().getType() != m.getDeclaringType()
  or
  // A method call to the wrong method is returned.
  ret.getResult() instanceof MethodAccess and
  exists(MethodAccess delegateCall, Method delegate |
    delegateCall = ret.getResult() and
    delegate = delegateCall.getMethod()
  |
    delegate.getDeclaringType() != m.getDeclaringType()
    or
    delegate.isStatic()
    or
    not hasDescendant(m.getReturnType(), delegate.getReturnType())
    or
    // A method on the wrong object is called.
    not delegateCall.isOwnMethodAccess()
    or
    nonChaining(delegate)
  )
  or
  // Something else is returned.
  not (
    ret.getResult() instanceof ThisAccess or
    ret.getResult() instanceof MethodAccess
  )
}
