/**
 * @name Print DFG
 * @description Produces a representation of a file's Data Flow Graph.
 *              This query is used by the VS Code extension.
 * @id rb/print-dfg
 * @kind graph
 * @tags ide-contextual-queries/print-dfg
 */

private import codeql.Locations
private import codeql.ruby.dataflow.internal.DataFlowImplSpecific as DF
private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific as TT
private import codeql.dataflow.PrintDfg
private import MakePrintDfg<Location, DF::RubyDataFlow, TT::RubyTaintTracking>

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewDfgQueryInput implements ViewGraphQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate callableSpan(
    DF::RubyDataFlow::DataFlowCallable callable, File file, int startLine, int startColumn,
    int endLine, int endColumn
  ) {
    file = callable.asCfgScope().getFile() and
    callable.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
  }
}

import ViewGraphQuery<File, ViewDfgQueryInput>
