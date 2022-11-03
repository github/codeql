/**
 * @name Definitions
 * @description Jump to definition helper query.
 * @kind definitions
 * @id py/jump-to-definition
 */

import python
import DefinitionTracking

from NiceLocationExpr use, Definition defn, string kind
where defn = definitionOf(use, kind)
select use, defn, kind
