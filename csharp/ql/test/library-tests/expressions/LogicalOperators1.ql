/**
 * @name Test logical operators
 */

import csharp

from LogicalOperation o, int i, Location loc
where
  loc = o.getLocation() and
  loc.getStartLine() = loc.getEndLine() and
  o.getEnclosingCallable().getName() = "LogicalOperators"
select loc.getStartLine(), loc.getStartColumn(), loc.getEndColumn(), o, i, o.getChild(i)
