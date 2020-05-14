/**
 * @kind problem
 */

import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.ir.dataflow.DataFlow
import DataFlow
import cpp

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

class IRFieldFlowTest extends InlineExpectationsTest {
  IRFieldFlowTest() { this = "IRFieldFlowTest" }

  override string getARelevantTag() { result = "ir" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node source, Node sink, Conf conf, int n |
      tag = "ir" and
      conf.hasFlow(source, sink) and
      n = strictcount(Node otherSource | conf.hasFlow(otherSource, sink)) and
      (
        n = 1 and value = ""
        or
        // If there is more than one source for this sink
        // we specify the source location explicitly.
        n > 1 and
        value =
          source.getLocation().getStartLine().toString() + ":" +
            source.getLocation().getStartColumn()
      ) and
      location = sink.getLocation() and
      element = sink.toString()
    )
  }
}
