/**
 * @name Unsupported format character
 * @description An unsupported format character in a format string
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/percent-format/unsupported-character
 */

import python
import semmle.python.strings

from Expr e, int start
where start = illegal_conversion_specifier(e)
select e, "Invalid conversion specifier at index " + start + " of " + repr(e) + "."
