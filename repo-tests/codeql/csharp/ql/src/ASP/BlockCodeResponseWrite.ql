/**
 * @name Block code with a single Response.Write()
 * @description Embedded code blocks with a single 'Response.Write()' reduce the readability of the page.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/asp/response-write
 * @tags maintainability
 *       frameworks/asp.net
 */

import semmle.code.asp.AspNet

from AspBlockCode code
where code.getBody().trim().matches("Response.Write(%")
select code, "Non-inline code calls 'Response.Write()'."
