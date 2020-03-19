/**
 * @name Query for detecting potential overflow in divide and conquer algorithms leading to crash
 * @description Calculating the mid-point in a divide and conquer operation
 *             (binary search, merge sort, ...) may lead to overflow. 
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/divide-and-conquer-mid-point-overflow
 * @tags security
 *       correctness
 *       external/cwe/cwe-190
 */

import java

/** Division by 2 can either be done using "/2" or right shifting by 1, which 
  * is equivalent to a division by 2.
  */
class DivideBy2Expr extends BinaryExpr {
  DivideBy2Expr() {
    this.getRightOperand().(IntegerLiteral).getIntValue() = 2 and this instanceof DivExpr
    or
    this.getRightOperand().(IntegerLiteral).getIntValue() = 1 and this instanceof RShiftExpr
  }
}

predicate hasALiteralOperand(AddExpr add) {
  add.getLeftOperand() instanceof Literal 
  or
  add.getRightOperand() instanceof Literal
}

predicate refersToSameVar(Expr a, Expr b) {
  a.(VarAccess).getVariable() = b.(VarAccess).getVariable()
}

from DivideBy2Expr div, AddExpr add, LessThanComparison lt
where div.getLeftOperand().getAChildExpr*() = add and
  not hasALiteralOperand(add) and
  refersToSameVar(lt.getLesserOperand(), add.getAnOperand()) and
  refersToSameVar(lt.getGreaterOperand(), add.getAnOperand()) and
  lt.getGreaterOperand() != lt.getLesserOperand()
select add, "Adding $@ and $@ may overflow before division takes place and lead to a crash.",
  add.getLeftOperand(), add.getLeftOperand().(VarAccess).getVariable().getName(), add.getRightOperand(),
  add.getRightOperand().(VarAccess).getVariable().getName()
