/**
 * @name Too few arguments to formatting function
 * @description Calling a printf-like function with too few arguments can be
 *              a source of security issues.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/wrong-number-format-arguments
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-685
 */

import cpp

from FormatLiteral fl, FormattingFunctionCall ffc, int expected, int given
where
  ffc = fl.getUse() and
  expected = fl.getNumArgNeeded() and
  given = ffc.getNumFormatArgument() and
  expected > given and
  fl.specsAreKnown()
select ffc, "Format expects " + expected.toString() + " arguments but given " + given.toString()
