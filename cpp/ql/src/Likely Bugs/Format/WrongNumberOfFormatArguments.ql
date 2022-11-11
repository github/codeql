/**
 * @name Too few arguments to formatting function
 * @description Calling a printf-like function with too few arguments can be
 *              a source of security issues.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id cpp/wrong-number-format-arguments
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-234
 *       external/cwe/cwe-685
 */

import cpp

from FormatLiteral fl, FormattingFunctionCall ffc, int expected, int given, string ffcName
where
  ffc = fl.getUse() and
  expected = fl.getNumArgNeeded() and
  given = ffc.getNumFormatArgument() and
  expected > given and
  fl.specsAreKnown() and
  (
    if ffc.isInMacroExpansion()
    then ffcName = ffc.getTarget().getName() + " (in a macro expansion)"
    else ffcName = ffc.getTarget().getName()
  )
select ffc,
  "Format for " + ffcName + " expects " + expected.toString() + " arguments but given " +
    given.toString()
