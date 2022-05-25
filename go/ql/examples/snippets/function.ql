/**
 * @name Function
 * @description Finds functions called "main".
 * @id go/examples/mainfunction
 * @tags function
 *       main
 */

import go

from Function main
where main.getName() = "main"
select main
