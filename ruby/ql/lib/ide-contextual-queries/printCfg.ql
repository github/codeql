/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rb/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.Locations
private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl
private import codeql.ruby.controlflow.ControlFlowGraph

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements ViewCfgQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate cfgScopeSpan(
    CfgScope scope, File file, int startLine, int startColumn, int endLine, int endColumn
  ) {
    file = scope.getFile() and
    scope.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
  }
}

import ViewCfgQuery<File, ViewCfgQueryInput>
