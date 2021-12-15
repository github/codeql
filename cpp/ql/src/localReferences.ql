/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer of VSCode.
 * @kind definitions
 * @id cpp/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import definitions

external string selectedSourceFile();

from Top e, Top def, string kind
where
  def = definitionOf(e, kind) and def.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
