/**
 * @name Call to built-in function
 * @description Finds calls to the built-in `len` function.
 * @id go/examples/calltolen
 * @tags call
 *       function
 *       len
 *       built-in
 */

import go

from DataFlow::CallNode call
where call = Builtin::len().getACall()
select call
