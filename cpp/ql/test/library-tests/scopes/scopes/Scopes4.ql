/**
 * @name Scopes4
 * @kind table
 */

import cpp

from Function f, string top
where if f.isTopLevel() then top = "isTopLevel()" else top = ""
select f, top, count(f.getNamespace()), count(GlobalNamespace gn | f.getNamespace() = gn)
