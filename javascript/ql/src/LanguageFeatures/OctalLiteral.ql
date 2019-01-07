/**
 * @name Octal literal
 * @description Octal numeric literals are a platform-specific extension and should not be used.
 * @kind problem
 * @problem.severity recommendation
 * @id js/octal-literal
 * @tags portability
 *       external/cwe/cwe-758
 * @precision low
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript

from NumberLiteral nl
where nl.getRawValue().regexpMatch("0\\d+")
select nl, "Do not use octal literals."
