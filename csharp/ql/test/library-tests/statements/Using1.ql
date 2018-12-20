/**
 * @name Test for usings
 */

import csharp

where
  forall(UsingStmt s |
    exists(s.getAnExpr()) and
    exists(s.getBody())
  )
select 1
