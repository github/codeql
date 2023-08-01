/**
 * Provides Python-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlowParameter
// we need to export `Unit` for the DataFlowImpl* files
private import python as Python

module Private {
  import DataFlowPrivate
}

module Public {
  import DataFlowPublic
  import DataFlowUtil
}

module PythonDataFlow implements DataFlowParameter {
  import Private
  import Public

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }
}
