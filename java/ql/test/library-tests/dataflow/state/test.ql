import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest
import DataFlow

predicate src(Node n, string s) {
  exists(MethodAccess ma |
    n.asExpr() = ma and
    ma.getMethod().hasName("source") and
    ma.getAnArgument().(StringLiteral).getValue() = s
  )
}

predicate sink(Node n, string s) {
  exists(MethodAccess ma |
    ma.getMethod().hasName("sink") and
    n.asExpr() = ma.getArgument(0) and
    ma.getArgument(1).(StringLiteral).getValue() = s
  )
}

predicate bar(Node n, string s) {
  exists(MethodAccess ma |
    ma.getMethod().hasName("stateBarrier") and
    n.asExpr() = ma.getArgument(0) and
    ma.getArgument(1).(StringLiteral).getValue() = s
  )
}

predicate step(Node n1, Node n2, string s1, string s2) {
  exists(MethodAccess ma |
    ma.getMethod().hasName("step") and
    n1.asExpr() = ma.getArgument(0) and
    ma.getArgument(1).(StringLiteral).getValue() = s1 and
    ma.getArgument(2).(StringLiteral).getValue() = s2 and
    ma = n2.asExpr()
  )
}

predicate checkNode(Node n) { n.asExpr().(Argument).getCall().getCallee().hasName("check") }

module Config implements DataFlow::StateConfigSig {
  class FlowState = string;

  predicate isSource(Node n, FlowState s) { src(n, s) }

  predicate isSink(Node n, FlowState s) { sink(n, s) }

  predicate isBarrier(Node n, FlowState s) { bar(n, s) }

  predicate isAdditionalFlowStep(Node n1, FlowState s1, Node n2, FlowState s2) {
    step(n1, n2, s1, s2)
  }
}

int explorationLimit() { result = 0 }

module Flow = TaintTracking::MakeWithState<Config>;

module PartialFlow = Flow::FlowExploration<explorationLimit/0>;

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["pFwd", "pRev", "flow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(Flow::PathNode src, Flow::PathNode sink |
      Flow::hasFlowPath(src, sink) and
      sink.getNode().getLocation() = location and
      element = sink.toString() and
      value = src.getState()
    )
    or
    tag = "pFwd" and
    exists(PartialFlow::PartialPathNode src, PartialFlow::PartialPathNode node |
      PartialFlow::hasPartialFlow(src, node, _) and
      checkNode(node.getNode()) and
      node.getNode().getLocation() = location and
      element = node.toString() and
      value = src.getState() + "-" + node.getState()
    )
    or
    tag = "pRev" and
    exists(PartialFlow::PartialPathNode node, PartialFlow::PartialPathNode sink |
      PartialFlow::hasPartialFlowRev(node, sink, _) and
      checkNode(node.getNode()) and
      node.getNode().getLocation() = location and
      element = node.toString() and
      value = node.getState() + "-" + sink.getState()
    )
  }
}
