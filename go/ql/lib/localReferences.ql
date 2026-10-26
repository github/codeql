/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id go/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import go
import ideContextual

external string selectedSourceFile();

from Ident def, Ident use, Entity e
where
  use.uses(e) and
  def.declares(e) and
  def.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select use, def, "V"
