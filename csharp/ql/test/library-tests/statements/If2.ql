/**
 * @name Test for else branch
 */

import csharp

from Method m, IfStmt i
where
  m.getName() = "MainIf" and
  i = m.getBody().getChild(0)
select i, i.getElse().(BlockStmt)
