/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rust/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.files.FileSystem
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl
private import codeql.rust.controlflow.ControlFlowGraph

/**
 * Gets the source file to generate a CFG from.
 */
external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

/**
 * Gets the source line to generate a CFG from.
 */
external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

/**
 * Gets the source column to generate a CFG from.
 */
external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

private module ViewCfgQueryInput implements ViewCfgQueryInputSig<File> {
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
