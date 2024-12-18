/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id swift/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import codeql.swift.elements.File
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.internal.ControlFlowGraphImpl as Impl
private import codeql.swift.controlflow.internal.ControlFlowGraphImplSpecific

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

module ViewCfgQueryInput implements Impl::ViewCfgQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate cfgScopeSpan(
    CfgInput::CfgScope scope, File file, int startLine, int startColumn, int endLine, int endColumn
  ) {
    file = scope.getFile() and
    scope.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
  }
}

import Impl::ViewCfgQuery<File, ViewCfgQueryInput>
