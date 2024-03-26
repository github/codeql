/**
 * Provides Ruby-specific definitions for use in the data flow library.
 */

private import codeql.Locations
private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module RubyDataFlow implements InputSig<Location> {
  import Private
  import Public

  // includes `LambdaSelfReferenceNode`, which is not part of the public API
  class ParameterNode = Private::ParameterNodeImpl;

  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    Private::isParameterNode(p, c, pos)
  }

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;

  predicate ignoreFieldFlowBranchLimit(DataFlowCallable c) { exists(c.asLibraryCallable()) }
}
