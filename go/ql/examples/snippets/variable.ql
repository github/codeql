/**
 * @name Variable
 * @description Finds variables called "err".
 * @id go/examples/errvariable
 * @tags variable
 *       err
 */

import go

from Variable err
where err.getName() = "err"
select err, err.getDeclaration()
