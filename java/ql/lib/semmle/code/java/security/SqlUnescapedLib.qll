/* Definitions used by `SqlUnescaped.ql`. */
import semmle.code.java.security.ControlledString
import semmle.code.java.dataflow.TaintTracking

/**
 * A string concatenation that includes a string
 * not known to be programmer controlled.
 */
predicate builtFromUncontrolledConcat(Expr expr, Expr uncontrolled) {
  // Base case
  exists(AddExpr concatExpr | concatExpr = expr |
    endsInQuote(concatExpr.getLeftOperand()) and
    uncontrolled = concatExpr.getRightOperand() and
    not controlledString(uncontrolled)
  )
  or
  // Recursive cases
  exists(Expr other | builtFromUncontrolledConcat(other, uncontrolled) |
    expr.(AddExpr).getAnOperand() = other
    or
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
}

/**
 * A query built with a StringBuilder, where one of the
 * items appended is uncontrolled.
 */
predicate uncontrolledStringBuilderQuery(StringBuilderVar sbv, Expr uncontrolled) {
  // A single append that has a problematic concatenation.
  exists(MethodAccess append |
    append = sbv.getAnAppend() and
    builtFromUncontrolledConcat(append.getArgument(0), uncontrolled)
  )
  or
  // Two calls to append, one ending in a quote, the next being uncontrolled.
  exists(MethodAccess quoteAppend, MethodAccess uncontrolledAppend |
    sbv.getAnAppend() = quoteAppend and
    endsInQuote(quoteAppend.getArgument(0)) and
    sbv.getNextAppend(quoteAppend) = uncontrolledAppend and
    uncontrolled = uncontrolledAppend.getArgument(0) and
    not controlledString(uncontrolled)
  )
}
