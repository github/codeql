/**
 * @name Pythagorean calculation with sub-optimal numerics
 * @description Calculating the length of the hypotenuse using the standard formula may lead to overflow.
 * @kind problem
 * @tags accuracy
 * @problem.severity warning
 * @sub-severity low
 * @precision medium
 * @id py/pythagorean
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

DataFlow::ExprNode squareOp() {
  exists(BinaryExpr e | e = result.asExpr() |
    e.getOp() instanceof Pow and e.getRight().(IntegerLiteral).getN() = "2"
  )
}

DataFlow::ExprNode squareMul() {
  exists(BinaryExpr e | e = result.asExpr() |
    e.getOp() instanceof Mult and e.getRight().(Name).getId() = e.getLeft().(Name).getId()
  )
}

DataFlow::ExprNode square() { result in [squareOp(), squareMul()] }

from DataFlow::CallCfgNode c, BinaryExpr s, DataFlow::ExprNode left, DataFlow::ExprNode right
where
  c = API::moduleImport("math").getMember("sqrt").getACall() and
  c.getArg(0).asExpr() = s and
  s.getOp() instanceof Add and
  left.asExpr() = s.getLeft() and
  right.asExpr() = s.getRight() and
  left.getALocalSource() = square() and
  right.getALocalSource() = square()
select c, "Pythagorean calculation with sub-optimal numerics."
