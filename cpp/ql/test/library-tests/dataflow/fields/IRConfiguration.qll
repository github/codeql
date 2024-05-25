private import semmle.code.cpp.ir.dataflow.DataFlow
private import DataFlow

private class TestAdditionalCallTarget extends AdditionalCallTarget {
  override Function viableTarget(Call call) {
    // To test that call targets specified by `AdditionalCallTarget` are
    // resolved correctly this subclass resolves all calls to
    // `call_template_argument<f>(x)` as if the user had written `f(x)`.
    exists(FunctionTemplateInstantiation inst |
      inst.getTemplate().hasName("call_template_argument") and
      call.getTarget() = inst and
      result = inst.getTemplateArgument(0).(FunctionAccess).getTarget()
    )
  }
}

module IRConfig implements ConfigSig {
  predicate isSource(Node src) {
    src.asExpr() instanceof NewExpr
    or
    src.asExpr().(Call).getTarget().hasName("user_input")
    or
    exists(FunctionCall fc |
      fc.getAnArgument() = src.asDefiningArgument() and
      fc.getTarget().hasName("argument_source")
    )
  }

  predicate isSink(Node sink) {
    exists(Call c |
      c.getTarget().hasName("sink") and
      c.getAnArgument() = [sink.asExpr(), sink.asIndirectExpr(), sink.asConvertedExpr()]
    )
  }

  predicate isAdditionalFlowStep(Node a, Node b) {
    b.asPartialDefinition() =
      any(Call c | c.getTarget().hasName("insert") and c.getAnArgument() = a.asExpr())
          .getQualifier()
    or
    b.asExpr().(AddressOfExpr).getOperand() = a.asExpr()
  }
}

module IRFlow = Global<IRConfig>;
