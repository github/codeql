/**
 * Provides support for intra-procedural tracking of a customizable
 * set of data flow nodes.
 *
 * Note that unlike `TypeTracker.qll`, this library only performs
 * local tracking within a function.
 */

import python
import DataFlowPublic
private import DataFlowPrivate

private predicate comes_from_cfgnode(Node node) {
  exists(CfgNode first, Node second |
    simpleLocalFlowStep(first, second) and
    simpleLocalFlowStep*(second, node)
  )
}

/**
 * A data flow node that is a source of local flow. This includes things like
 * - Expressions
 * - Function parameters
 */
class LocalSourceNode extends Node {
  cached
  LocalSourceNode() {
    not comes_from_cfgnode(this) and
    not this instanceof ModuleVariableNode
    or
    this = any(ModuleVariableNode mvn).getARead()
  }

  /** Holds if this `LocalSourceNode` can flow to `nodeTo` in one or more local flow steps. */
  pragma[inline]
  predicate flowsTo(Node nodeTo) { Cached::hasLocalSource(nodeTo, this) }

  /**
   * Gets a reference (read or write) of attribute `attrName` on this node.
   */
  AttrRef getAnAttributeReference(string attrName) { Cached::namedAttrRef(this, attrName, result) }

  /**
   * Gets a read of attribute `attrName` on this node.
   */
  AttrRead getAnAttributeRead(string attrName) { result = getAnAttributeReference(attrName) }

  /**
   * Gets a reference (read or write) of any attribute on this node.
   */
  AttrRef getAnAttributeReference() {
    Cached::namedAttrRef(this, _, result)
    or
    Cached::dynamicAttrRef(this, result)
  }

  /**
   * Gets a read of any attribute on this node.
   */
  AttrRead getAnAttributeRead() { result = getAnAttributeReference() }

  /**
   * Gets a call to this node.
   */
  CallCfgNode getACall() { Cached::call(this, result) }
}

cached
private module Cached {
  /**
   * Holds if `source` is a `LocalSourceNode` that can reach `sink` via local flow steps.
   *
   * The slightly backwards parametering ordering is to force correct indexing.
   */
  cached
  predicate hasLocalSource(Node sink, LocalSourceNode source) {
    source = sink
    or
    exists(Node second |
      simpleLocalFlowStep(source, second) and
      simpleLocalFlowStep*(second, sink)
    )
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has attribute name `attr`.
   */
  cached
  predicate namedAttrRef(LocalSourceNode base, string attr, AttrRef ref) {
    base.flowsTo(ref.getObject()) and
    ref.getAttributeName() = attr
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has no known attribute name.
   */
  cached
  predicate dynamicAttrRef(LocalSourceNode base, AttrRef ref) {
    base.flowsTo(ref.getObject()) and
    not exists(ref.getAttributeName())
  }

  /**
   * Holds if `func` flows to the callee of `call`.
   */
  cached
  predicate call(LocalSourceNode func, CallCfgNode call) {
    exists(CfgNode n |
      func.flowsTo(n) and
      n = call.getFunction()
    )
  }
}
