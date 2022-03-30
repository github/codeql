/**
 * @name Test for labeled block statement
 */

import csharp

from LabeledStmt stmt
where
  stmt.getLabel() = "block" and
  stmt.getStmt() instanceof BlockStmt
select 1
