private import semmle.code.cpp.dataflow.DataFlow
private import DataFlow

class ASTConf extends Configuration {
  ASTConf() { this = "ASTDerefConf" }

  override predicate isSource(Node src) {
    exists(FunctionCall fc |
      fc.getAnArgument() = src.asDefiningArgument() and
      exists(fc.getTarget().getName().regexpCapture("argument_source_(\\d)", 1).toInt())
    )
  }

  override predicate isSink(Node sink) {
    exists(Call c | c.getTarget().hasName("sink") | c.getAnArgument() = sink.asExpr())
  }
}
