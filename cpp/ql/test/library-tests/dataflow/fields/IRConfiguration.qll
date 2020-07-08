private import semmle.code.cpp.ir.dataflow.DataFlow
private import DataFlow

class Conf extends Configuration {
  Conf() { this = "FieldFlowConf" }

  override predicate isSource(Node src) {
    src.asExpr() instanceof NewExpr
    or
    src.asExpr().(Call).getTarget().hasName("user_input")
    or
    exists(FunctionCall fc |
      fc.getAnArgument() = src.asDefiningArgument() and
      fc.getTarget().hasName("argument_source")
    )
  }

  override predicate isSink(Node sink) {
    exists(Call c |
      c.getTarget().hasName("sink") and
      c.getAnArgument() = sink.asConvertedExpr()
    )
  }

  override predicate isAdditionalFlowStep(Node a, Node b) {
    b.asPartialDefinition() =
      any(Call c | c.getTarget().hasName("insert") and c.getAnArgument() = a.asExpr())
          .getQualifier()
    or
    b.asExpr().(AddressOfExpr).getOperand() = a.asExpr()
  }
}
