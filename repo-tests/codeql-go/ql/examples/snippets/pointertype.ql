/**
 * @name Type
 * @description Finds pointer type `*Request` from package `net/http`.
 * @id go/examples/requestptrtype
 * @tags net/http
 *       type
 */

import go

from Type reqtp, PointerType reqptrtp
where
  reqtp.hasQualifiedName("net/http", "Request") and
  reqptrtp.getBaseType() = reqtp
select reqptrtp
