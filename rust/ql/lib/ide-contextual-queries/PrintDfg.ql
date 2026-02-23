/**
 * @name Print DFG
 * @description Produces a representation of a file's Data Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rust/print-dfg
 * @kind graph
 * @tags ide-contextual-queries/print-dfg
 */

private import rust
private import codeql.rust.dataflow.internal.DataFlowImpl as DF
private import codeql.rust.dataflow.internal.TaintTrackingImpl as TT
private import codeql.dataflow.PrintDfg
private import MakePrintDfg<Location, DF::RustDataFlow, TT::RustTaintTracking>

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

private module ViewDfgQueryInput implements ViewGraphQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate callableSpan(
    DF::RustDataFlow::DataFlowCallable callable, File file, int startLine, int startColumn,
    int endLine, int endColumn
  ) {
    file = callable.asCfgScope().getFile() and
    callable.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
  }
}

import ViewGraphQuery<File, ViewDfgQueryInput>
