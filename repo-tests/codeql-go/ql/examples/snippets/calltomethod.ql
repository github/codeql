/**
 * @name Call to method
 * @description Finds calls to the `Get` method of type `Header` from the `net/http` package.
 * @id go/examples/calltoheaderget
 * @tags call
 *       function
 *       net/http
 *       Header
 *       strings
 */

import go

from Method get, DataFlow::CallNode call
where
  get.hasQualifiedName("net/http", "Header", "Get") and
  call = get.getACall()
select call
