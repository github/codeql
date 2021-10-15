/**
 * @name Functions1
 */

import cpp

string describe(Function f) {
  f.isTopLevel() and
  result = "isTopLevel"
  or
  f instanceof TopLevelFunction and
  result = "TopLevelFunction"
  or
  result = "declaration:" + f.getADeclarationLocation()
  or
  result = "definition:" + f.getDefinitionLocation()
}

from Function f
where exists(f.getLocation())
select f, f.getName(), f.getParameterString(), concat(describe(f), ", ")
