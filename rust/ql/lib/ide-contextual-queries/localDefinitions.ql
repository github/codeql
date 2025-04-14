/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id rust/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.IDEContextual
import codeql.rust.internal.Definitions

external string selectedSourceFile();

from Use use, Definition def, string kind
where
  def = definitionOf(use, kind) and
  use.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select use, def, kind
