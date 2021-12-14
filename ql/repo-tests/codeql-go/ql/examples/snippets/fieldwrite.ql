/**
 * @name Field write
 * @description Finds assignments to field `Status` of type `Response` from package `net/http`.
 * @id go/examples/responsestatus
 * @tags net/http
 *       field write
 */

import go

from Field status, Write write
where
  status.hasQualifiedName("net/http", "Response", "Status") and
  write = status.getAWrite()
select write, write.getRhs()
