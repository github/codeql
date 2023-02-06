/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id go/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import go
import ideContextual

external string selectedSourceFile();

from Ident def, Ident use, Entity e
where
  use.uses(e) and
  def.declares(e) and
  use.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select use, def, "V"
