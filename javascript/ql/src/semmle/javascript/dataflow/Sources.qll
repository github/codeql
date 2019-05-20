/**
 * Provides support for intra-procedural tracking of a customizable
 * set of data flow nodes.
 *
 * Note that unlike `TrackedNodes`, this library only performs
 * local tracking within a function.
 */

import javascript
private import semmle.javascript.dataflow.TypeTracking

/**
 * A source node for local data flow, that is, a node from which local data flow is tracked.
 *
 * Examples include function parameters, imports and property accesses; see
 * `DataFlow::SourceNode::DefaultRange` for details. You can introduce new kinds of
 * source nodes by defining new subclasses of `DataFlow::SourceNode::Range`.
 */
class SourceNode extends DataFlow::Node {
  SourceNode() { this instanceof SourceNode::Range }

  /**
   * Holds if this node flows into `sink` in zero or more local (that is,
   * intra-procedural) steps.
   */
  cached
  predicate flowsTo(DataFlow::Node sink) {
    sink = this or
    flowsTo(sink.getAPredecessor())
  }

  /**
   * Holds if this node flows into `sink` in zero or more local (that is,
   * intra-procedural) steps.
   */
  predicate flowsToExpr(Expr sink) { flowsTo(DataFlow::valueNode(sink)) }

  /**
   * Gets a reference (read or write) of property `propName` on this node.
   */
  DataFlow::PropRef getAPropertyReference(string propName) {
    result = getAPropertyReference() and
    result.getPropertyName() = propName
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
  predicate hasPropertyWrite(string propName, DataFlow::Node rhs) {
    rhs = getAPropertyWrite(propName).getRhs()
  }

  /**
   * Gets a reference (read or write) of any property on this node.
   */
  DataFlow::PropRef getAPropertyReference() { flowsTo(result.getBase()) }

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
    exists(PropAccess pacc |
      pacc = result.getCalleeNode().asExpr().getUnderlyingReference() and
      flowsToExpr(pacc.getBase()) and
      pacc.getPropertyName() = methodName
    )
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
  DataFlow::InvokeNode getAnInvocation() { flowsTo(result.getCalleeNode()) }

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
   * EXPERIMENTAL.
   *
   * Gets a node that this node may flow to using one heap and/or interprocedural step.
   *
   * See `TypeTracker` for more details about how to use this.
   */
  pragma[inline]
  DataFlow::SourceNode track(TypeTracker t2, TypeTracker t) {
    t = t2.step(this, result)
  }

  /**
   * EXPERIMENTAL.
   *
   * Gets a node that may flow into this one using one heap and/or interprocedural step.
   *
   * See `TypeBackTracker` for more details about how to use this.
   */
  pragma[inline]
  DataFlow::SourceNode backtrack(TypeBackTracker t2, TypeBackTracker t) {
    t2 = t.step(result, this)
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
   * Currently, the following nodes are source nodes:
   *   - import specifiers
   *   - function parameters
   *   - `this` nodes
   *   - property accesses
   *   - function invocations
   *   - global variable accesses
   *   - function definitions
   *   - class definitions
   *   - object expressions
   *   - array expressions
   *   - JSX literals
   *   - regular expression literals
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
        astNode instanceof RegExpLiteral
      )
      or
      this = DataFlow::ssaDefinitionNode(SSA::definition(any(ImportSpecifier imp)))
      or
      DataFlow::parameterNode(this, _)
      or
      this instanceof DataFlow::Impl::InvokeNodeDef
      or
      DataFlow::thisNode(this, _)
      or
      this = DataFlow::destructuredModuleImportNode(_)
    }
  }
}

deprecated class DefaultSourceNode extends SourceNode {
  DefaultSourceNode() { this instanceof SourceNode::DefaultRange }
}
