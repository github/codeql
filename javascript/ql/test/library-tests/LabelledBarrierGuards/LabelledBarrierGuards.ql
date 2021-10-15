import javascript

class CustomFlowLabel extends DataFlow::FlowLabel {
  CustomFlowLabel() { this = "A" or this = "B" }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    node.(DataFlow::CallNode).getCalleeName() = "source" and
    lbl instanceof CustomFlowLabel
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = "sink" and
      node = call.getAnArgument() and
      lbl instanceof CustomFlowLabel
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof IsTypeAGuard or
    node instanceof IsSanitizedGuard
  }
}

/**
 * A condition that checks what kind of value the input is. Not enough to
 * sanitize the value, but later sanitizers only need to handle the relevant case.
 */
class IsTypeAGuard extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::CallNode {
  IsTypeAGuard() { getCalleeName() = "isTypeA" }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    e = getArgument(0).asExpr() and
    (
      outcome = true and lbl = "B"
      or
      outcome = false and lbl = "A"
    )
  }
}

class IsSanitizedGuard extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::CallNode {
  IsSanitizedGuard() { getCalleeName() = "sanitizeA" or getCalleeName() = "sanitizeB" }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
    e = getArgument(0).asExpr() and
    outcome = true and
    (
      getCalleeName() = "sanitizeA" and lbl = "A"
      or
      getCalleeName() = "sanitizeB" and lbl = "B"
    )
  }
}

from Config cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink
