/**
 * @id cs/examples/todo-comment
 * @name TODO comments
 * @description Finds comments containing the word "TODO".
 * @tags comment
 *       TODO
 */

import csharp

from CommentLine c
where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
select c
