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

/**
 * A data flow node that is a source of local flow. This includes things like
 * - Expressions
 * - Function parameters
 *
 *
 * Local source nodes and the `flowsTo` relation should be thought of in terms of the reference
 * semantics of the underlying object. For instance, in the following snippet of code
 *
 * ```python
 *     x = []
 *     x.append(1)
 *     x.append(2)
 * ```
 *
 * the local source node corresponding to the occurrences of `x` is the empty list that is assigned to `x`
 * originally. Even though the two `append` calls modify the value of `x`, they do not change the fact that
 * `x` still points to the same object. If, however, we next do `x = x + [3]`, then the expression `x + [3]`
 * will be the new local source of what `x` now points to.
 */
class LocalSourceNode extends Node {
  cached
  LocalSourceNode() {
    not simpleLocalFlowStep(_, this) and
    // Currently, we create synthetic post-update nodes for
    // - arguments to calls that may modify said argument
    // - direct reads a writes of object attributes
    // Both of these preserve the identity of the underlying pointer, and hence we exclude these as
    // local source nodes.
    // We do, however, allow the post-update nodes that arise from object creation (which are non-synthetic).
    not this instanceof SyntheticPostUpdateNode
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

  /**
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  LocalSourceNode track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }

  /**
   * Gets a node that may flow into this one using one heap and/or interprocedural step.
   *
   * See `TypeBackTracker` for more details about how to use this.
   */
  pragma[inline]
  LocalSourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) { t2 = t.step(result, this) }
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
