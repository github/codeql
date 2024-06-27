/**
 * Provides C#-specific definitions for use in the data flow library.
 */

private import semmle.code.csharp.Location
private import codeql.dataflow.DataFlow

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}

module CsharpDataFlow implements InputSig<Location> {
  import Private
  import Public

  Node exprNode(DataFlowExpr e) { result = Public::exprNode(e) }

  predicate accessPathLimit = Private::accessPathLimit/0;

  predicate mayBenefitFromCallContext = Private::mayBenefitFromCallContext/1;

  predicate viableImplInCallContext = Private::viableImplInCallContext/2;

  predicate neverSkipInPathGraph(Node n) {
    exists(n.(AssignableDefinitionNode).getDefinition().getTargetAccess())
  }
}
