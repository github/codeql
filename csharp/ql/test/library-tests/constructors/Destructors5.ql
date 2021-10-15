/**
 * @name Test for destructors
 */

import csharp

where
  forex(Stmt s | exists(Destructor d | d.getBody().getAChild() = s) |
    s instanceof LocalVariableDeclStmt
  )
select 1
