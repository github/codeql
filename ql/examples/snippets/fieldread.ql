/**
 * @name Field read
 * @description Finds code that reads `Request.Method`.
 * @id go/examples/readofrequestmethod
 * @tags field
 *       read
 */

import go

from Type reqtp, Field reqm, DataFlow::Read read
where
  reqtp.hasQualifiedName("net/http", "Request") and
  reqm = reqtp.getField("Method") and
  read = reqm.getARead()
select read
