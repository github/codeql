/**
 * @name Too few arguments in formatting call
 * @description A string formatting operation, such as '"{0}: {1}, {2}".format(a,b)',
 *              where the number of values to be formatted is too few for the format string will raise an IndexError.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/str-format/missing-argument
 */

import python
import AdvancedFormatting

from
  AdvancedFormattingCall call, AdvancedFormatString fmt, int arg_count, int max_field,
  string provided
where
  arg_count = call.providedArgCount() and
  max_field = max(fmt.getFieldNumber(_, _)) and
  call.getAFormat() = fmt and
  not exists(call.getStarargs()) and
  arg_count <= max_field and
  (if arg_count = 1 then provided = " is provided." else provided = " are provided.")
select call,
  "Too few arguments for string format. Format $@ requires at least " + (max_field + 1) + ", but " +
    arg_count.toString() + provided, fmt, "\"" + fmt.getText() + "\""
