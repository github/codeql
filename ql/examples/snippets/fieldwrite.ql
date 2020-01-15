/**
 * @name Field write
 * @description Finds assignments to field `Status` of type `Response` from package `net/http`.
 * @id go/examples/responsestatus
 * @tags net/http
 *       field write
 */

import go

from Type response, Field status, DataFlow::Write write
where
  response.hasQualifiedName("net/http", "Response") and
  status = response.getField("Status") and
  write = status.getAWrite()
select write, write.getRhs()
