/**
 * @id js/examples/todocomment
 * @name TODO comments
 * @description Finds comments containing the word TODO
 * @kind problem
 * @tags comment
 *       TODO
 */

import javascript

from Comment c
where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
select c
