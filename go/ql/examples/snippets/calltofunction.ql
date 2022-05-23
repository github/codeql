/**
 * @name Call to library function
 * @description Finds calls to "fmt.Println".
 * @id go/examples/calltoprintln
 * @tags call
 *       function
 *       println
 */

import go

from Function println, DataFlow::CallNode call
where
  println.hasQualifiedName("fmt", "Println") and
  call = println.getACall()
select call
