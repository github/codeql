/**
 * @name Test operator abstractions
 * @description Tests the binary operator abstractions in AST.qll
 * @kind problem
 * @problem.severity recommendation
 * @id php/test-operators
 */

import php

from int arithCount, int compCount, int logicCount, int bitwiseCount, int concatCount, int nullCoalesceCount
where
  arithCount = count(ArithmeticOp a | any()) and
  compCount = count(ComparisonOp c | any()) and
  logicCount = count(LogicalOp l | any()) and
  bitwiseCount = count(BitwiseOp b | any()) and
  concatCount = count(ConcatOp c | any()) and
  nullCoalesceCount = count(NullCoalesceOp n | any())
select "Operators: " + arithCount + " arithmetic, " + compCount + " comparison, " +
       logicCount + " logical, " + bitwiseCount + " bitwise, " +
       concatCount + " concat, " + nullCoalesceCount + " null-coalesce"
