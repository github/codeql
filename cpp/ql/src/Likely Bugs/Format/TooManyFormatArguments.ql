/**
 * @name Too many arguments to formatting function
 * @description A printf-like function called with too many arguments will
 *              ignore the excess arguments and output less than might
 *              have been intended.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/too-many-format-arguments
 * @tags reliability
 *       correctness
 */

import cpp

from FormatLiteral fl, FormattingFunctionCall ffc, int expected, int given, string ffcName
where
  ffc = fl.getUse() and
  expected = fl.getNumArgNeeded() and
  given = ffc.getNumFormatArgument() and
  expected < given and
  fl.specsAreKnown() and
  (
    if ffc.isInMacroExpansion()
    then ffcName = ffc.getTarget().getName() + " (in a macro expansion)"
    else ffcName = ffc.getTarget().getName()
  )
select ffc,
  "Format for " + ffcName + " expects " + expected.toString() + " arguments but given " +
    given.toString()
