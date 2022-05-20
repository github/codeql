/**
 * @name Impossible array cast
 * @description Trying to cast an array of a particular type as an array of a subtype causes a
 *              'ClassCastException' at runtime.
 * @kind problem
 * @problem.severity error
 * @precision low
 * @id java/impossible-array-cast
 * @tags reliability
 *       correctness
 *       logic
 *       external/cwe/cwe-704
 */

import java

/**
 * A cast expression of the form `(T[])new S[...]`.
 */
class ArrayCast extends CastExpr {
  ArrayCast() {
    getExpr() instanceof ArrayCreationExpr and
    getType() instanceof Array
  }

  /** The type of the operand expression of this cast. */
  Array getSourceType() { result = getExpr().getType() }

  /** The result type of this cast. */
  Array getTargetType() { result = getType() }

  Type getSourceComponentType() { result = getSourceType().getComponentType() }

  Type getTargetComponentType() { result = getTargetType().getComponentType() }
}

predicate uncheckedCastType(RefType t) {
  t instanceof BoundedType or t instanceof ParameterizedType
}

predicate castFlow(ArrayCast ce, Variable v) {
  ce = v.getAnAssignedValue()
  or
  exists(Variable mid | castFlow(ce, mid) and mid.getAnAccess() = v.getAnAssignedValue())
}

predicate returnedFrom(ArrayCast ce, Method m) {
  exists(ReturnStmt ret | ret.getEnclosingCallable() = m | ret.getResult() = ce)
  or
  exists(Variable v | castFlow(ce, v) | returnedVariableFrom(v, m))
}

predicate returnedVariableFrom(Variable v, Method m) {
  exists(ReturnStmt ret | ret.getResult() = v.getAnAccess() and ret.getEnclosingCallable() = m)
}

predicate rawTypeConversion(RawType source, ParameterizedType target) {
  target.getErasure() = source.getErasure()
}

from ArrayCast ce, RefType target, RefType source, string message
where
  target = ce.getTargetComponentType() and
  source = ce.getSourceComponentType() and
  target.hasSupertype+(source) and
  not rawTypeConversion(source, target) and
  (
    // No unchecked operations, so the cast would crash straight away.
    not uncheckedCastType(target) and
    message =
      "Impossible downcast: the cast from " + source.getName() + "[] to " + target.getName() +
        "[] will always fail with a ClassCastException."
    or
    // For unchecked operations, the crash would not occur at the cast site,
    // but only if/when the value is assigned to a variable of different array type.
    // This would require tracking the flow of values, but we focus on finding problematic
    // APIs. We keep two cases:
    // - An array that is actually returned from the (non-private) method, or
    // - an array that is assigned to a field returned from another (non-private) method.
    uncheckedCastType(target) and
    returnedFrom(ce, ce.getEnclosingCallable()) and
    ce.getEnclosingCallable().getReturnType().(Array).getElementType() = target and
    not ce.getEnclosingCallable().isPrivate() and
    message =
      "Impossible downcast: this is returned by " + ce.getEnclosingCallable().getName() +
        " as a value of type " + target.getName() + "[], but the array has type " + source.getName()
        + "[]. Callers of " + ce.getEnclosingCallable().getName() +
        " may fail with a ClassCastException."
    or
    exists(Method m, Variable v |
      uncheckedCastType(target) and
      castFlow(ce, v) and
      returnedVariableFrom(v, m) and
      m.getReturnType().(Array).getElementType() = target and
      not m.isPrivate() and
      message =
        "Impossible downcast: this is assigned to " + v.getName() + " which is returned by " + m +
          " as a value of type " + target.getName() + "[], but the array has type " +
          source.getName() + "[]. Callers of " + m.getName() +
          " may fail with a ClassCastException."
    )
  )
select ce, message
