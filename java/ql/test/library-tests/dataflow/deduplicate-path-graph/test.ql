/**
 * @kind path-problem
 */

import java
import semmle.code.java.dataflow.DataFlow
import DataFlow

MethodCall propagateCall(string state) {
  result.getMethod().getName() = "propagateState" and
  state = result.getArgument(1).(StringLiteral).getValue()
}

module TestConfig implements StateConfigSig {
  class FlowState = string;

  predicate isSource(Node n, FlowState state) {
    n.asExpr().(MethodCall).getMethod().getName() = "source" and state = ["A", "B"]
  }

  predicate isSink(Node n, FlowState state) {
    n.asExpr() = any(MethodCall acc | acc.getMethod().getName() = "sink").getAnArgument() and
    state = ["A", "B"]
  }

  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    exists(MethodCall call |
      call = propagateCall(state1) and
      state2 = state1 and
      node1.asExpr() = call.getArgument(0) and
      node2.asExpr() = call
    )
  }
}

module TestFlow = DataFlow::GlobalWithState<TestConfig>;

module Graph = DataFlow::DeduplicatePathGraph<TestFlow::PathNode, TestFlow::PathGraph>;

/**
 * Holds if `node` is reachable from a call to `propagateState` with the given `state` argument.
 * `call` indicates if a call step was taken (i.e. into a subpath).
 *
 * We use this to check if one `propagateState` can flow out of another, which is not allowed.
 */
predicate reachableFromPropagate(Graph::PathNode node, string state, boolean call) {
  node.getNode().asExpr() = propagateCall(state) and call = false
  or
  exists(Graph::PathNode prev | reachableFromPropagate(prev, state, call) |
    Graph::edges(prev, node, _, _) and
    not Graph::subpaths(prev, node, _, _) // argument-passing edges are handled separately
    or
    Graph::subpaths(prev, _, _, node) // arg -> out (should be included in 'edges' but handle the case here for clarity)
  )
  or
  exists(Graph::PathNode prev |
    reachableFromPropagate(prev, state, _) and
    Graph::subpaths(prev, node, _, _) and // arg -> parameter
    call = true
  )
  or
  exists(Graph::PathNode prev |
    reachableFromPropagate(prev, state, call) and
    Graph::subpaths(_, _, prev, node) and // return -> out
    call = false
  )
}

/**
 * Holds if `node` is the return value of a `propagateState` call that appears to be reachable
 * with a different state than the one propagated by the call, indicating spurious flow resulting from
 * merging path nodes.
 */
query predicate spuriousFlow(Graph::PathNode node, string state1, string state2) {
  reachableFromPropagate(node, state1, _) and
  node.getNode().asExpr() = propagateCall(state2) and
  state1 != state2
}

import Graph::PathGraph

from Graph::PathNode source, Graph::PathNode sink
where TestFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode())
select source, source, sink, "Flow"
