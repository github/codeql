/**
 * @id cpp/examples/todocomment
 * @name TODO comments
 * @description Finds comments containing the word "TODO"
 * @tags comment
 *       matches
 *       TODO
 */

import cpp

from Comment c
where c.getContents().matches("%TODO%")
select c
