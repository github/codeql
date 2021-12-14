/**
 * @name Redundant comparison
 * @description The result of a comparison is implied by a previous comparison.
 * @kind problem
 * @tags useless-code
 *       external/cwe/cwe-561
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @problem.severity warning
 * @sub-severity high
 * @precision high
 * @id py/redundant-comparison
 */

import python
import semmle.python.Comparisons

/*
 * Holds if the comparison `comp` is of the complex form `a op b op c` and not of
 * the simple form `a op b`.
 */

private predicate is_complex(Expr comp) {
  exists(comp.(Compare).getOp(1))
  or
  is_complex(comp.(UnaryExpr).getOperand())
}

/**
 * A test is useless if for every block that it controls there is another test that is at least as
 * strict and also controls that block.
 */
private predicate useless_test(Comparison comp, ComparisonControlBlock controls, boolean isTrue) {
  controls.impliesThat(comp.getBasicBlock(), comp, isTrue) and
  /* Exclude complex comparisons of form `a < x < y`, as we do not (yet) have perfect flow control for those */
  not is_complex(controls.getTest().getNode())
}

private predicate useless_test_ast(AstNode comp, AstNode previous, boolean isTrue) {
  forex(Comparison compnode, ConditionBlock block |
    compnode.getNode() = comp and
    block.getLastNode().getNode() = previous
  |
    useless_test(compnode, block, isTrue)
  )
}

from Expr test, Expr other, boolean isTrue
where
  useless_test_ast(test, other, isTrue) and not useless_test_ast(test.getAChildNode+(), other, _)
select test, "Test is always " + isTrue + ", because of $@", other, "this condition"
