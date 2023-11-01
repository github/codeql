/**
 * Provides Go-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module GoDataFlow implements InputSig {
  import Private
  import Public

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate golangSpecificParamArgFilter = Private::golangSpecificParamArgFilter/3;
}
