/**
 * @name Print DFG
 * @description Produces a representation of a file's Data Flow Graph.
 *              This query is used by the VS Code extension.
 * @id java/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-dfg
 */

import java
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific as DF
private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific as TT
private import codeql.dataflow.PrintDfg
private import MakePrintDfg<Location, DF::JavaDataFlow, TT::JavaTaintTracking>

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
    DF::JavaDataFlow::DataFlowCallable callable, File file, int startLine, int startColumn,
    int endLine, int endColumn
  ) {
    file = callable.asCallable().getFile() and
    callable.getLocation().getStartLine() = startLine and
    callable.getLocation().getStartColumn() = startColumn and
    exists(Location loc |
      loc.getEndLine() = endLine and
      loc.getEndColumn() = endColumn and
      loc = callable.asCallable().getBody().getLocation()
    )
  }
}

import ViewGraphQuery<File, ViewDfgQueryInput>
