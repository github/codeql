/**
 * Provides an implementation of _API graphs_, which allow efficient modelling of how a given
 * value is used by the code base or how values produced by the code base are consumed by a library.
 *
 * See `API::Node` for more details.
 */

private import powershell
private import semmle.code.powershell.dataflow.DataFlow
private import semmle.code.powershell.typetracking.ApiGraphShared
private import semmle.code.powershell.typetracking.internal.TypeTrackingImpl
private import semmle.code.powershell.controlflow.Cfg
private import frameworks.data.internal.ApiGraphModelsExtensions as Extensions
private import frameworks.data.internal.ApiGraphModelsSpecific as Specific
private import semmle.code.powershell.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.powershell.dataflow.internal.DataFlowDispatch as DataFlowDispatch

/**
 * Provides classes and predicates for working with APIs used in a database.
 */
module API {
  /**
   * A node in the API graph, that is, a value that can be tracked interprocedurally.
   *
   * The API graph is a graph for tracking values of certain types in a way that accounts for inheritance
   * and interprocedural data flow.
   *
   * API graphs are typically used to identify "API calls", that is, calls to an external function
   * whose implementation is not necessarily part of the current codebase.
   *
   * ### Basic usage
   *
   * The most basic use of API graphs is typically as follows:
   * 1. Start with `API::getTopLevelMember` for the relevant library.
   * 2. Follow up with a chain of accessors such as `getMethod` describing how to get to the relevant API function.
   * 3. Map the resulting API graph nodes to data-flow nodes, using `asSource`, `asSink`, or `asCall`.
   *
   * ### Data flow
   *
   * The members predicates on this class generally take inheritance and data flow into account.
   *
   * ### Backward data flow
   *
   * When inspecting the arguments of a call, the data flow direction is backwards.
   *
   * ### Inheritance
   *
   * When a class or module object is tracked, inheritance is taken into account.
   *
   * ### Backward data flow and classes
   *
   * When inspecting the arguments of a call, and the value flowing into that argument is a user-defined class (or an instance thereof),
   * uses of `getMethod` will find method definitions in that class (including inherited ones) rather than finding method calls.
   *
   * When modeling an external library that is known to call a specific method on a parameter, this makes
   * it possible to find the corresponding method definition in user code.
   *
   * ### Strict left-to-right evaluation
   *
   * Most member predicates on this class are intended to be chained, and are always evaluated from left to right, which means
   * the caller should restrict the initial set of values.
   *
   * For example, in the following snippet, we always find the uses of `Foo` before finding calls to `bar`:
   * ```ql
   * API::getTopLevelMember("Foo").getMethod("bar")
   * ```
   * In particular, the implementation will never look for calls to `bar` and work backward from there.
   *
   * Beware of the footgun that is to use API graphs with an unrestricted receiver:
   * ```ql
   * API::Node barCall(API::Node base) {
   *   result = base.getMethod("bar") // Do not do this!
   * }
   * ```
   * The above predicate does not restrict the receiver, and will thus perform an interprocedural data flow
   * search starting at every node in the graph, which is very expensive.
   */
  class Node extends Impl::TApiNode {
    /**
     * Gets a data-flow node where this value may flow interprocedurally.
     *
     * This is similar to `asSource()` but additionally includes nodes that are transitively reachable by data flow.
     * See `asSource()` for examples.
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::Node getAValueReachableFromSource() {
      result = getAValueReachableFromSourceInline(this)
    }

    /**
     * Gets a data-flow node where this value enters the current codebase.
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::LocalSourceNode asSource() { result = asSourceInline(this) }

    /** Gets a data-flow node where this value potentially flows into an external library. */
    bindingset[this]
    pragma[inline_late]
    DataFlow::Node asSink() { result = asSinkInline(this) }

    /** Gets a callable that can reach this sink. */
    bindingset[this]
    pragma[inline_late]
    DataFlow::CallableNode asCallable() { Impl::asCallable(this.getAnEpsilonSuccessor(), result) }

    /**
     * Get a data-flow node that transitively flows to this value, provided that this value corresponds
     * to a sink.
     *
     * This is similar to `asSink()` but additionally includes nodes that transitively reach a sink by data flow.
     * See `asSink()` for examples.
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::Node getAValueReachingSink() { result = getAValueReachingSinkInline(this) }

    /** Gets the call referred to by this API node. */
    bindingset[this]
    pragma[inline_late]
    DataFlow::CallNode asCall() { this = Impl::MkMethodAccessNode(result) }

