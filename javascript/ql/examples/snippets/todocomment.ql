/**
 * @id js/examples/todocomment
 * @name TODO comments
 * @description Finds comments containing the word TODO
 * @kind problem
 * @problem.severity recommendation
 * @tags comment
 *       TODO
 */

import javascript

from Comment c
where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
select c, "TODO comments indicate that the code may not be complete."
