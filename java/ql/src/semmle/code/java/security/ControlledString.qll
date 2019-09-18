/**
 * Controlled strings are the opposite of tainted strings.
 * There is positive evidence that they are fully controlled by
 * the program source code.
 */

import semmle.code.java.Expr
import semmle.code.java.security.Validation

/**
 * Holds if `method` is a `toString()` method on a boxed type. These never return special characters.
 */
private predicate boxedToString(Method method) {
  method.getDeclaringType() instanceof BoxedType and
  method.getName() = "toString"
}

/**
 * A static analysis of strings that end in a single quote. When such strings are concatenated
 * with another string, it suggests the programmer believes that code needed quoting. However,
 * it is better to use a prepared query than to just put single quotes around the string.
 */
predicate endsInQuote(Expr expr) {
  exists(string str | str = expr.(StringLiteral).getRepresentedString() | str.matches("%'"))
  or
  exists(Variable var | expr = var.getAnAccess() | endsInQuote(var.getAnAssignedValue()))
  or
  endsInQuote(expr.(AddExpr).getRightOperand())
}

/** The given expression is controlled if the other expression is controlled. */
private predicate controlledStringProp(Expr src, Expr dest) {
  // Propagation through variables.
  exists(Variable var | var.getAnAccess() = dest | src = var.getAnAssignedValue())
  or
  // Propagation through method parameters.
  exists(Parameter param, MethodAccess call, int i |
    src = call.getArgument(i) and
    param = call.getMethod().getParameter(i) and
    dest = param.getAnAccess()
  )
  or
  // Concatenation of safe strings.
  exists(AddExpr concatOp | concatOp = dest | src = concatOp.getAnOperand())
  or
  // `toString()` on a safe string is safe.
  exists(MethodAccess toStringCall, Method toString |
    src = toStringCall.getQualifier() and
    toString = toStringCall.getMethod() and
    toString.hasName("toString") and
    toString.getNumberOfParameters() = 0 and
    dest = toStringCall
  )
}

/** Expressions that have a small number of inflows from `controlledStringProp`. */
private predicate modestControlledStringInflow(Expr dest) {
  strictcount(Expr src | controlledStringProp(src, dest)) < 10
}

/**
 * A limited version of `controlledStringProp` that ignores destinations that are written a
 * very high number of times.
 */
private predicate controlledStringLimitedProp(Expr src, Expr dest) {
  controlledStringProp(src, dest) and
  modestControlledStringInflow(dest)
}

/**
 * Strings that are known to not include any special characters, due to being fully
 * controlled by the programmer.
 */
cached
predicate controlledString(Expr expr) {
  (
    expr instanceof StringLiteral
    or
    expr instanceof NullLiteral
    or
    expr.(VarAccess).getVariable() instanceof EnumConstant
    or
    expr.getType() instanceof PrimitiveType
    or
    expr.getType() instanceof BoxedType
    or
    exists(Method method | method = expr.(MethodAccess).getMethod() |
      method instanceof ClassNameMethod or
      method instanceof ClassSimpleNameMethod or
      boxedToString(method)
    )
    or
    expr instanceof ValidatedVariableAccess
    or
    forex(Expr other | controlledStringLimitedProp(other, expr) | controlledString(other))
  ) and
  not expr instanceof TypeAccess
}