    pragma[inline]
    Node getMember(string m) {
      // This predicate is currently not 'inline_late' because 'm' can be an input or output
      Impl::memberEdge(this.getAnEpsilonSuccessor(), m, result)
    }

    /**
     * Gets a node that may refer to an instance of the module or class represented by this API node.
     */
    bindingset[this]
    pragma[inline_late]
    Node getInstance() { Impl::instanceEdge(this.getAnEpsilonSuccessor(), result) }

    /**
     * Gets a call to `method` with this value as the receiver, or the definition of `method` on
     * an object that can reach this sink.
     */
    pragma[inline]
    Node getMethod(string method) {
      // TODO: Consider 'getMethodTarget(method)' for looking up method definitions?
      // This predicate is currently not 'inline_late' because 'method' can be an input or output
      Impl::methodEdge(this.getAnEpsilonSuccessor(), method, result)
    }

    /**
     * Gets the result of this call, or the return value of this callable.
     */
    bindingset[this]
    pragma[inline_late]
    Node getReturn() { Impl::returnEdge(this.getAnEpsilonSuccessor(), result) }

    /**
     * Gets the result of this call when there is a named argument with the
     * name `name`, or the return value of this callable.
     */
    bindingset[this]
    pragma[inline_late]
    Node getReturnWithArg(string name) {
      Impl::returnEdgeWithArg(this.getAnEpsilonSuccessor(), name, result)
    }

    /**
     * Gets the result of a call to `method` with this value as the receiver, or the return value of `method` defined on
     * an object that can reach this sink.
     *
     * This is a shorthand for `getMethod(method).getReturn()`.
     */
    pragma[inline]
    Node getReturn(string method) {
      // This predicate is currently not 'inline_late' because 'method' can be an input or output
      result = this.getMethod(method).getReturn()
    }

    /**
     * Gets the `n`th positional argument to this call.
     */
    pragma[inline]
    Node getArgument(int n) {
      // This predicate is currently not 'inline_late' because 'n' can be an input or output
      Impl::positionalArgumentEdge(this, n, result)
    }

    /**
     * Gets the given keyword argument to this call.
     */
    pragma[inline]
    Node getKeywordArgument(string name) {
      // This predicate is currently not 'inline_late' because 'name' can be an input or output
      Impl::keywordArgumentEdge(this, name, result)
    }

    /**
     * Gets the `n`th positional parameter of this callable, or the `n`th  positional argument to this call.
     *
     * Note: for historical reasons, this predicate may refer to an argument of a call, but this may change in the future.
     * When referring to an argument, it is recommended to use `getArgument(n)` instead.
     */
    pragma[inline]
    Node getParameter(int n) {
      // This predicate is currently not 'inline_late' because 'n' can be an input or output
      Impl::positionalParameterOrArgumentEdge(this.getAnEpsilonSuccessor(), n, result)
    }

    /**
     * Gets the given keyword parameter of this callable, or keyword argument to this call.
     *
     * Note: for historical reasons, this predicate may refer to an argument of a call, but this may change in the future.
     * When referring to an argument, it is recommended to use `getKeywordArgument(n)` instead.
     */
    pragma[inline]
    Node getKeywordParameter(string name) {
      // This predicate is currently not 'inline_late' because 'name' can be an input or output
      Impl::keywordParameterOrArgumentEdge(this.getAnEpsilonSuccessor(), name, result)
    }

    /**
     * Gets the argument passed in argument position `pos` at this call.
     */
    pragma[inline]
    Node getArgumentAtPosition(DataFlowDispatch::ArgumentPosition pos) {
      // This predicate is currently not 'inline_late' because 'pos' can be an input or output
      Impl::argumentEdge(pragma[only_bind_out](this), pos, result) // note: no need for epsilon step since 'this' must be a call
    }

    /**
     * Gets the parameter at position `pos` of this callable.
     */
    pragma[inline]
    Node getParameterAtPosition(DataFlowDispatch::ParameterPosition pos) {
      // This predicate is currently not 'inline_late' because 'pos' can be an input or output
      Impl::parameterEdge(this.getAnEpsilonSuccessor(), pos, result)
    }

