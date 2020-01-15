/**
 * @name Type
 * @description Finds type `Request` from package `net/http`.
 * @id go/examples/requesttype
 * @tags net/http
 *       type
 */

import go

from Type response
where response.hasQualifiedName("net/http", "Request")
select response
