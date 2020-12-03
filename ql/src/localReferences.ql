/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id ruby/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import codeql.IDE
import codeql_ruby.AST
import codeql_ruby.ast.Variable

external string selectedSourceFile();

from AstNode e, Variable def, string kind
where
  e = def.getAnAccess() and
  kind = "local variable" and
  def.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
