/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id ql/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.IDEContextual
import codeql_ql.ast.internal.TreeSitter::Generated

external string selectedSourceFile();

from AstNode e, Variable def, string kind
where
  none() and // e = def.getAnAccess() and // TODO: Get binding to work.
  kind = "local variable" and
  e.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
