/**
 * @name Print DFG
 * @description Produces a representation of a file's Data Flow Graph.
 *              This query is used by the VS Code extension.
 * @id js/print-dfg
 * @kind graph
 * @tags ide-contextual-queries/print-dfg
 */

private import javascript
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowArg
private import codeql.dataflow.PrintDfg
import MakePrintDfg<Location, JSDataFlow, JSTaintFlow>

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements ViewGraphQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  /**
   * Holds if `callable` spans column `startColumn` of line `startLine` to
   * column `endColumn` of line `endLine` in `file`.
   */
  predicate callableSpan(
    JSDataFlow::DataFlowCallable callable, File file, int startLine, int startColumn, int endLine,
    int endColumn
  ) {
    callable
        .getLocation()
        .hasLocationInfo(file.getAbsolutePath(), startLine, startColumn, endLine, endColumn)
  }
}

import ViewGraphQuery<File, ViewGraphInput>
