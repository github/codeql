/**
 * Provides detection of callables designed for chaining.
 *
 * For example `stringBuilder.Append(x).Append(y)` is a
 * chained call, where the `Append` method is chained.
 */

import csharp

/**
 * Holds if callable `c` is designed for chaining. The following must
 * be fulfilled:
 *
 * - `c` must be declared in a reference type.
 * - All callables overriding `c` must be designed for chaining.
 * - If `c` has a body, all (and at least one) returned values must
 *   be `this`.
 * - If `c` has no body (abstract/interface callable or library
 *   callable), the return type of `c` must be a subtype of `c`'s
 *   declaring type, and `c` must be non-static.
 */
predicate designedForChaining(Callable c) { not nonChaining(c) }

private predicate nonChaining(Callable c) {
  exists(Type t | t = c.getDeclaringType() | not t instanceof RefType)
  or
  exists(Method override | override.getOverridee() = c | nonChaining(override))
  or
  exists(Getter override | override.getDeclaration().getOverridee() = c.(Getter).getDeclaration() |
    nonChaining(override)
  )
  or
  nonChainingBody(c)
  or
  nonChainingNoBody(c)
}

private predicate nonChainingBody(Callable c) {
  (c.hasBody() or c.hasExpressionBody()) and
  (not exists(returnedValue(c)) or nonChainingReturn(c))
}

private Expr returnedValue(Callable c) {
  exists(Expr e | c.canReturn(e) |
    if e instanceof ConditionalExpr
    then
      result = e.(ConditionalExpr).getThen() or
      result = e.(ConditionalExpr).getElse()
    else result = e
  )
}

/** Holds if `c` can return a non-`this` value. */
private predicate nonChainingReturn(Callable c) {
  exists(Expr ret | ret = returnedValue(c) |
    // The result of a call is returned
    exists(Callable other | other = ret.(Call).getTarget() |
      nonChaining(other)
      or
      exists(MethodCall mc | mc = ret | not mc.hasThisQualifier())
      or
      exists(MemberAccess ma | ma = ret | not ma.hasThisQualifier())
    )
    or
    // Something else is returned
    not ret instanceof ThisAccess and
    not exists(ret.(Call).getTarget())
  )
}

private predicate nonChainingNoBody(Callable c) {
  not c.hasBody() and
  not c.hasExpressionBody() and
  (
    not c.getReturnType().isImplicitlyConvertibleTo(c.getDeclaringType())
    or
    c.(Modifiable).isStatic()
  )
}