    /**
     * Gets a representative for the `content` of this value.
     *
     * When possible, it is preferrable to use one of the specialized variants of this predicate, such as `getAnElement`.
     *
     * Concretely, this gets sources where `content` is read from this value, and as well as sinks where
     * `content` is stored onto this value or onto an object that can reach this sink.
     */
    pragma[inline]
    Node getContent(DataFlow::Content content) {
      // This predicate is currently not 'inline_late' because 'content' can be an input or output
      Impl::contentEdge(this.getAnEpsilonSuccessor(), content, result)
    }

    /**
     * Gets a representative for the `contents` of this value.
     *
     * See `getContent()` for more details.
     */
    bindingset[this, contents]
    pragma[inline_late]
    Node getContents(DataFlow::ContentSet contents) {
      // We always use getAStoreContent when generating content edges, and we always use getAReadContent when querying the graph.
      result = this.getContent(contents.getAReadContent())
    }

    /**
     * Gets a representative for the instance field of the given `name`.
     */
    pragma[inline]
    Node getField(string name) {
      // This predicate is currently not 'inline_late' because 'name' can be an input or output
      Impl::fieldEdge(this.getAnEpsilonSuccessor(), name, result)
    }

    /**
     * Gets a representative for an arbitrary element of this collection.
     */
    bindingset[this]
    pragma[inline_late]
    Node getAnElement() { Impl::elementEdge(this.getAnEpsilonSuccessor(), result) }

    /**
     * Gets the data-flow node that gives rise to this node, if any.
     */
    DataFlow::Node getInducingNode() {
      this = Impl::MkMethodAccessNode(result) or
      this = Impl::MkBackwardNode(result, _) or
      this = Impl::MkForwardNode(result, _) or
      this = Impl::MkSinkNode(result) or
      this = Impl::MkNamespaceOfTypeNameNode(result)
    }

    /** Gets the location of this node. */
    Location getLocation() {
      result = this.getInducingNode().getLocation()
      or
      this instanceof RootNode and
      result instanceof EmptyLocation
    }

    /**
     * Gets a textual representation of this element.
     */
    string toString() { none() }

    pragma[inline]
    private Node getAnEpsilonSuccessor() { result = getAnEpsilonSuccessorInline(this) }
  }

  /** The root node of an API graph. */
  private class RootNode extends Node, Impl::MkRoot {
    override string toString() { result = "Root()" }
  }

  /** A node representing a given type-tracking state when tracking forwards. */
  private class ForwardNode extends Node, Impl::MkForwardNode {
    private DataFlow::LocalSourceNode node;
    private TypeTracker tracker;

    ForwardNode() { this = Impl::MkForwardNode(node, tracker) }

    override string toString() {
      if tracker.start()
      then result = "ForwardNode(" + node + ")"
      else result = "ForwardNode(" + node + ", " + tracker + ")"
    }
  }

  /** A node representing a given type-tracking state when tracking backwards. */
  private class BackwardNode extends Node, Impl::MkBackwardNode {
    private DataFlow::LocalSourceNode node;
    private TypeTracker tracker;

    BackwardNode() { this = Impl::MkBackwardNode(node, tracker) }

    override string toString() {
      if tracker.start()
      then result = "BackwardNode(" + node + ")"
      else result = "BackwardNode(" + node + ", " + tracker + ")"
    }
  }

  /** A node corresponding to the method being invoked at a method call. */
  class MethodAccessNode extends Node, Impl::MkMethodAccessNode {
    override string toString() { result = "MethodAccessNode(" + this.asCall() + ")" }
  }

  /**
   * A node corresponding to an argument, right-hand side of a store, or return value from a callable.
   *
   * Such a node may serve as the starting-point of backtracking, and has epsilon edges going to
   * the backward nodes corresponding to `getALocalSource`.
   */
  private class SinkNode extends Node, Impl::MkSinkNode {
    override string toString() { result = "SinkNode(" + this.getInducingNode() + ")" }
  }

  private class UsingNode extends Node, Impl::MkUsingNode {
    UsingStmt using; // TODO: This should really be the cfg node, I think

    UsingNode() { this = Impl::MkUsingNode(using) }

    override string toString() { result = "UsingNode(" + using + ")" }
  }

  private class NamespaceOfTypeNameNode extends Node, Impl::MkNamespaceOfTypeNameNode {
    DataFlow::QualifiedTypeNameNode typeName;

