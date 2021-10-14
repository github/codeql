/**
 * @name Variable write
 * @description Finds assignments to variables named "err".
 * @id go/examples/errwrite
 * @tags variable write
 */

import go

from Variable err, Write write
where
  err.getName() = "err" and
  write = err.getAWrite()
select write, write.getRhs()
