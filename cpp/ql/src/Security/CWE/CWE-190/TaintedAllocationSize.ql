/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.security.TaintTracking

from Expr source, Expr tainted, BinaryArithmeticOperation oper,
     SizeofOperator sizeof, string taintCause
where tainted(source, tainted)
  and oper.getAnOperand() = tainted
  and oper.getOperator() = "*"
  and oper.getAnOperand() = sizeof
  and oper != tainted
  and sizeof.getValue().toInt() > 1
  and isUserInput(source, taintCause)
select
  oper, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
