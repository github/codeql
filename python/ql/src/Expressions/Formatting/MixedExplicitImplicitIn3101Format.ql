/**
 * @name Formatting string mixes implicitly and explicitly numbered fields
 * @description Using implicit and explicit numbering in string formatting operations, such as '"{}: {1}".format(a,b)', will raise a ValueError.
 * @kind problem
 * @problem.severity error
 * @tags reliability
 *       correctness
 * @sub-severity low
 * @precision high
 * @id py/str-format/mixed-fields
 */

import python
import AdvancedFormatting

from AdvancedFormattingCall call, AdvancedFormatString fmt
where call.getAFormat() = fmt and fmt.isImplicitlyNumbered() and fmt.isExplicitlyNumbered()
select fmt, "Formatting string mixes implicitly and explicitly numbered fields."
