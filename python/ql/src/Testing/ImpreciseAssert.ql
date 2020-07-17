/**
 * @name Imprecise assert
 * @description Using 'assertTrue' or 'assertFalse' rather than a more specific assertion can give uninformative failure messages.
 * @kind problem
 * @tags maintainability
 *       testability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/imprecise-assert
 */

import python

/* Helper predicate for CallToAssertOnComparison class */
predicate callToAssertOnComparison(Call call, string assertName, Cmpop op) {
  call.getFunc().(Attribute).getName() = assertName and
  (assertName = "assertTrue" or assertName = "assertFalse") and
  exists(Compare cmp |
    cmp = call.getArg(0) and
    /* Exclude complex comparisons like: a < b < c */
    not exists(cmp.getOp(1)) and
    op = cmp.getOp(0)
  )
}

class CallToAssertOnComparison extends Call {
  CallToAssertOnComparison() { callToAssertOnComparison(this, _, _) }

  Cmpop getOperator() { callToAssertOnComparison(this, _, result) }

  string getMethodName() { callToAssertOnComparison(this, result, _) }

  string getBetterName() {
    exists(Cmpop op |
      callToAssertOnComparison(this, "assertTrue", op) and
      (
        op instanceof Eq and result = "assertEqual"
        or
        op instanceof NotEq and result = "assertNotEqual"
        or
        op instanceof Lt and result = "assertLess"
        or
        op instanceof LtE and result = "assertLessEqual"
        or
        op instanceof Gt and result = "assertGreater"
        or
        op instanceof GtE and result = "assertGreaterEqual"
        or
        op instanceof In and result = "assertIn"
        or
        op instanceof NotIn and result = "assertNotIn"
        or
        op instanceof Is and result = "assertIs"
        or
        op instanceof IsNot and result = "assertIsNot"
      )
      or
      callToAssertOnComparison(this, "assertFalse", op) and
      (
        op instanceof NotEq and result = "assertEqual"
        or
        op instanceof Eq and result = "assertNotEqual"
        or
        op instanceof GtE and result = "assertLess"
        or
        op instanceof Gt and result = "assertLessEqual"
        or
        op instanceof LtE and result = "assertGreater"
        or
        op instanceof Lt and result = "assertGreaterEqual"
        or
        op instanceof NotIn and result = "assertIn"
        or
        op instanceof In and result = "assertNotIn"
        or
        op instanceof IsNot and result = "assertIs"
        or
        op instanceof Is and result = "assertIsNot"
      )
    )
  }
}

from CallToAssertOnComparison call
where
  /* Exclude cases where an explicit message is provided*/
  not exists(call.getArg(1))
select call,
  call.getMethodName() + "(a " + call.getOperator().getSymbol() + " b) " +
    "cannot provide an informative message. Using " + call.getBetterName() +
    "(a, b) instead will give more informative messages."
