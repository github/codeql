/**
 * @name Type information
 * @description Finds code elements of type `*Request` from package `net/http`.
 * @id go/examples/requests
 * @tags net/http
 *       types
 */

import go

from Type reqtp, PointerType reqptrtp, DataFlow::Node req
where
  reqtp.hasQualifiedName("net/http", "Request") and
  reqptrtp.getBaseType() = reqtp and
  req.getType() = reqptrtp
select req
