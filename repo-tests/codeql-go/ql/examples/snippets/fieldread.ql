/**
 * @name Field read
 * @description Finds code that reads `Request.Method`.
 * @id go/examples/readofrequestmethod
 * @tags field
 *       read
 */

import go

from Field reqm, Read read
where
  reqm.hasQualifiedName("net/http", "Request", "Method") and
  read = reqm.getARead()
select read
