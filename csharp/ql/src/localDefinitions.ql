/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id cs/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import definitions

external string selectedSourceFile();

from Use e, Declaration def, string kind, string filepath
where
  def = definitionOf(e, kind) and
  e.hasLocationInfo(filepath, _, _, _, _) and
  filepath = getFileBySourceArchiveName(selectedSourceFile()).getAbsolutePath()
select e, def, kind
