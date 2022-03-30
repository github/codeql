/**
 * @name Parameter
 * @description Finds parameters of type "ResponseWriter" from package "net/http".
 * @id go/examples/responseparam
 * @tags parameter
 */

import go

from Parameter req
where req.getType().hasQualifiedName("net/http", "ResponseWriter")
select req