    NamespaceOfTypeNameNode() { this = Impl::MkNamespaceOfTypeNameNode(typeName) }

    override string toString() { result = "NamespaceOfTypeNameNode(" + typeName + ")" }
  }

  /**
   * An API entry point.
   *
   * By default, API graph nodes are only created for nodes that come from an external
   * library or escape into an external library. The points where values are cross the boundary
   * between codebases are called "entry points".
   *
   * Anything in the global scope is considered to be an entry point, but
   * additional entry points may be added by extending this class.
   */
  abstract class EntryPoint extends string {
    // Note: this class can be deprecated in Ruby, but is still referenced by shared code in ApiGraphModels.qll,
    // where it can't be removed since other languages are still dependent on the EntryPoint class.
    bindingset[this]
    EntryPoint() { any() }

    /** Gets a data-flow node corresponding to a use-node for this entry point. */
    DataFlow::LocalSourceNode getASource() { none() }

    /** Gets a data-flow node corresponding to a def-node for this entry point. */
    DataFlow::Node getASink() { none() }

    /** Gets a call corresponding to a method access node for this entry point. */
    DataFlow::CallNode getACall() { none() }

    /** Gets an API-node for this entry point. */
    API::Node getANode() { Impl::entryPointEdge(this, result) }
  }

  // Ensure all entry points are imported from ApiGraphs.qll
  private module ImportEntryPoints {
    private import semmle.code.powershell.frameworks.data.ModelsAsData
  }

  /** Gets the root node. */
  Node root() { result instanceof RootNode }

  bindingset[name]
  pragma[inline_late]
  Node namespace(string name) {
    // This predicate is currently not 'inline_late' because 'n' can be an input or output
    Impl::namespace(name, result)
  }

  pragma[inline]
  Node getTopLevelMember(string name) { Impl::topLevelMember(name, result) }

  /**
   * Gets an unqualified call at the top-level with the given method name.
   */
  pragma[inline]
  MethodAccessNode getTopLevelCall(string name) { Impl::toplevelCall(name, result) }

  pragma[nomagic]
  private predicate isReachable(DataFlow::LocalSourceNode node, TypeTracker t) {
    t.start() and exists(node)
    or
    exists(DataFlow::LocalSourceNode prev, TypeTracker t2 |
      isReachable(prev, t2) and
      node = prev.track(t2, t)
    )
  }

  private module SharedArg implements ApiGraphSharedSig {
    class ApiNode = Node;

    ApiNode getForwardNode(DataFlow::LocalSourceNode node, TypeTracker t) {
      result = Impl::MkForwardNode(node, t)
    }

    ApiNode getBackwardNode(DataFlow::LocalSourceNode node, TypeTracker t) {
      result = Impl::MkBackwardNode(node, t)
    }

    ApiNode getSinkNode(DataFlow::Node node) { result = Impl::MkSinkNode(node) }

    pragma[nomagic]
    predicate specificEpsilonEdge(ApiNode pred, ApiNode succ) { none() }
  }

  /** INTERNAL USE ONLY. */
  module Internal {
    private module MkShared = ApiGraphShared<SharedArg>;

    import MkShared
  }

  private import Internal
  import Internal::Public

  cached
  private module Impl {
    cached
    newtype TApiNode =
      /** The root of the API graph. */
      MkRoot() or
      /** The method accessed at `call`, synthetically treated as a separate object. */
      MkMethodAccessNode(DataFlow::CallNode call) or
      MkUsingNode(UsingStmt using) or
      MkNamespaceOfTypeNameNode(DataFlow::QualifiedTypeNameNode typeName) or
      MkForwardNode(DataFlow::LocalSourceNode node, TypeTracker t) { isReachable(node, t) } or
      /** Intermediate node for following backward data flow. */
      MkBackwardNode(DataFlow::LocalSourceNode node, TypeTracker t) { isReachable(node, t) } or
      MkSinkNode(DataFlow::Node node) { needsSinkNode(node) }

    private predicate needsSinkNode(DataFlow::Node node) {
      node instanceof DataFlowPrivate::ArgumentNode
      or
      TypeTrackingInput::storeStep(node, _, _)
      or
      node = any(DataFlow::CallableNode callable).getAReturnNode()
      or
      node = any(EntryPoint e).getASink()
    }

