/**
 * @name Variable read
 * @description Finds code that reads a variable called `err`.
 * @id go/examples/readoferr
 * @tags variable read
 */

import go

from Variable err, Read read
where
  err.getName() = "err" and
  read = err.getARead()
select read
