/**
 * @id py/examples/tryfinally
 * @name Try-finally statements
 * @description Finds try-finally statements without an exception handler
 * @tags try
 *       finally
 *       exceptions
 */

import python

from Try t
where
  exists(t.getFinalbody()) and
  not exists(t.getAHandler())
select t
