import javascript
import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2
import utils.test.InlineExpectationsTest

module PhiConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::SsaDefinitionNode).getSsaVariable().getDefinition() instanceof SsaPhiNode
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::InvokeNode check | check.getCalleeName() = "CHECK").getArgument(0)
  }
}

module PhiFlow = DataFlow::Global<PhiConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "uniquePhiDefinition", "phiNodeMetadata", "phiReachesCheck", "globalPhiReachesCheck",
        "sharedDefinition"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    value = "" and
    location.getFile().getBaseName() = "nodes.js" and
    (
      tag = "sharedDefinition" and
      exists(
        DataFlow::InvokeNode check, VarUse read, Ssa2::Definition definition,
        Ssa2::SsaConfig::SourceVariable variable, BasicBlock bb, int index
      |
        check.getCalleeName() = "CHECK_NATIVE" and
        read = check.getArgument(0).asExpr() and
        read = bb.getNode(index) and
        variable.asLocalVariable() = read.getVariable() and
        Ssa2::ssaDefReachesRead(variable, definition, bb, index) and
        read.getSsaVariable().getDefinition() = definition and
        location = check.getLocation()
      )
      or
      exists(DataFlow::InvokeNode check, VarUse read, SsaPhiNode phi |
        check.getCalleeName() = "CHECK" and
        check.getArgument(0).asExpr() = read and
        read.getSsaVariable().getDefinition() = phi and
        location = check.getLocation() and
        (
          tag = "uniquePhiDefinition" and
          count(DataFlow::ssaDefinitionNode(phi)) = 1
          or
          tag = "phiNodeMetadata" and
          forall(DataFlow::Node node | node = DataFlow::ssaDefinitionNode(phi) |
            exists(node.toString()) and
            exists(node.getBasicBlock()) and
            exists(node.getContainer()) and
            exists(node.getLocation()) and
            exists(node.getFile())
          )
          or
          tag = "phiReachesCheck" and
          forall(SsaPhiNode input |
            input.getSourceVariable() = read.getVariable() and
            input.getContainer() = check.getContainer()
          |
            DataFlow::ssaDefinitionNode(input).getASuccessor+() = check.getArgument(0)
          )
          or
          tag = "globalPhiReachesCheck" and
          forall(SsaPhiNode input |
            input.getSourceVariable() = read.getVariable() and
            input.getContainer() = check.getContainer()
          |
            PhiFlow::flow(DataFlow::ssaDefinitionNode(input), check.getArgument(0))
          )
        )
      )
    )
  }
}

import MakeTest<InlineTest>
