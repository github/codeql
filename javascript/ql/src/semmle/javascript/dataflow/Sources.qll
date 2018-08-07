/**
 * Provides support for intra-procedural tracking of a customizable
 * set of data flow nodes.
 *
 * Note that unlike `TrackedNodes`, this library only performs
 * local tracking within a function.
 */

import javascript

/**
 * A source node for local data flow, that is, a node for which local
 * data flow cannot provide any information about its inputs.
 *
 * By default, functions, object and array expressions and JSX nodes
 * are considered sources, as well as expressions that have non-local
 * flow (such as calls and property accesses). Additional sources
 * can be modelled by extending this class with additional subclasses.
 */
abstract class SourceNode extends DataFlow::Node {
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
  predicate flowsToExpr(Expr sink) {
    flowsTo(DataFlow::valueNode(sink))
  }

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
  DataFlow::PropRead getAPropertyRead(string propName) {
    result = getAPropertyReference(propName)
  }

  /**
   * Gets a write of property `propName` on this node.
   */
  DataFlow::PropWrite getAPropertyWrite(string propName) {
    result = getAPropertyReference(propName)
  }

  /**
   * DEPRECATED: Use `getAPropertyReference` instead.
   *
   * Gets an access to property `propName` on this node, either through
   * a dot expression (as in `x.propName`) or through an index expression
   * (as in `x["propName"]`).
   */
  deprecated DataFlow::PropRead getAPropertyAccess(string propName) {
    result = getAPropertyReference(propName) and
    result.asExpr() instanceof PropAccess
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
  DataFlow::PropRef getAPropertyReference() {
    flowsTo(result.getBase())
  }

  /**
   * Gets a read of any property on this node.
   */
  DataFlow::PropRead getAPropertyRead() {
    result = getAPropertyReference()
  }

  /**
   * Gets a write of any property on this node.
   */
  DataFlow::PropWrite getAPropertyWrite() {
    result = getAPropertyReference()
  }

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
  DataFlow::CallNode getAMemberCall(string memberName) {
    result = getAMemberInvocation(memberName)
  }

  /**
   * Gets a method call that invokes method `methodName` on this node.
   *
   * This includes only calls that have the syntactic shape of a method call,
   * that is, `o.m(...)` or `o[p](...)`.
   */
  DataFlow::CallNode getAMethodCall(string methodName) {
    exists (PropAccess pacc |
      pacc = result.getCalleeNode().asExpr().stripParens() and
      flowsToExpr(pacc.getBase()) and
      pacc.getPropertyName() = methodName
    )
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
  DataFlow::InvokeNode getAnInvocation() {
    flowsTo(result.getCalleeNode())
  }

  /**
   * Gets a function call to this node.
   */
  DataFlow::CallNode getACall() {
    result = getAnInvocation()
  }

  /**
   * Gets a `new` call to this node.
   */
  DataFlow::NewNode getAnInstantiation() {
    result = getAnInvocation()
  }
}

/**
 * A data flow node that is considered a source node by default.
 *
 * Currently, the following nodes are source nodes:
 *   - import specifiers
 *   - non-destructuring function parameters
 *   - property accesses
 *   - function invocations
 *   - `this` expressions
 *   - global variable accesses
 *   - function definitions
 *   - class definitions
 *   - object expressions
 *   - array expressions
 *   - JSX literals.
 */
class DefaultSourceNode extends SourceNode {
  DefaultSourceNode() {
    exists (ASTNode astNode | this = DataFlow::valueNode(astNode) |
      astNode instanceof PropAccess or
      astNode instanceof Function or
      astNode instanceof ClassDefinition or
      astNode instanceof ObjectExpr or
      astNode instanceof ArrayExpr or
      astNode instanceof JSXNode or
      astNode instanceof ThisExpr or
      astNode instanceof GlobalVarAccess or
      astNode instanceof ExternalModuleReference
    )
    or
    exists (SsaExplicitDefinition ssa, VarDef def |
      this = DataFlow::ssaDefinitionNode(ssa) and def = ssa.getDef() |
      def instanceof ImportSpecifier
    )
    or
    DataFlow::parameterNode(this, _)
    or
    this instanceof DataFlow::Impl::InvokeNodeDef
  }
}
