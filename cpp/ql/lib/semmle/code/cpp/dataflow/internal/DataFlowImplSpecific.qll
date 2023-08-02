/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlowParameter

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module CppOldDataFlow implements DataFlowParameter {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }
}
