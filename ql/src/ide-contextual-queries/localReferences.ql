/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id ql/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import codeql.IDEContextual
import codeql_ql.ast.internal.TreeSitter::Generated

external string selectedSourceFile();

from AstNode e, Variable def, string kind
where
  none() and // e = def.getAnAccess() and // TODO: Get binding to work.
  kind = "local variable" and
  def.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
