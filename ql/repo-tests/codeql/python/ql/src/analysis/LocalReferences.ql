/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id py/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import python
import DefinitionTracking

external string selectedSourceFile();

from NiceLocationExpr use, Definition defn, string kind
where
  defn = definitionOf(use, kind) and
  defn.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select use, defn, kind
