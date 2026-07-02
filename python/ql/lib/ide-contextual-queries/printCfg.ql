/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id py/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

import semmle.python.Files as Files
// import semmle.python.Scope
import semmle.python.controlflow.internal.AstNodeImpl

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements ControlFlow::ViewCfgQueryInputSig<Files::File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate cfgScopeSpan(
    Ast::Callable scope, Files::File file, int startLine, int startColumn, int endLine,
    int endColumn
  ) {
    file = scope.getLocation().getFile() and
    scope.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
  }
}

import ControlFlow::ViewCfgQuery<Files::File, ViewCfgQueryInput>
