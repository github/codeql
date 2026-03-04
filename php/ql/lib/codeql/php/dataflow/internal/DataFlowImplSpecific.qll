/**
 * Provides PHP-specific definitions for use in the data flow library.
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

module PhpDataFlow implements InputSig<Location> {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;
}
