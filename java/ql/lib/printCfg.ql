/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id java/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

import java

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
    Callable callable, File file, int startLine, int startColumn, int endLine, int endColumn
  ) {
    file = callable.getFile() and
    callable.getLocation().getStartLine() = startLine and
    callable.getLocation().getStartColumn() = startColumn and
    exists(Location loc |
      loc.getEndLine() = endLine and
      loc.getEndColumn() = endColumn and
      loc = callable.getBody().getLocation()
    )
  }
}

import ViewCfgQuery<File, ViewCfgQueryInput>
