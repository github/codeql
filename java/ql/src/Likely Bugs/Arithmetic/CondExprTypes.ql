/**
 * @name Type mismatch in conditional expression
 * @description Using the '(p?e1:e2)' operator with different primitive types for the second and
 *              third operands may cause unexpected results.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/type-mismatch-in-conditional
 * @tags reliability
 *       correctness
 */

import java

class CharType extends PrimitiveType {
  CharType() { this.hasName("char") }
}

private Type getABranchType(ConditionalExpr ce) { result = ce.getABranchExpr().getType() }

from ConditionalExpr ce
where
  getABranchType(ce) instanceof CharType and
  exists(Type t | t = getABranchType(ce) |
    t instanceof PrimitiveType and
    not t instanceof CharType
  )
select ce, "Mismatch between types of branches: $@ and $@.", ce.getTrueExpr(),
  ce.getTrueExpr().getType().getName(), ce.getFalseExpr(), ce.getFalseExpr().getType().getName()
