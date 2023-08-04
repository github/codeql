/**
 * Provides C#-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlowParameter

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module CsharpDataFlow implements DataFlowParameter {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate accessPathLimit = Private::accessPathLimit/0;
}
