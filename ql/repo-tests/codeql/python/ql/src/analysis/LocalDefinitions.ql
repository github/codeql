/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id py/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import python
import DefinitionTracking

external string selectedSourceFile();

from NiceLocationExpr use, Definition defn, string kind, string f
where
  defn = definitionOf(use, kind) and
  use.hasLocationInfo(f, _, _, _, _) and
  getFileBySourceArchiveName(selectedSourceFile()).getAbsolutePath() = f
select use, defn, kind
