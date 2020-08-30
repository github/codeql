/**
 * Provides support for intra-procedural tracking of a customizable
 * set of data flow nodes.
 *
 * Note that unlike `TypeTracking.qll`, this library only performs
 * local tracking within a function.
 */

private import javascript
private import semmle.javascript.dataflow.TypeTracking

/**
 * A source node for local data flow, that is, a node from which local data flow is tracked.
 *
 * This includes function invocations, parameters, object creation, and references to a property or global variable.
 *
 * You can introduce new kinds of source nodes by defining new subclasses of `DataFlow::SourceNode::Range`.
 *
 * Examples:
 * ```js
 * obj.f             // property access
 * Math.abs(x)       // function calls
 * { f: 12, g: 45 }; // object expressions
 * function fn(x) {} // functions and parameters
 * class C {}        // classes
 * document          // global variable access
 * <View/>           // JSX literals
 * /[a-z]+/g;        // regular expression literal
 * await x           // await expression
 * import * as fs from 'fs';
 * import { readDir } from 'fs';
 * import("fs")
 * ```
 */
class SourceNode extends DataFlow::Node {
  SourceNode() { this instanceof SourceNode::Range }

  /**
   * Holds if this node flows into `sink` in zero or more local (that is,
   * intra-procedural) steps.
   */
  predicate flowsTo(DataFlow::Node sink) { Cached::hasLocalSource(sink, this) }

  /**
   * Holds if this node flows into `sink` in zero or more local (that is,
   * intra-procedural) steps.
   */
  predicate flowsToExpr(Expr sink) { flowsTo(DataFlow::valueNode(sink)) }

  /**
   * Gets a reference (read or write) of property `propName` on this node.
   */
  DataFlow::PropRef getAPropertyReference(string propName) {
    Cached::namedPropRef(this, propName, result)
  }

  /**
   * Gets a read of property `propName` on this node.
   */
  DataFlow::PropRead getAPropertyRead(string propName) { result = getAPropertyReference(propName) }

  /**
   * Gets a write of property `propName` on this node.
   */
  DataFlow::PropWrite getAPropertyWrite(string propName) {
    result = getAPropertyReference(propName)
  }

  /**
   * Holds if there is an assignment to property `propName` on this node,
   * and the right hand side of the assignment is `rhs`.
   */
  pragma[nomagic]
  predicate hasPropertyWrite(string propName, DataFlow::Node rhs) {
    rhs = getAPropertyWrite(propName).getRhs()
  }

  /**
   * Gets a reference (read or write) of any property on this node.
   */
  DataFlow::PropRef getAPropertyReference() {
    Cached::namedPropRef(this, _, result)
    or
    Cached::dynamicPropRef(this, result)
  }

  /**
   * Gets a read of any property on this node.
   */
  DataFlow::PropRead getAPropertyRead() { result = getAPropertyReference() }

  /**
   * Gets a write of any property on this node.
   */
  DataFlow::PropWrite getAPropertyWrite() { result = getAPropertyReference() }

  /**
   * Gets an invocation of the method or constructor named `memberName` on this node.
   */
  DataFlow::InvokeNode getAMemberInvocation(string memberName) {
    result = getAPropertyRead(memberName).getAnInvocation()
  }

  /**
   * Gets a function call that invokes method `memberName` on this node.
   *
   * This includes both calls that have the syntactic shape of a method call
   * (as in `o.m(...)`), and calls where the callee undergoes some additional
   * data flow (as in `tmp = o.m; tmp(...)`).
   */
  DataFlow::CallNode getAMemberCall(string memberName) { result = getAMemberInvocation(memberName) }

  /**
   * Gets a method call that invokes method `methodName` on this node.
   *
   * This includes only calls that have the syntactic shape of a method call,
   * that is, `o.m(...)` or `o[p](...)`.
   */
  DataFlow::CallNode getAMethodCall(string methodName) {
    result = getAMemberInvocation(methodName) and
    Cached::isSyntacticMethodCall(result)
  }

  /**
   * Gets a method call that invokes a method on this node.
   *
   * This includes only calls that have the syntactic shape of a method call,
   * that is, `o.m(...)` or `o[p](...)`.
   */
  DataFlow::CallNode getAMethodCall() { result = getAMethodCall(_) }

  /**
   * Gets a chained method call that invokes `methodName` last.
   *
   * The chain steps include only calls that have the syntactic shape of a method call,
   * that is, `o.m(...)` or `o[p](...)`.
   */
  DataFlow::CallNode getAChainedMethodCall(string methodName) {
    result = getAMethodCall*().getAMethodCall(methodName)
  }

  /**
   * Gets a `new` call that invokes constructor `constructorName` on this node.
   */
  DataFlow::NewNode getAConstructorInvocation(string constructorName) {
    result = getAMemberInvocation(constructorName)
  }

  /**
   * Gets an invocation (with our without `new`) of this node.
   */
  DataFlow::InvokeNode getAnInvocation() { Cached::invocation(this, result) }

  /**
   * Gets a function call to this node.
   */
  DataFlow::CallNode getACall() { result = getAnInvocation() }

  /**
   * Gets a `new` call to this node.
   */
  DataFlow::NewNode getAnInstantiation() { result = getAnInvocation() }

