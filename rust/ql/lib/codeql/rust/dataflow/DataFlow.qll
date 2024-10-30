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

  predicate localFlowStep = DataFlowImpl::localFlowStep/2;

  import DataFlowMake<Location, DataFlowImpl::RustDataFlow>
}
