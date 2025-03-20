/**
 * Provides a module for performing local (intra-procedural) and global
 * (inter-procedural) data flow analyses.
 */

private import rust
private import codeql.dataflow.DataFlow
private import internal.DataFlowImpl as DataFlowImpl
private import internal.Node as Node
private import internal.Content as Content

/**
 * Provides classes for performing local (intra-procedural) and global
 * (inter-procedural) data flow analyses.
 */
module DataFlow {
  final class Node = Node::NodePublic;

  /**
   * The value of a parameter at function entry, viewed as a node in a data
   * flow graph.
   */
  final class ParameterNode extends Node instanceof Node::SourceParameterNode { }

  final class PostUpdateNode = Node::PostUpdateNodePublic;

  final class Content = Content::Content;

  final class FieldContent = Content::FieldContent;

  final class TuplePositionContent = Content::TuplePositionContent;

  final class TupleFieldContent = Content::TupleFieldContent;

  final class StructFieldContent = Content::StructFieldContent;

  final class ReferenceContent = Content::ReferenceContent;

  final class ElementContent = Content::ElementContent;

  final class FutureContent = Content::FutureContent;

  final class ContentSet = Content::ContentSet;

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
