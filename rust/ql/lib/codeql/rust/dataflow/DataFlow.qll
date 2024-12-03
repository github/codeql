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

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  final class ParameterNode extends Node instanceof Node::SourceParameterNode {
    /** Gets the parameter that this node corresponds to. */
    ParamBase getParameter() { result = super.getParameter().getParamBase() }
  }

  final class PostUpdateNode = Node::PostUpdateNode;

  final class Content = DataFlowImpl::Content;

  final class VariantContent = DataFlowImpl::VariantContent;

  final class ContentSet = DataFlowImpl::ContentSet;

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
