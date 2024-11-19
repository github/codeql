/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id rust/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import codeql.IDEContextual
import codeql.rust.internal.Definitions

external string selectedSourceFile();

from Use use, Definition def, string kind
where
  def = definitionOf(use, kind) and
  def.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select use, def, kind
