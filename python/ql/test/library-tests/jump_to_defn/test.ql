/**
 * @name test
 */

import python
import analysis.DefinitionTracking

from Expr use, Definition defn
where
  defn = getADefinition(use) and
  use.getEnclosingModule().getName() = "test"
select use.getLocation().toString(), use.toString(), defn.toString()
