/**
 * @name Test for try catches
 */

import csharp

where
  forall(TryStmt s |
    exists(s.getBlock()) and
    (exists(s.getACatchClause()) or exists(s.getFinally()))
  )
select 1
