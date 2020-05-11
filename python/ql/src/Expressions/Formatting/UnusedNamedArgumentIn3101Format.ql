/**
 * @name Unused named argument in formatting call
 * @description Including surplus keyword arguments in a formatting call makes code more difficult to read and may indicate an error.
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/str-format/surplus-named-argument
 */

import python
import AdvancedFormatting

from AdvancedFormattingCall call, AdvancedFormatString fmt, string name, string fmt_repr
where
  call.getAFormat() = fmt and
  name = call.getAKeyword().getArg() and
  forall(AdvancedFormatString format | format = call.getAFormat() |
    not format.getFieldName(_, _) = name
  ) and
  not exists(call.getKwargs()) and
  (
    strictcount(call.getAFormat()) = 1 and fmt_repr = "format \"" + fmt.getText() + "\""
    or
    strictcount(call.getAFormat()) != 1 and fmt_repr = "any format used."
  )
select call,
  "Surplus named argument for string format. An argument named '" + name +
    "' is provided, but it is not required by $@.", fmt, fmt_repr
