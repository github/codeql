/**
 * @name Split control structure
 * @description Splitting control structures across multiple code blocks makes .aspx pages more difficult to maintain.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/asp/split-control-structure
 * @tags maintainability
 *       frameworks/asp.net
 */

import semmle.code.asp.AspNet

from AspCode code
where exists(code.getBody().regexpFind("(Then|\\{)\\s*$", _, _))
select code, "Split control structure."
