/**
 * @name Test for operators
 */

import csharp

from Operator op, OperatorCall call
where
  op.fromSource() and
  (
    op instanceof IncrementOperator or
    op instanceof CheckedIncrementOperator or
    op instanceof DecrementOperator or
    op instanceof CheckedDecrementOperator
  ) and
  call.getTarget() = op
select op, call
