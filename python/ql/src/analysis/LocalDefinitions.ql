/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id python/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import python
import DefinitionTracking

external string selectedSourceFile();

from NiceLocationExpr use, Definition defn, string kind
where defn = definitionOf(use, kind) 
and use.(Expr).getLocation().getFile() = getEncodedFile(selectedSourceFile())
select use, defn, kind