  /**
   * Gets a source node whose value is stored in property `prop` of this node.
   */
  DataFlow::SourceNode getAPropertySource(string prop) {
    result.flowsTo(getAPropertyWrite(prop).getRhs())
  }

  /**
   * Gets a source node whose value is stored in a property of this node.
   */
  DataFlow::SourceNode getAPropertySource() { result.flowsTo(getAPropertyWrite().getRhs()) }

  /**
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  DataFlow::SourceNode track(TypeTracker t2, TypeTracker t) { t = t2.step(this, result) }

  /**
   * Gets a node that may flow into this one using one heap and/or interprocedural step.
   *
   * See `TypeBackTracker` for more details about how to use this.
   */
  pragma[inline]
  DataFlow::SourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) {
    t2 = t.step(result, this)
  }
}

/**
 * Cached predicates used by the member predicates in `SourceNode`.
 */
cached
private module Cached {
  /**
   * Holds if `source` is a `SourceNode` that can reach `sink` via local flow steps.
   *
   * The slightly backwards parametering ordering is to force correct indexing.
   */
  cached
  predicate hasLocalSource(DataFlow::Node sink, DataFlow::Node source) {
    // Declaring `source` to be a `SourceNode` currently causes a redundant check in the
    // recursive case, so instead we check it explicitly here.
    source = sink and
    source instanceof DataFlow::SourceNode
    or
    exists(DataFlow::Node mid |
      hasLocalSource(mid, source) and
      DataFlow::localFlowStep(mid, sink)
    )
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has property name `prop`.
   */
  cached
  predicate namedPropRef(DataFlow::SourceNode base, string prop, DataFlow::PropRef ref) {
    hasLocalSource(ref.getBase(), base) and
    ref.getPropertyName() = prop
  }

  /**
   * Holds if `base` flows to the base of `ref` and `ref` has no known property name.
   */
  cached
  predicate dynamicPropRef(DataFlow::SourceNode base, DataFlow::PropRef ref) {
    hasLocalSource(ref.getBase(), base) and
    not exists(ref.getPropertyName())
  }

  /**
   * Holds if `func` flows to the callee of `invoke`.
   */
  cached
  predicate invocation(DataFlow::SourceNode func, DataFlow::InvokeNode invoke) {
    hasLocalSource(invoke.getCalleeNode(), func)
  }

  /**
   * Holds if `invoke` has the syntactic shape of a method call.
   */
  cached
  predicate isSyntacticMethodCall(DataFlow::CallNode call) {
    call.getCalleeNode().asExpr().getUnderlyingReference() instanceof PropAccess
  }
}

module SourceNode {
  /**
   * A data flow node that should be considered a source node.
   *
   * Subclass this class to introduce new kinds of source nodes. If you want to refine
   * the definition of existing source nodes, subclass `DataFlow::SourceNode` instead.
   */
  cached
  abstract class Range extends DataFlow::Node { }

  /**
   * A data flow node that is considered a source node by default.
   *
   * This includes all nodes that evaluate to a new object and all nodes whose
   * value is computed using non-local data flow (that is, flow between functions,
   * between modules, or through the heap):
   *
   *   - import specifiers
   *   - function parameters
   *   - function receivers
   *   - property accesses
   *   - function invocations
   *   - global variable accesses
   *   - function definitions
   *   - class definitions
   *   - object expressions
   *   - array expressions
   *   - JSX literals
   *   - regular expression literals
   *   - `yield` expressions
   *   - `await` expressions
   *   - dynamic `import` expressions
   *   - function-bind expressions
   *   - `function.sent` expressions
   *   - comprehension expressions.
   *
   * This class is for internal use only and should not normally be used directly.
   */
  class DefaultRange extends Range {
    DefaultRange() {
      exists(ASTNode astNode | this = DataFlow::valueNode(astNode) |
        astNode instanceof PropAccess or
        astNode instanceof Function or
        astNode instanceof ClassDefinition or
        astNode instanceof ObjectExpr or
        astNode instanceof ArrayExpr or
        astNode instanceof JSXNode or
        astNode instanceof GlobalVarAccess or
        astNode instanceof ExternalModuleReference or
        astNode instanceof RegExpLiteral or
        astNode instanceof YieldExpr or
        astNode instanceof ComprehensionExpr or
        astNode instanceof AwaitExpr or
        astNode instanceof FunctionSentExpr or
        astNode instanceof FunctionBindExpr or
        astNode instanceof DynamicImportExpr or
        astNode instanceof ImportSpecifier or
        astNode instanceof ImportMetaExpr
      )
      or
      DataFlow::parameterNode(this, _)
      or
      this instanceof DataFlow::Impl::InvokeNodeDef
      or
      DataFlow::thisNode(this, _)
      or
      this = DataFlow::destructuredModuleImportNode(_)
      or
      this = DataFlow::globalAccessPathRootPseudoNode()
      or
      // Include return nodes because they model the implicit Promise creation in async functions.
      DataFlow::functionReturnNode(this, _)
    }
  }
}

deprecated class DefaultSourceNode extends SourceNode {
  DefaultSourceNode() { this instanceof SourceNode::DefaultRange }
}
