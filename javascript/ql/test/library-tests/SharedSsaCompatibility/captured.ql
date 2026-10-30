import javascript
import utils.test.InlineExpectationsTest

module CapturedConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::InvokeNode).getCalleeName() = "SOURCE"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::InvokeNode call |
      call.getCalleeName() = "SINK" and
      sink = call.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<SimpleBarrierGuard>::getABarrierNode()
  }
}

module CapturedFlow = DataFlow::Global<CapturedConfig>;

class SimpleBarrierGuard extends DataFlow::InvokeNode {
  SimpleBarrierGuard() { this.getCalleeName() = "BARRIER" }

  predicate blocksExpr(boolean outcome, Expr expr) {
    outcome = true and
    expr = this.getArgument(0).asExpr()
  }
}

class LegacySimpleBarrierGuard extends DataFlow::BarrierGuardNode, SimpleBarrierGuard {
  override predicate blocks(boolean outcome, Expr expr) { this.blocksExpr(outcome, expr) }
}

class LegacyCapturedConfig extends DataFlow::Configuration {
  LegacyCapturedConfig() { this = "LegacyCapturedConfig" }

  override predicate isSource(DataFlow::Node source) { CapturedConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { CapturedConfig::isSink(sink) }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof LegacySimpleBarrierGuard
  }
}

module InlineTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "capturedWrite", "noCapturedWrite", "ssaDefinition", "noSsaAstNode", "localCapturedFlow",
        "capturedFlow", "legacyCapturedFlow"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    location.getFile().getBaseName() = "captured.js" and
    (
      exists(VarRef reference |
        value = reference.getVariable().getName() and
        value = ["capturedWrite", "uncapturedWrite", "globalWrite", "capturedPattern"] and
        location = reference.getLocation() and
        (
          tag = "capturedWrite" and
          exists(DataFlow::SsaDefinitionNode node |
            node.getSsaVariable().getDefinition().(SsaExplicitDefinition).getLhs() = reference and
            reference.getVariable().isCaptured()
          )
          or
          tag = "noCapturedWrite" and
          not exists(DataFlow::SsaDefinitionNode node |
            node.getSsaVariable().getDefinition().(SsaExplicitDefinition).getLhs() = reference and
            reference.getVariable().isCaptured()
          )
        )
      )
      or
      tag = "ssaDefinition" and
      exists(SsaExplicitDefinition definition, VarRef write, DataFlow::SsaDefinitionNode node |
        write = definition.getLhs() and
        write.getVariable().isCaptured() and
        node = DataFlow::lvalueNode(write) and
        node = DataFlow::ssaDefinitionNode(definition) and
        node.getSsaVariable() = definition.getVariable() and
        location = write.getLocation() and
        value = write.getVariable().getName()
      )
      or
      tag = "noSsaAstNode" and
      exists(VarDecl write |
        write.getVariable().getName() = "capturedWrite" and
        not exists(DataFlow::lvalueNode(write).getAstNode()) and
        location = write.getLocation() and
        value = write.getVariable().getName()
      )
      or
      tag = "localCapturedFlow" and
      exists(DataFlow::InvokeNode sink, VarUse read, SsaExplicitDefinition definition |
        sink.getCalleeName() = "SINK" and
        sink.getArgument(0).asExpr() = read and
        read.getSsaVariable().getDefinition() = definition and
        definition.getSourceVariable().isCaptured() and
        definition.getContainer() = sink.getContainer() and
        DataFlow::lvalueNode(definition.getLhs()).getASuccessor+() = sink.getArgument(0) and
        location = sink.getLocation() and
        value = read.getVariable().getName()
      )
      or
      exists(DataFlow::InvokeNode source, DataFlow::InvokeNode sink |
        source.getFile().getBaseName() = "captured.js" and
        source.getCalleeName() = "SOURCE" and
        sink.getCalleeName() = "SINK" and
        value = source.getArgument(0).getStringValue() and
        location = sink.getLocation() and
        (
          tag = "capturedFlow" and CapturedFlow::flow(source, sink.getArgument(0))
          or
          tag = "legacyCapturedFlow" and
          any(LegacyCapturedConfig config).hasFlow(source, sink.getArgument(0))
        )
      )
    )
  }
}

import MakeTest<InlineTest>
