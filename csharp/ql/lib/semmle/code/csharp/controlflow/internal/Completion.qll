/**
 * INTERNAL: Do not use.
 *
 * Provides classes representing control flow completions.
 *
 * A completion represents how a statement or expression terminates.
 *
 * There are six kinds of completions: normal completion,
 * `return` completion, `break` completion, `continue` completion,
 * `goto` completion, and `throw` completion.
 *
 * Normal completions are further subdivided into Boolean completions and all
 * other normal completions. A Boolean completion adds the information that the
 * expression terminated with the given boolean value due to a subexpression
 * terminating with the other given Boolean value. This is only relevant for
 * conditional contexts in which the value controls the control-flow successor.
 *
 * Goto successors are further subdivided into label gotos, case gotos, and
 * default gotos.
 */

import csharp
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.commons.Constants
private import semmle.code.csharp.frameworks.System
private import NonReturning
private import SuccessorType

private class Overflowable extends UnaryOperation {
  Overflowable() {
    not this instanceof UnaryBitwiseOperation and
    this.getType() instanceof IntegralType
  }
}

/** Holds if `cfe` is a control flow element that may throw an exception. */
predicate mayThrowException(ControlFlowElement cfe) {
  exists(cfe.(TriedControlFlowElement).getAThrownException())
  or
  cfe instanceof Assertion
}

/** A control flow element that is inside a `try` block. */
private class TriedControlFlowElement extends ControlFlowElement {
  TriedControlFlowElement() {
    this = any(TryStmt try).getATriedElement() and
    not this instanceof NonReturningCall
  }

  /**
   * Gets an exception class that is potentially thrown by this element, if any.
   */
  Class getAThrownException() {
    this instanceof Overflowable and
    result instanceof SystemOverflowExceptionClass
    or
    this.(CastExpr).getType() instanceof IntegralType and
    result instanceof SystemOverflowExceptionClass
    or
    invalidCastCandidate(this) and
    result instanceof SystemInvalidCastExceptionClass
    or
    this instanceof Call and
    result instanceof SystemExceptionClass
    or
    this =
      any(MemberAccess ma |
        not ma.isConditional() and
        ma.getQualifier() = any(Expr e | not e instanceof TypeAccess) and
        result instanceof SystemNullReferenceExceptionClass
      )
    or
    this instanceof DelegateCreation and
    result instanceof SystemOutOfMemoryExceptionClass
    or
    this instanceof ArrayCreation and
    result instanceof SystemOutOfMemoryExceptionClass
    or
    this =
      any(AddExpr ae |
        ae.getType() instanceof StringType and
        result instanceof SystemOutOfMemoryExceptionClass
        or
        ae.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this =
      any(SubExpr se |
        se.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this =
      any(MulExpr me |
        me.getType() instanceof IntegralType and
        result instanceof SystemOverflowExceptionClass
      )
    or
    this =
      any(DivExpr de |
        not de.getDenominator().getValue().toFloat() != 0 and
        result instanceof SystemDivideByZeroExceptionClass
      )
    or
    this instanceof RemExpr and
    result instanceof SystemDivideByZeroExceptionClass
    or
    this instanceof DynamicExpr and
    result instanceof SystemExceptionClass
  }
}

pragma[nomagic]
private ValueOrRefType getACastExprBaseType(CastExpr ce) {
  result = ce.getType().(ValueOrRefType).getABaseType()
  or
  result = getACastExprBaseType(ce).getABaseType()
}

pragma[nomagic]
private predicate invalidCastCandidate(CastExpr ce) {
  ce.getExpr().getType() = getACastExprBaseType(ce)
}
