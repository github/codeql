/**
 * Provides Go-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlow
private import semmle.go.Locations

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module GoDataFlow implements InputSig<Location> {
  import Private
  import Public

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate golangSpecificParamArgFilter = Private::golangSpecificParamArgFilter/3;
}
