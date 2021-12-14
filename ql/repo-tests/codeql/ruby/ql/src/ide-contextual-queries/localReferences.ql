/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id rb/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import codeql.IDEContextual
import codeql.ruby.AST
import codeql.ruby.ast.Variable

external string selectedSourceFile();

from AstNode e, Variable def, string kind
where
  e = def.getAnAccess() and
  kind = "local variable" and
  def.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
