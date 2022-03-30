/**
 * @name Unbound back reference
 * @description Regular expression escape sequences of the form '\n', where 'n' is a positive number
 *              greater than the number of capture groups in the regular expression, are not allowed
 *              by the ECMAScript standard.
 * @kind problem
 * @problem.severity warning
 * @id js/regex/unbound-back-reference
 * @tags reliability
 *       correctness
 *       regular-expressions
 * @precision very-high
 */

import javascript

from RegExpBackRef rebr, string ref
where
  rebr.isPartOfRegExpLiteral() and
  not exists(rebr.getGroup()) and
  (
    ref = rebr.getNumber().toString()
    or
    ref = "named '" + rebr.getName() + "'"
  )
select rebr, "There is no capture group " + ref + " in this regular expression."
