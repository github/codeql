/**
 * This module implements subclasses for various DataFlow nodes that extends
 * their `toString()` predicates with range information, if applicable. By
 * including this module in a `path-problem` query, this range information
 * will be displayed at each step in the query results.
 *
 * This is currently implemented for `DataFlow::ExprNode` and `DataFlow::DefinitionByReferenceNode`,
 * but it is not yet implemented for `DataFlow::ParameterNode`.
 */

private import cpp
private import semmle.code.cpp.dataflow.DataFlow
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

string getExprBoundAsString(Expr e) {
  if exists(lowerBound(e)) and exists(upperBound(e))
  then result = "[" + lowerBound(e) + ", " + upperBound(e) + "]"
  else result = "[unknown range]"
}

/**
 * Holds for any integer type after resolving typedefs and stripping `const`
 * specifiers, such as for `const size_t`
 */
predicate isIntegralType(Type t) {
  // We use `getUnspecifiedType` here because without it things like
  // `const size_t` aren't considered to be integral
  t.getUnspecifiedType() instanceof IntegralType
}

/**
 * Holds for any reference to an integer type after resolving typedefs and
 * stripping `const` specifiers, such as for `const size_t&`
 */
predicate isIntegralReferenceType(Type t) { isIntegralType(t.(ReferenceType).stripType()) }

/**
 * Holds for any pointer to an integer type after resolving typedefs and
 * stripping `const` specifiers, such as for `const size_t*`. This predicate
 * holds for any pointer depth, such as for `const size_t**`.
 */
predicate isIntegralPointerType(Type t) { isIntegralType(t.(PointerType).stripType()) }

predicate hasIntegralOrReferenceIntegralType(Locatable e) {
  exists(Type t |
    (
      t = e.(Expr).getUnspecifiedType()
      or
      // This will cover variables, parameters, type declarations, etc.
      t = e.(DeclarationEntry).getUnspecifiedType()
    ) and
    (isIntegralType(t) or isIntegralReferenceType(t))
  )
}

Expr getLOp(Operation o) {
  result = o.(BinaryOperation).getLeftOperand() or
  result = o.(Assignment).getLValue()
}

Expr getROp(Operation o) {
  result = o.(BinaryOperation).getRightOperand() or
  result = o.(Assignment).getRValue()
}

/**
 * Display the ranges of expressions in the path view
 */
private class ExprRangeNode extends DataFlow::ExprNode {
  pragma[inline]
  private string getIntegralBounds(Expr arg) {
    if hasIntegralOrReferenceIntegralType(arg)
    then result = getExprBoundAsString(arg)
    else result = ""
  }

  private string getOperationBounds(Operation e) {
    result =
      getExprBoundAsString(e) + " = " + getExprBoundAsString(getLOp(e)) + e.getOperator() +
        getExprBoundAsString(getROp(e))
  }

  private string getCallBounds(Call e) {
    result =
      getExprBoundAsString(e) + "(" +
        concat(Expr arg, int i |
          arg = e.getArgument(i)
        |
          this.getIntegralBounds(arg), "," order by i
        ) + ")"
  }

  override string toString() {
    exists(Expr e | e = this.getExpr() |
      if hasIntegralOrReferenceIntegralType(e)
      then
        result = super.toString() + ": " + this.getOperationBounds(e)
        or
        result = super.toString() + ": " + this.getCallBounds(e)
        or
        not exists(this.getOperationBounds(e)) and
        not exists(this.getCallBounds(e)) and
        result = super.toString() + ": " + getExprBoundAsString(e)
      else result = super.toString()
    )
  }
}

/**
 * Display the ranges of expressions in the path view
 */
private class ReferenceArgumentRangeNode extends DataFlow::DefinitionByReferenceNode {
  override string toString() {
    if hasIntegralOrReferenceIntegralType(this.asDefiningArgument())
    then result = super.toString() + ": " + getExprBoundAsString(this.getArgument())
    else result = super.toString()
  }
}
