/**
 * Provides a module for performing local (intra-procedural) and global
 * (inter-procedural) data flow analyses.
 */

private import rust
private import codeql.dataflow.DataFlow
private import internal.DataFlowImpl as DataFlowImpl
private import DataFlowImpl::Node as Node

/**
 * Provides classes for performing local (intra-procedural) and global
 * (inter-procedural) data flow analyses.
 */
module DataFlow {
  final class Node = Node::Node;

  final class ParameterNode = Node::ParameterNode;

  final class PostUpdateNode = Node::PostUpdateNode;

  /**
   * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localFlowStep = DataFlowImpl::localFlowStepImpl/2;

  /**
   * Holds if data flows from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  pragma[inline]
  predicate localFlow(Node::Node source, Node::Node sink) { localFlowStep*(source, sink) }

  import DataFlowMake<Location, DataFlowImpl::RustDataFlow>
}
