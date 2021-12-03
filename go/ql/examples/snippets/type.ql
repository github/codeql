/**
 * @name Type
 * @description Finds type `Request` from package `net/http`.
 * @id go/examples/requesttype
 * @tags net/http
 *       type
 */

import go

from Type request
where request.hasQualifiedName("net/http", "Request")
select request
