/**
 * This test provides the usual facilities to annotate taint flow when reaching a sink.
 * This is different when compared to the tests in `../annotate_path_to_sink`, where all elements on a taint path to a sink
 * are annotated.
 */

import cpp
import semmle.code.cpp.security.TaintTrackingImpl as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking
import TestUtilities.InlineExpectationsTest

predicate isSink(Element sink) {
  exists(FunctionCall call |
    call.getTarget().getName() = "sink" and
    sink = call.getAnArgument()
  )
}

predicate astTaint(Expr source, Element sink) {
  ASTTaintTracking::tainted(source, sink) and isSink(sink)
}

predicate irTaint(Expr source, Element sink) {
  IRDefaultTaintTracking::tainted(source, sink) and isSink(sink)
}

class IRDefaultTaintTrackingTest extends InlineExpectationsTest {
  IRDefaultTaintTrackingTest() { this = "IRDefaultTaintTrackingTest" }

  override string getARelevantTag() { result = "ir" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr source, Element tainted, int n |
      tag = "ir" and
      irTaint(source, tainted) and
      n = strictcount(Expr otherSource | irTaint(otherSource, tainted)) and
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
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}

class ASTTaintTrackingTest extends InlineExpectationsTest {
  ASTTaintTrackingTest() { this = "ASTTaintTrackingTest" }

  override string getARelevantTag() { result = "ast" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr source, Element tainted, int n |
      tag = "ast" and
      astTaint(source, tainted) and
      n = strictcount(Expr otherSource | astTaint(otherSource, tainted)) and
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
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}
