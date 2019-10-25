/**
 * @id js/examples/varref
 * @name Reference to variable
 * @description Finds places where we reference a variable called `undefined`
 * @tags variable
 *       reference
 */

import javascript

from VarRef ref
where ref.getVariable().getName() = "undefined"
select ref
