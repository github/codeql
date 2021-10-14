/**
 * @name Complex inline code
 * @description Embedding complex inline code makes .aspx pages more difficult to maintain.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/asp/complex-inline-code
 * @tags maintainability
 *       frameworks/asp.net
 */

import semmle.code.asp.AspNet

from AspCode code
where code.getBody().matches("%\n%")
select code, "Inline code contains multi-line logic."
