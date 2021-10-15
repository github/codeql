/**
 * @name Test for user-defined operator "calls"
 */

import csharp

from Method m, OperatorCall e, ImplicitConversionOperator o
where
  m.hasName("MainConversionOperator") and
  e.getEnclosingCallable() = m and
  e.getTarget() = o and
  e.getArgument(0).getType().(Struct).hasName("Digit") and
  e.getArgument(0).(LocalVariableAccess).getTarget().hasName("d") and
  e.getNumberOfArguments() = 1
select m, e, o
