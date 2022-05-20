/**
 * @name Text has not been internationalized
 * @description Including text directly on a page makes it more difficult to internationalize the website.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/asp/text-not-internationalized
 * @tags maintainability
 *       frameworks/asp.net
 */

import semmle.code.asp.AspNet

from AspText text
where exists(text.getBody().regexpFind("\\w{3,}", _, _))
select text, "This text has not been internationalized."
