/**
 * Provides Java-specific definitions for use in the data flow library.
 */

private import semmle.code.Location
private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module JavaDataFlow implements InputSig<Location> {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate getSecondLevelScope = Private::getSecondLevelScope/1;

  predicate validParameterAliasStep = Private::validParameterAliasStep/2;

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;
}
