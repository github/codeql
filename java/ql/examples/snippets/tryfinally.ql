/**
 * @id java/examples/tryfinally
 * @name Try-finally statements
 * @description Finds try-finally statements without a catch clause
 * @tags try
 *       finally
 *       catch
 *       exceptions
 */

import java

from TryStmt t
where
  exists(t.getFinally()) and
  not exists(t.getACatchClause())
select t
