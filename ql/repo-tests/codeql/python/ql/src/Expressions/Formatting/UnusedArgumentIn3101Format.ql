/**
 * @name Unused argument in a formatting call
 * @description Including surplus arguments in a formatting call makes code more difficult to read and may indicate an error.
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity warning
 * @sub-severity high
 * @precision high
 * @id py/str-format/surplus-argument
 */

import python
import python
import AdvancedFormatting

int field_count(AdvancedFormatString fmt) { result = max(fmt.getFieldNumber(_, _)) + 1 }

from AdvancedFormattingCall call, AdvancedFormatString fmt, int arg_count, int max_field
where
  arg_count = call.providedArgCount() and
  max_field = field_count(fmt) and
  call.getAFormat() = fmt and
  not exists(call.getStarargs()) and
  forall(AdvancedFormatString other | other = call.getAFormat() | field_count(other) < arg_count)
select call,
  "Too many arguments for string format. Format $@ requires only " + max_field + ", but " +
    arg_count.toString() + " are provided.", fmt, "\"" + fmt.getText() + "\""
