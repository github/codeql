/**
 * @name Print DFG
 * @description Produces a representation of a file's data flow graph.
 *              This query is used by the VS Code extension.
 * @id javascript/print-dfg
 * @kind graph
 * @tags ide-contextual-queries/print-dfg
 */

private import semmle.javascript.internal.unified.minimal.minimal
private import semmle.javascript.internal.unified.JSUnified

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewDfgQueryInput implements ViewDfgQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  File getFileFromLocation(Location loc) { result = loc.getFile() }
}

import ViewDfgQuery<File, ViewDfgQueryInput>
