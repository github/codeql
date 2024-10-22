/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id rust/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import codeql.IDEContextual
import codeql.rust.elements.Locatable
import codeql.rust.elements.Variable
import Definitions

external string selectedSourceFile();

from Locatable e, Variable def, string kind
where
  def = definitionOf(e, kind) and
  def.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
