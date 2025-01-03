/**
 * Helper library for implementing data or taint flow inline expectation tests.
 * As long as data or taint flow configurations for IR and/or AST based data/taint flow
 * are in scope, provides inline expectations tests.
 * All sinks that have flow are annotated with `ast` (or respective `ir`) if there
 * is a unique source for the flow.
 * Otherwise, if there are multiple sources that can reach a given sink, the annotations
 * have the form `ast=lineno:column` (or `ir=lineno:column`).
 * If a sink is reachable through both AST and IR flow, the annotations have the form
 * `ast,ir` or `ast,ir=lineno:column`.
 * Intermediate steps from the source to the sink are not annotated.
 */

import cpp
private import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow as IRDataFlow
private import semmle.code.cpp.dataflow.DataFlow::DataFlow as AstDataFlow
import utils.test.InlineExpectationsTest

module IRFlowTest<IRDataFlow::GlobalFlowSig Flow> implements TestSig {
  string getARelevantTag() { result = "ir" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(IRDataFlow::Node source, IRDataFlow::Node sink, int n |
      tag = "ir" and
      Flow::flow(source, sink) and
      n =
        strictcount(int line, int column |
          Flow::flow(any(IRDataFlow::Node otherSource |
              otherSource.hasLocationInfo(_, line, column, _, _)
            ), sink)
        ) and
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

module AstFlowTest<AstDataFlow::GlobalFlowSig Flow> implements TestSig {
  string getARelevantTag() { result = "ast" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstDataFlow::Node source, AstDataFlow::Node sink, int n |
      tag = "ast" and
      Flow::flow(source, sink) and
      n =
        strictcount(int line, int column |
          Flow::flow(any(AstDataFlow::Node otherSource |
              otherSource.hasLocationInfo(_, line, column, _, _)
            ), sink)
        ) and
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
