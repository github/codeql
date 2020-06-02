/**
 * @kind path-problem
 */

import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow
import cpp
import PathGraph

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
      c.getAnArgument() = sink.asExpr()
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

from DataFlow::PathNode src, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(src, sink)
select sink, src, sink, sink + " flows from $@", src, src.toString()
