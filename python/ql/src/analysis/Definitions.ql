/**
 * @name Definitions
 * @description Jump to definition helper query.
 * @kind definitions
 * @id py/jump-to-definition
 */

import python
import DefinitionTracking


from NiceLocationExpr use, Definition defn, string kind, string f, int l
where defn = getUniqueDefinition(use) and kind = "Definition"
and use.hasLocationInfo(f, l, _, _, _) and
// Ignore if the definition is on the same line as the use
not defn.getLocation().hasLocationInfo(f, l, _, _, _)
select use, defn, kind
