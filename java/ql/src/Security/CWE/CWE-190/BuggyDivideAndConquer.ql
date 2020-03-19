/**
 * @name Query for detecting potential overflow in divide and conquer algorithms leading to crash
 * @description Calculating the mid-point in a divide and conquer operation
 *             (binary search, merge sort, ...) may lead to overflow. 
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/divide-and-conquer-mid-point-overflow
 * @tags correctness
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

predicate refersToSameVar(Expr a, Expr b) {
  a.(VarAccess).getVariable() = b.(VarAccess).getVariable()
}

from DivideBy2Expr div, AddExpr add, LessThanComparison lt, VarAccess low, VarAccess high
where div.getLeftOperand().getAChildExpr*() = add and
  refersToSameVar(add.getLeftOperand(), low) and
  refersToSameVar(add.getRightOperand(), high) and
  refersToSameVar(lt.getAnOperand(), low) and
  refersToSameVar(lt.getAnOperand(), high) and
  not refersToSameVar(lt.getLeftOperand(), lt.getRightOperand())
select add, "Adding $@ and $@ may overflow before division takes place and lead to a crash.",
  add.getLeftOperand(), low.getVariable().getName(), add.getRightOperand(),  high.getVariable().getName()
