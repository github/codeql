/**
 * @id js/examples/vardecl
 * @name Declaration of variable
 * @description Finds places where we declare a variable called `v`
 * @tags variable
 *       declaration
 */

import javascript

from VarDecl d
where d.getVariable().getName() = "v"
select d
