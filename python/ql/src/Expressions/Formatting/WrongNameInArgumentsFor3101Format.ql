/**
 * @name Missing named arguments in formatting call
 * @description A string formatting operation, such as '"{name}".format(key=b)',
 *              where the names of format items in the format string differs from the names of the values to be formatted will raise a KeyError.
 * @kind problem
 * @problem.severity error
 * @tags reliability
 *       correctness
 * @sub-severity low
 * @precision high
 * @id py/str-format/missing-named-argument
 */

import python
import AdvancedFormatting

from AdvancedFormattingCall call, AdvancedFormatString fmt, string name
where
  call.getAFormat() = fmt and
  not name = call.getAKeyword().getArg() and
  fmt.getFieldName(_, _) = name and
  not exists(call.getKwargs())
select call,
  "Missing named argument for string format. Format $@ requires '" + name + "', but it is omitted.",
  fmt, "\"" + fmt.getText() + "\""
