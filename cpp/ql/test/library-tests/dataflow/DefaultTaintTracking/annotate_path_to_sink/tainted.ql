/**
 * This test provides the possibility to annotate elements when they are on a path of a taint flow to a sink.
 * This is different when compared to the tests in `../annotate_sink`, where only sink invocations are annotated.
 */

import cpp
import semmle.code.cpp.security.TaintTrackingImpl as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking
import IRDefaultTaintTracking::TaintedWithPath as TaintedWithPath
import TestUtilities.InlineExpectationsTest

predicate isSink(Element sink) {
  exists(FunctionCall call |
    call.getTarget().getName() = "sink" and
    sink = call.getAnArgument()
  )
}

predicate astTaint(Expr source, Element sink) { ASTTaintTracking::tainted(source, sink) }

class SourceConfiguration extends TaintedWithPath::TaintTrackingConfiguration {
  override predicate isSink(Element e) { any() }
}

predicate irTaint(Expr source, Element sink) {
  TaintedWithPath::taintedWithPath(source, sink, _, _)
}

class IRDefaultTaintTrackingTest extends InlineExpectationsTest {
  IRDefaultTaintTrackingTest() { this = "IRDefaultTaintTrackingTest" }

  override string getARelevantTag() { result = "ir" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr source, Element tainted, int n |
      tag = "ir" and
      irTaint(source, tainted) and
      (
        isSink(tainted)
        or
        exists(Element sink |
          isSink(sink) and
          irTaint(tainted, sink)
        )
      ) and
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
      (
        isSink(tainted)
        or
        exists(Element sink |
          isSink(sink) and
          astTaint(tainted, sink)
        )
      ) and
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
