/**
 * @name Result variable
 * @description Finds result variables of type "error".
 * @id go/examples/errresult
 * @tags result variable
 */

import go

from ResultVariable err
where err.getType() = Builtin::error().getType()
select err
