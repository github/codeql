/**
 * This test provides the possibility to annotate elements when they are on a path of a taint flow to a sink.
 * This is different when compared to the tests in `../annotate_sink`, where only sink invocations are annotated.
 */

import cpp
import semmle.code.cpp.security.TaintTrackingImpl as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking
import IRDefaultTaintTracking::TaintedWithPath as TaintedWithPath
import TaintedWithPath::Private
import TestUtilities.InlineExpectationsTest

predicate isSinkArgument(Element sink) {
  exists(FunctionCall call |
    call.getTarget().getName() = "sink" and
    sink = call.getAnArgument()
  )
}

predicate astTaint(Expr source, Element sink) { ASTTaintTracking::tainted(source, sink) }

class SourceConfiguration extends TaintedWithPath::TaintTrackingConfiguration {
  override predicate isSink(Element e) { isSinkArgument(e) }
}

predicate irTaint(Element source, TaintedWithPath::PathNode predNode, string tag) {
  exists(TaintedWithPath::PathNode sinkNode |
    TaintedWithPath::taintedWithPath(source, _, _, sinkNode) and
    predNode = getAPredecessor*(sinkNode) and
    // Make sure the path is actually reachable from this predecessor.
    // Otherwise, we could pick `predNode` to be b when `source` is
    // `source1` in this dataflow graph:
    // source1 ---> a ---> c ---> sinkNode
    //                   ^
    // source2 ---> b --/
    source = getElementFromPathNode(getAPredecessor*(predNode)) and
    if predNode = sinkNode then tag = "ir-sink" else tag = "ir-path"
  )
}

class IRDefaultTaintTrackingTest extends InlineExpectationsTest {
  IRDefaultTaintTrackingTest() { this = "IRDefaultTaintTrackingTest" }

  override string getARelevantTag() { result = ["ir-path", "ir-sink"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element source, Element elem, TaintedWithPath::PathNode node, int n |
      irTaint(source, node, tag) and
      elem = getElementFromPathNode(node) and
      n = count(int startline | getAPredecessor(node).hasLocationInfo(_, startline, _, _, _)) and
      location = elem.getLocation() and
      element = elem.toString()
    |
      // Zero predecessors means it's a source, and 1 predecessor means it has a unique predecessor.
      // In either of these cases we leave out the location.
      n = [0, 1] and value = ""
      or
      // If there is more than one predecessor for this node
      // we specify the source location explicitly.
      n > 1 and
      exists(TaintedWithPath::PathNode pred | pred = getAPredecessor(node) |
        value =
          getElementFromPathNode(pred).getLocation().getStartLine().toString() + ":" +
            getElementFromPathNode(pred).getLocation().getStartColumn()
      )
    )
  }
}

class AstTaintTrackingTest extends InlineExpectationsTest {
  AstTaintTrackingTest() { this = "ASTTaintTrackingTest" }

  override string getARelevantTag() { result = "ast" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr source, Element tainted, int n |
      tag = "ast" and
      astTaint(source, tainted) and
      (
        isSinkArgument(tainted)
        or
        exists(Element sink |
          isSinkArgument(sink) and
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
