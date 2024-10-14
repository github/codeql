/**
 * Provides Powershell-specific definitions for use in the data flow library.
 */

private import powershell
private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module PowershellDataFlow implements InputSig<Location> {
  import Private
  import Public

  class ParameterNode = Private::ParameterNodeImpl;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;
}
