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
private import semmle.python.internal.CachedStages

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
    Stages::DataFlow::ref() and
    this instanceof ExprNode and
    not simpleLocalFlowStep(_, this)
    or
    // We include all module variable nodes, as these act as stepping stones between writes and
    // reads of global variables. Without them, type tracking based on `LocalSourceNode`s would be
    // unable to track across global variables.
    //
    // Once the `track` and `backtrack` methods have been fully deprecated, this disjunct can be
    // removed, and the entire class can extend `ExprNode`. At that point, `TypeTrackingNode` should
    // be used for type tracking instead of `LocalSourceNode`.
    this instanceof ModuleVariableNode
    or
    // We explicitly include any read of a global variable, as some of these may have local flow going
    // into them.
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
  AttrRead getAnAttributeRead(string attrName) { result = this.getAnAttributeReference(attrName) }

  /**
   * Gets a write of attribute `attrName` on this node.
   */
  AttrWrite getAnAttributeWrite(string attrName) { result = this.getAnAttributeReference(attrName) }

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
  AttrRead getAnAttributeRead() { result = this.getAnAttributeReference() }

  /**
   * Gets a write of any attribute on this node.
   */
  AttrWrite getAnAttributeWrite() { result = this.getAnAttributeReference() }

  /**
   * Gets a call to this node.
   */
  CallCfgNode getACall() { Cached::call(this, result) }

  /**
   * Gets a call to the method `methodName` on this node.
   *
   * Includes both calls that have the syntactic shape of a method call (as in `obj.m(...)`), and
   * calls where the callee undergoes some additional local data flow (as in `tmp = obj.m; m(...)`).
   */
  MethodCallNode getAMethodCall(string methodName) {
    result = this.getAnAttributeRead(methodName).getACall()
  }

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

/**
 * A node that can be used for type tracking or type back-tracking.
 *
 * All steps made during type tracking should be between instances of this class.
 */
class TypeTrackingNode = LocalSourceNode;

/** Temporary holding ground for the `TypeTrackingNode` class. */
private module FutureWork {
  class FutureTypeTrackingNode extends Node {
    FutureTypeTrackingNode() {
      this instanceof LocalSourceNode
      or
      this instanceof ModuleVariableNode
    }

    /**
     * Holds if this node can flow to `nodeTo` in one or more local flow steps.
     *
     * For `ModuleVariableNode`s, the only "local" step is to the node itself.
     * For `LocalSourceNode`s, this is the usual notion of local flow.
     */
    pragma[inline]
    predicate flowsTo(Node node) {
      this instanceof ModuleVariableNode and this = node
      or
      this.(LocalSourceNode).flowsTo(node)
    }

    /**
     * Gets a node that this node may flow to using one heap and/or interprocedural step.
     *
     * See `TypeTracker` for more details about how to use this.
     */
    pragma[inline]
    TypeTrackingNode track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }

    /**
     * Gets a node that may flow into this one using one heap and/or interprocedural step.
     *
     * See `TypeBackTracker` for more details about how to use this.
     */
    pragma[inline]
    TypeTrackingNode backtrack(TypeBackTracker t2, TypeBackTracker t) { t2 = t.step(result, this) }
  }
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
    Stages::DataFlow::ref() and
    source = sink
    or
    exists(Node second |
      localSourceFlowStep(source, second) and
      localSourceFlowStep*(second, sink)
    )
  }

  /**
   * Helper predicate for `hasLocalSource`. Removes any steps go to module variable reads, as these
   * are already local source nodes in their own right.
   */
  cached
  private predicate localSourceFlowStep(Node nodeFrom, Node nodeTo) {
    simpleLocalFlowStep(nodeFrom, nodeTo) and
    not nodeTo = any(ModuleVariableNode v).getARead()
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