    bindingset[e]
    pragma[inline_late]
    private DataFlow::Node getNodeFromExpr(Expr e) { result.asExpr().getExpr() = e }

    private import frameworks.data.ModelsAsData

    cached
    predicate namespace(string name, Node node) {
      exists(DataFlow::QualifiedTypeNameNode typeName |
        typeName.getNamespace() = name and
        node = MkNamespaceOfTypeNameNode(typeName)
      )
      or
      exists(UsingStmt using |
        using.getName().toLowerCase() = name and
        node = MkUsingNode(using)
      )
      or
      node = ModelOutput::getATypeNode(name)
    }

    cached
    predicate topLevelMember(string name, Node node) { memberEdge(root(), name, node) }

    cached
    predicate toplevelCall(string name, Node node) {
      exists(DataFlow::CallNode call |
        call.asExpr().getExpr().getEnclosingScope() instanceof TopLevelScriptBlock and
        call.getName() = name and
        node = MkMethodAccessNode(call)
      )
    }

    cached
    predicate callEdge(Node pred, string name, Node succ) {
      exists(DataFlow::CallNode call |
        // from receiver to method call node
        pred = getForwardEndNode(getALocalSourceStrict(call.getQualifier())) and
        succ = MkMethodAccessNode(call) and
        name = call.getName()
      )
    }

    bindingset[name]
    private string memberOrMethodReturnValue(string name) {
      // This predicate is a bit ad-hoc, but it's okay for now.
      // We can delete it once we no longer use the typeModel and summaryModel
      // tables to represent implicit root members.
      result = "Method[" + name + "]"
      or
      result = "Method[" + name + "].ReturnValue"
      or
      result = "Member[" + name + "]"
    }

    private Node getAnImplicitRootMember(string name) {
      exists(DataFlow::CallNode call |
        Extensions::typeModel(_, Specific::getAnImplicitImport(), memberOrMethodReturnValue(name))
        or
        Extensions::summaryModel(Specific::getAnImplicitImport(), memberOrMethodReturnValue(name),
          _, _, _, _)
        or
        Extensions::sourceModel(Specific::getAnImplicitImport(), memberOrMethodReturnValue(name), _,
          _)
      |
        result = MkMethodAccessNode(call) and
        name = call.getName().toLowerCase()
      )
    }

    cached
    predicate memberEdge(Node pred, string name, Node succ) {
      pred = API::root() and
      (
        exists(StringConstExpr read |
          succ = getForwardStartNode(getNodeFromExpr(read)) and
          name = read.getValueString()
        )
        or
        exists(DataFlow::AutomaticVariableNode automatic |
          automatic.getName() = name and
          succ = getForwardStartNode(automatic)
        )
        or
        succ = getAnImplicitRootMember(name)
      )
      or
      exists(DataFlow::QualifiedTypeNameNode typeName |
        typeName.getName() = name and
        pred = MkNamespaceOfTypeNameNode(typeName) and
        succ = getForwardStartNode(typeName)
      )
      or
      exists(MemberExprReadAccess read |
        read.getMemberName().toLowerCase() = name and
        pred = getForwardEndNode(getALocalSourceStrict(getNodeFromExpr(read.getQualifier()))) and
        succ = getForwardStartNode(getNodeFromExpr(read))
      )
    }

    cached
    predicate methodEdge(Node pred, string name, Node succ) {
      exists(DataFlow::CallNode call |
        succ = MkMethodAccessNode(call) and name = call.getName().toLowerCase()
      |
        pred = getForwardEndNode(getALocalSourceStrict(call.getQualifier()))
      )
      or
      pred = API::root() and
      succ = getAnImplicitRootMember(name)
    }

    cached
    predicate asCallable(Node apiNode, DataFlow::CallableNode callable) {
      apiNode = getBackwardStartNode(callable)
    }

    cached
    predicate contentEdge(Node pred, DataFlow::Content content, Node succ) {
      exists(DataFlow::Node object, DataFlow::Node value, DataFlow::ContentSet c |
        TypeTrackingInput::loadStep(object, value, c) and
        content = c.getAStoreContent() and
        // `x -> x.foo` with content "foo"
        pred = getForwardOrBackwardEndNode(getALocalSourceStrict(object)) and
        succ = getForwardStartNode(value)
        or
        // Based on `object.c = value` generate `object -> value` with content `c`
        TypeTrackingInput::storeStep(value, object, c) and
        content = c.getAStoreContent() and
        pred = getForwardOrBackwardEndNode(getALocalSourceStrict(object)) and
        succ = MkSinkNode(value)
      )
    }

