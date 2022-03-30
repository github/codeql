/**
 * @name Malformed regular expression
 * @description Regular expressions that do not adhere to the ECMAScript standard may be interpreted
 *              differently across platforms and should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @id js/regex/syntax-error
 * @tags portability
 *       maintainability
 *       regular-expressions
 * @precision low
 */

import javascript

from RegExpParseError repe
select repe, "Malformed regular expression: " + repe + "."
