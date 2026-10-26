/**
 * @id py/examples/todocomment
 * @name TODO comments
 * @description Finds comments containing the word "TODO"
 * @tags comment
 *       TODO
 */

import python

from Comment c
where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
select c
