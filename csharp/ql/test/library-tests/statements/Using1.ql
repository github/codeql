/**
 * @name Test for usings
 */

import csharp

where
  forall(UsingBlockStmt s |
    exists(s.getAnExpr()) and
    exists(s.getBody())
  )
select 1
