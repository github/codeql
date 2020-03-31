import javascript
import semmle.javascript.dataflow.InferredTypes

DataFlow::CallNode getACall(string name) {
  result.getCalleeName() = name
  or
  result.getCalleeNode().getALocalSource() = DataFlow::globalVarRef(name)
}

class Sink extends DataFlow::Node {
  Sink() { this = getACall("sink").getAnArgument() }
}

/**
 * A node that shouldn't be taintable according to the type inference,
 * as it claims to be neither an object nor a string.
 */
class UntaintableNode extends DataFlow::Node {
  UntaintableNode() {
    not analyze().getAType() = TTObject() and
    not analyze().getAType() = TTString()
  }
}

class BasicConfig extends TaintTracking::Configuration {
  BasicConfig() { this = "BasicConfig" }

  override predicate isSource(DataFlow::Node node) { node = getACall("source") }

  override predicate isSink(DataFlow::Node node) {
    node instanceof Sink
    or
    node instanceof UntaintableNode
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.(DataFlow::InvokeNode).getCalleeName().matches("sanitizer_%")
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof BasicSanitizerGuard
  }
}

class BasicSanitizerGuard extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
  BasicSanitizerGuard() { this = getACall("isSafe") }

  override predicate sanitizes(boolean outcome, Expr e) {
    outcome = true and e = getArgument(0).asExpr()
  }
}

query predicate typeInferenceMismatch(DataFlow::Node source, UntaintableNode sink) {
  any(BasicConfig cfg).hasFlow(source, sink)
}

from BasicConfig cfg, DataFlow::Node src, Sink sink
where cfg.hasFlow(src, sink)
select src, sink
