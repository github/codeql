/**
 * @name Unneeded defensive code
 * @description Defensive code that guards against a situation that never happens is not needed.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unneeded-defensive-code
 * @tags correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision very-high
 */

import javascript
import semmle.javascript.DefensiveProgramming

/**
 * Holds if `e` looks like a check for `document.all`, which is an unusual browser object which coerces
 * to `false` and has typeof `undefined`.
 */
predicate isFalsyObjectCheck(LogicalBinaryExpr e) {
  exists(Variable v |
    e.getAnOperand().(DefensiveExpressionTest::TypeofUndefinedTest).getOperand() = v.getAnAccess() and
    e.getAnOperand().(DefensiveExpressionTest::UndefinedComparison).getOperand() = v.getAnAccess()
  )
}

/**
 * Holds if `e` is part of a check for `document.all`.
 */
predicate isPartOfFalsyObjectCheck(Expr e) {
  exists(LogicalBinaryExpr binary |
    isFalsyObjectCheck(binary) and
    e = binary.getAnOperand()
  )
  or
  isFalsyObjectCheck(e)
}

from DefensiveExpressionTest e, boolean cv
where
  not isPartOfFalsyObjectCheck(e.asExpr()) and
  e.getTheTestResult() = cv and
  // whitelist
  not (
    // module environment detection
    exists(VarAccess access, string name | name = "exports" or name = "module" |
      e.asExpr().(DefensiveExpressionTest::TypeofUndefinedTest).getOperand() = access and
      access.getName() = name and
      not exists(access.getVariable().getADeclaration())
    )
    or
    // too benign in practice
    e instanceof DefensiveExpressionTest::DefensiveInit
  )
select e, "This guard always evaluates to " + cv + "."
