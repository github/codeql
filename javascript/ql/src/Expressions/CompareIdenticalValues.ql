/**
 * @name Comparison of identical values
 * @description If the same expression occurs on both sides of a comparison
 *              operator, the operator is redundant, and probably indicates a mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/comparison-of-identical-expressions
 * @tags reliability
 *       correctness
 *       readability
 *       convention
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision low
 */

import Clones

/**
 * Holds if `e` is a reference to variable `v`, possibly with parentheses or
 * numeric conversions (that is, the unary operators `+` or `-` or a call to `Number`)
 * applied.
 */
predicate accessWithConversions(Expr e, Variable v) {
  e = v.getAnAccess()
  or
  accessWithConversions(e.(ParExpr).getExpression(), v)
  or
  exists(UnaryExpr ue | ue instanceof NegExpr or ue instanceof PlusExpr |
    ue = e and accessWithConversions(ue.getOperand(), v)
  )
  or
  exists(CallExpr ce | ce = e |
    ce = DataFlow::globalVarRef("Number").getACall().asExpr() and
    ce.getNumArgument() = 1 and
    accessWithConversions(ce.getArgument(0), v)
  )
}

/**
 * A comment containing the word "NaN".
 */
predicate isNaNComment(Comment c, string filePath, int startLine) {
  c.getText().matches("%NaN%") and
  c.getLocation().hasLocationInfo(filePath, startLine, _, _, _)
}

/**
 * Holds if the equality test `eq` looks like a NaN check.
 *
 * In order to qualify as a NaN check, both sides of the equality have
 * to be references to the same variable `x`, possibly with added parentheses
 * or numeric conversions, and one of the following holds:
 *
 *   - `x` is a parameter of the enclosing function, which is called
 *     `isNaN` (modulo capitalization);
 *   - there is a comment next to the comparison (that is, no further than
 *     one line away in either direction) that contains the word `NaN`.
 */
predicate isNaNCheck(EqualityTest eq) {
  exists(Variable v |
    accessWithConversions(eq.getLeftOperand(), v) and
    accessWithConversions(eq.getRightOperand(), v)
  |
    // `v` is a parameter of the enclosing function, which is called `isNaN`
    exists(Function isNaN |
      isNaN = eq.getEnclosingFunction() and
      isNaN.getName().toLowerCase() = "isnan" and
      v = isNaN.getAParameter().getAVariable()
    )
    or
    // there is a comment containing the word "NaN" next to the comparison
    exists(string f, int l |
      eq.getLocation().hasLocationInfo(f, l, _, _, _) and
      isNaNComment(_, f, [l - 1 .. l + 1])
    )
  )
}

from Comparison selfComparison, OperandComparedToSelf e
where
  e = selfComparison.getAnOperand() and
  e.same(_) and
  not isNaNCheck(selfComparison)
select selfComparison, "This expression compares $@ to itself.", e, e.toString()
