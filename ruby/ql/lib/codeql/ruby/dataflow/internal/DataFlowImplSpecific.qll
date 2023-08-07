/**
 * Provides Ruby-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module RubyDataFlow implements InputSig {
  import Private
  import Public

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    Private::isParameterNode(p, c, pos)
  }

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }
}
