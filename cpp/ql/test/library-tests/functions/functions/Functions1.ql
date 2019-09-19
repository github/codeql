/**
 * @name Functions1
 */

import cpp

from Function f, string top1, string top2, Location loc, string loctype
where
  (if f.isTopLevel() then top1 = "isTopLevel" else top1 = "") and
  (if f instanceof TopLevelFunction then top2 = "TopLevelFunction" else top2 = "") and
  (
    loc = f.getADeclarationLocation() and loctype = "declaration"
    or
    loc = f.getDefinitionLocation() and loctype = "definition"
  )
select f, f.getName(), top1, top2, loc.toString(), loctype
