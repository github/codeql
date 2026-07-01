/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id go/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

import go
import semmle.go.controlflow.ControlFlowGraph
private import semmle.go.controlflow.ControlFlowGraphShared

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements GoCfg::ControlFlow::ViewCfgQueryInputSig<File> {
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
      loc.getEndColumn() = endColumn and
      loc = scope.(FuncDef).getBody().getLocation()
    )
    or
    file = scope.(File) and
    startLine = 1 and
    startColumn = 1 and
    endLine = file.getNumberOfLines() and
    endColumn = 999999
  }
}

import GoCfg::ControlFlow::ViewCfgQuery<File, ViewCfgQueryInput>
