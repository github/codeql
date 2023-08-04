/**
 * Provides Swift-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlowParameter
// we need to export `Unit` for the DataFlowImpl* files
private import swift as Swift

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module SwiftDataFlow implements DataFlowParameter {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }
}