    cached
    predicate fieldEdge(Node pred, string name, Node succ) {
      Impl::contentEdge(pred, DataFlowPrivate::TFieldContent(name), succ)
    }

    cached
    predicate elementEdge(Node pred, Node succ) {
      contentEdge(pred, any(DataFlow::ContentSet set | set.isAnyElement()).getAReadContent(), succ)
    }

    cached
    predicate parameterEdge(Node pred, DataFlowDispatch::ParameterPosition paramPos, Node succ) {
      exists(DataFlowPrivate::ParameterNodeImpl parameter, DataFlow::CallableNode callable |
        parameter.isSourceParameterOf(callable.asCallableAstNode(), paramPos) and
        pred = getBackwardEndNode(callable) and
        succ = getForwardStartNode(parameter)
      )
    }

    cached
    predicate argumentEdge(Node pred, DataFlowDispatch::ArgumentPosition argPos, Node succ) {
      exists(DataFlow::CallNode call, DataFlowPrivate::ArgumentNode argument |
        argument.sourceArgumentOf(call.asExpr(), argPos) and
        pred = MkMethodAccessNode(call) and
        succ = MkSinkNode(argument)
      )
    }

    cached
    predicate positionalArgumentEdge(Node pred, int n, Node succ) {
      argumentEdge(pred,
        any(DataFlowDispatch::ArgumentPosition pos |
          pos.isPositional(n, DataFlowPrivate::emptyNamedSet())
        ), succ)
    }

    cached
    predicate keywordArgumentEdge(Node pred, string name, Node succ) {
      argumentEdge(pred, any(DataFlowDispatch::ArgumentPosition pos | pos.isKeyword(name)), succ)
    }

    private predicate positionalParameterEdge(Node pred, int n, Node succ) {
      parameterEdge(pred,
        any(DataFlowDispatch::ParameterPosition pos |
          pos.isPositional(n, DataFlowPrivate::emptyNamedSet())
        ), succ)
    }

    private predicate keywordParameterEdge(Node pred, string name, Node succ) {
      parameterEdge(pred, any(DataFlowDispatch::ParameterPosition pos | pos.isKeyword(name)), succ)
    }

    cached
    predicate positionalParameterOrArgumentEdge(Node pred, int n, Node succ) {
      positionalArgumentEdge(pred, n, succ)
      or
      positionalParameterEdge(pred, n, succ)
    }

    cached
    predicate keywordParameterOrArgumentEdge(Node pred, string name, Node succ) {
      keywordArgumentEdge(pred, name, succ)
      or
      keywordParameterEdge(pred, name, succ)
    }

    cached
    predicate instanceEdge(Node pred, Node succ) {
      // TODO: Also model parameters with a given type here
      exists(DataFlow::ObjectCreationNode objCreation |
        pred = getForwardEndNode(objCreation.getConstructedTypeNode()) and
        succ = getForwardStartNode(objCreation)
      )
    }

    cached
    predicate returnEdge(Node pred, Node succ) {
      exists(DataFlow::CallNode call |
        pred = MkMethodAccessNode(call) and
        succ = getForwardStartNode(call)
      )
      or
      exists(DataFlow::CallableNode callable |
        pred = getBackwardEndNode(callable) and
        succ = MkSinkNode(callable.getAReturnNode())
      )
    }

    cached
    predicate returnEdgeWithArg(Node pred, string arg, Node succ) {
      exists(DataFlow::CallNode call |
        pred = MkMethodAccessNode(call) and
        exists(call.getNamedArgument(arg)) and
        succ = getForwardStartNode(call)
      )
      or
      arg = "" and // TODO
      exists(DataFlow::CallableNode callable |
        pred = getBackwardEndNode(callable) and
        succ = MkSinkNode(callable.getAReturnNode())
      )
    }

    cached
    predicate entryPointEdge(EntryPoint entry, Node node) {
      node = MkSinkNode(entry.getASink()) or
      node = getForwardStartNode(entry.getASource()) or
      node = MkMethodAccessNode(entry.getACall())
    }
  }
}
