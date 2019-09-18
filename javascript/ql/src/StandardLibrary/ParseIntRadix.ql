/**
 * @name Call to parseInt without radix
 * @description Calls to the 'parseInt' function should always specify a radix to avoid accidentally
 *              parsing a number as octal.
 * @kind problem
 * @problem.severity recommendation
 * @id js/parseint-without-radix
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-676
 * @precision very-high
 * @deprecated This is no longer a problem with modern browsers. Deprecated since 1.17.
 */

import javascript

from DataFlow::CallNode parseInt
where
  parseInt = DataFlow::globalVarRef("parseInt").getACall() and
  parseInt.getNumArgument() = 1
select parseInt, "Missing radix parameter."
