/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id rb/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.IDEContextual
import codeql.ruby.AST

external string selectedSourceFile();

from AstNode e, Variable def, string kind
where
  e = def.getAnAccess() and
  kind = "local variable" and
  e.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
