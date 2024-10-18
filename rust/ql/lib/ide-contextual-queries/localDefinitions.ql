/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id rus/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.IDEContextual
import codeql.rust.elements.Variable
import codeql.rust.elements.Locatable

external string selectedSourceFile();

predicate localVariable(Locatable e, Variable def) { e = def.getAnAccess() }

from Locatable e, Variable def, string kind
where
  e.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile()) and
  localVariable(e, def) and
  kind = "local variable"
select e, def, kind
