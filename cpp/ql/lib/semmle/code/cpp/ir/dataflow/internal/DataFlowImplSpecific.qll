/**
 * Provides IR-specific definitions for use in the data flow library.
 */

private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowUtil
}

module CppDataFlow implements InputSig {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate getAdditionalFlowIntoCallNodeTerm = Private::getAdditionalFlowIntoCallNodeTerm/2;

  predicate validParameterAliasStep = Private::validParameterAliasStep/2;
}
