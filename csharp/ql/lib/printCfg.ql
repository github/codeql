/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id cs/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl

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
    scope.getLocation().getStartLine() = startLine and
    scope.getLocation().getStartColumn() = startColumn and
    exists(Location loc |
      loc.getEndLine() = endLine and
      loc.getEndColumn() = endColumn
    |
      loc = scope.(Callable).getBody().getLocation()
      or
      loc = scope.(Field).getInitializer().getLocation()
      or
      loc = scope.(Property).getInitializer().getLocation()
    )
  }
}

import ViewCfgQuery<File, ViewCfgQueryInput>
