private import semmle.code.cpp.ir.dataflow.DataFlow
private import DataFlow

class IRConf extends Configuration {
  IRConf() { this = "IRDerefConf" }

  override predicate isSource(Node src) {
    exists(FunctionCall fc, int ind |
      fc.getAnArgument() = src.asDefiningArgument(ind) and
      ind = fc.getTarget().getName().regexpCapture("argument_source_(\\d)", 1).toInt()
    )
  }

  override predicate isSink(Node sink) {
    exists(Call c | c.getTarget().hasName("sink") | c.getAnArgument() = sink.asExpr())
  }
}
