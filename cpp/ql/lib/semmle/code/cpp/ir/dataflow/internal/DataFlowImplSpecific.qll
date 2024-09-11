/**
 * Provides IR-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlow
private import semmle.code.cpp.Location

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module CppDataFlow implements InputSig<Location> {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate getAdditionalFlowIntoCallNodeTerm = Private::getAdditionalFlowIntoCallNodeTerm/2;

  predicate getSecondLevelScope = Private::getSecondLevelScope/1;

  predicate validParameterAliasStep = Private::validParameterAliasStep/2;

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;
}
