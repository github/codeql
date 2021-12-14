/**
 * @id cs/examples/try-finally
 * @name Try-finally statements
 * @description Finds try-finally statements without a catch clause.
 * @tags try
 *       finally
 *       catch
 *       exceptions
 */

import csharp

from TryStmt t
where
  exists(t.getFinally()) and
  not exists(t.getACatchClause())
select t
