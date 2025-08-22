/**
 * Provides an implementation of _API graphs_, which allow efficient modelling of how a given
 * value is used by the code base or how values produced by the code base are consumed by a library.
 *
 * See `API::Node` for more details.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.ApiGraphShared
private import codeql.ruby.typetracking.internal.TypeTrackingImpl
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.dataflow.internal.DataFlowDispatch as DataFlowDispatch

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
   * The following examples demonstrate how to identify the expression `x` in various basic cases:
   * ```rb
   * # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).asSink()
   * Foo.bar(x)
   *
   * # API::getTopLevelMember("Foo").getMethod("bar").getKeywordArgument("foo").asSink()
   * Foo.bar(foo: x)
   *
   * # API::getTopLevelMember("Foo").getInstance().getMethod("bar").getArgument(0).asSink()
   * Foo.new.bar(x)
   *
   * Foo.bar do |x| # API::getTopLevelMember("Foo").getMethod("bar").getBlock().getParameter(0).asSource()
   * end
   * ```
   *
   * ### Data flow
   *
   * The members predicates on this class generally take inheritance and data flow into account.
   *
   * The following example demonstrates a case where data flow was used to find the sink `x`:
   * ```ruby
   * def doSomething f
   *   f.bar(x) # API::getTopLevelMember("Foo").getInstance().getMethod("bar").getArgument(0).asSink()
   * end
   * doSomething Foo.new
   * ```
   * The call `API::getTopLevelMember("Foo").getInstance()` identifies the `Foo.new` call, and `getMethod("bar")`
   * then follows data flow from there to find calls to `bar` where that object flows to the receiver.
   * This results in the `f.bar` call.
   *
   * ### Backward data flow
   *
   * When inspecting the arguments of a call, the data flow direction is backwards.
   * The following example illustrates this when we match the `x` parameter of a block:
   * ```ruby
   * def doSomething &blk
   *   Foo.bar &blk
   * end
   * doSomething do |x| # API::getTopLevelMember("Foo").getMethod("bar").getBlock().getParameter(0).asSource()
   * end
   * ```
   * When `getParameter(0)` is evaluated, the API graph backtracks the `&blk` argument to the block argument a few
   * lines below. As a result, it eventually matches the `x` parameter of that block.
   *
   * ### Inheritance
   *
   * When a class or module object is tracked, inheritance is taken into account.
   *
   * In the following example, a call to `Foo.bar` was found via a subclass of `Foo`,
   * because classes inherit singleton methods from their base class:
   * ```ruby
   * class Subclass < Foo
   *   def self.doSomething
   *     bar(x) # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).asSink()
   *   end
   * end
   * ```
   *
   * Similarly, instance methods can be found in subclasses, or ancestors of subclases in cases of multiple inheritance:
   * ```rb
   * module Mixin
   *   def doSomething
   *     bar(x) # API::getTopLevelMember("Foo").getInstance().getMethod("bar").getArgument(0).asSink()
   *   end
   * end
   * class Subclass < Foo
   *   include Mixin
   * end
   * ```
   * The value of `self` in `Mixin#doSomething` is seen as a potential instance of `Foo`, and is thus found by `getTopLevelMember("Foo").getInstance()`.
   * This eventually results in finding the call `bar`, due to its implicit `self` receiver, and finally its argument `x` is found as the sink.
   *
   * ### Backward data flow and classes
   *
   * When inspecting the arguments of a call, and the value flowing into that argument is a user-defined class (or an instance thereof),
   * uses of `getMethod` will find method definitions in that class (including inherited ones) rather than finding method calls.
   *
   * This example illustrates how this can be used to model cases where the library calls a specific named method on a user-defined class:
   * ```rb
   * class MyClass
   *   def doSomething
   *     x # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).getMethod("doSomething").getReturn().asSink()
   *   end
   * end
   * Foo.bar MyClass.new
   * ```
   *
   * When modeling an external library that is known to call a specific method on a parameter (in this case `doSomething`), this makes
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
     *
     * For example:
     * ```ruby
     * # API::getTopLevelMember("Foo").asSource()
     * Foo
     *
     * # API::getTopLevelMember("Foo").getMethod("bar").getReturn().asSource()
     * Foo.bar
     *
     * # 'x' is found by:
     * # API::getTopLevelMember("Foo").getMethod("bar").getBlock().getParameter(0).asSource()
     * Foo.bar do |x|
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::LocalSourceNode asSource() { result = asSourceInline(this) }

    /**
     * Gets a data-flow node where this value potentially flows into an external library.
     *
     * This is usually the argument of a call, but can also be the return value of a callback.
     *
     * For example:
     * ```ruby
     * # 'x' is found by:
     * # API::getTopLevelMember("Foo").getMethod("bar").getParameter(0).asSink()
     * Foo.bar(x)
     *
     * Foo.bar(-> {
     *   # 'x' is found by:
     *   # API::getTopLevelMember("Foo").getMethod("bar").getParameter(0).getReturn().asSink()
     *   x
     * })
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::Node asSink() { result = asSinkInline(this) }

    /**
     * Gets a callable that can reach this sink.
     *
     * For example:
     * ```ruby
     * Foo.bar do |x| # API::getTopLevelMember("Foo").getMethod("bar").getBlock().asCallable()
     * end
     *
     * class Baz
     *   def m # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).getMethod("m").asCallable()
     *   end
     * end
     * Foo.bar(Baz.new)
     * ```
     */
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

    /**
     * Gets a module or class referred to by this API node.
     *
     * For example:
     * ```ruby
     * module Foo
     *   class Bar # API::getTopLevelMember("Foo").getMember("Bar").asModule()
     *   end
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::ModuleNode asModule() { this = Impl::MkModuleObjectDown(result) }

    /**
     * Gets the call referred to by this API node.
     *
     * For example:
     * ```ruby
     * # API::getTopLevelMember("Foo").getMethod("bar").asCall()
     * Foo.bar
     *
     * class Bar < Foo
     *   def doSomething
     *     # API::getTopLevelMember("Foo").getInstance().getMethod("baz").asCall()
     *     baz
     *   end
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::CallNode asCall() { this = Impl::MkMethodAccessNode(result) }

    /**
     * Gets a module or class that descends from the module or class referenced by this API node.
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::ModuleNode getADescendentModule() { result = this.getAnEpsilonSuccessor().asModule() }

    /**
     * Gets a call to a method on the receiver represented by this API node.
     *
     * This is a shorthand for `getMethod(method).asCall()`, and thus returns a data-flow node
     * rather than an API node.
     *
     * For example:
     * ```ruby
     * # API::getTopLevelMember("Foo").getAMethodCall("bar")
     * Foo.bar
     * ```
     */
    pragma[inline]
    DataFlow::CallNode getAMethodCall(string method) {
      // This predicate is currently not 'inline_late' because 'method' can be an input or output
      result = this.getMethod(method).asCall()
    }

    /**
     * Gets an access to the constant `m` with this value as the base of the access.
     *
     * For example:
     * ```ruby
     * A::B # API::getATopLevelMember("A").getMember("B")
     *
     * module A
     *   class B # API::getATopLevelMember("A").getMember("B")
     *   end
     * end
     * ```
     */
    pragma[inline]
    Node getMember(string m) {
      // This predicate is currently not 'inline_late' because 'm' can be an input or output
      Impl::memberEdge(this.getAnEpsilonSuccessor(), m, result)
    }

    /**
     * Gets an access to a constant with this value as the base of the access.
     *
     * This is equivalent to `getMember(_)` but can be more efficient.
     */
    bindingset[this]
    pragma[inline_late]
    Node getAMember() { Impl::anyMemberEdge(this.getAnEpsilonSuccessor(), result) }

    /**
     * Gets a node that may refer to an instance of the module or class represented by this API node.
     *
     * This includes the following:
     * - Calls to `new` on this module or class or a descendent thereof
     * - References to `self` in instance methods declared in any ancestor of any descendent of this module or class
     *
     * For example:
     * ```ruby
     * A.new # API::getTopLevelMember("A").getInstance()
     *
     * class B < A
     *   def m
     *     self # API::getTopLevelMember("A").getInstance()
     *   end
     * end
     *
     * B.new # API::getTopLevelMember("A").getInstance()
     *
     * class C < A
     *   include Mixin
     * end
     * module Mixin
     *   def m
     *     # Although 'Mixin' is not directly related to 'A', 'self' may refer to an instance of 'A'
     *     # due to its inclusion in a subclass of 'A'.
     *     self # API::getTopLevelMember("A").getInstance()
     *   end
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    Node getInstance() { Impl::instanceEdge(this.getAnEpsilonSuccessor(), result) }

    /**
     * Gets a call to `method` with this value as the receiver, or the definition of `method` on
     * an object that can reach this sink.
     *
     * If the receiver represents a module or class object, this includes calls on descendents of that module or class.
     *
     * For example:
     * ```ruby
     * # API::getTopLevelMember("Foo").getMethod("bar")
     * Foo.bar
     *
     * # API::getTopLevelMember("Foo").getInstance().getMethod("bar")
     * Foo.new.bar
     *
     * class B < Foo
     * end
     * B.bar # API::getTopLevelMember("Foo").getMethod("bar")
     *
     * class C
     *   def m # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).getMethod("m")
     *   end
     * end
     * Foo.bar(C.new)
     * ```
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
     *
     * For example, this would get `x` in the following snippet:
     * ```ruby
     * Foo.bar(x) # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0)
     * ```
     */
    pragma[inline]
    Node getArgument(int n) {
      // This predicate is currently not 'inline_late' because 'n' can be an input or output
      Impl::positionalArgumentEdge(this, n, result)
    }

    /**
     * Gets the given keyword argument to this call.
     *
     * For example, this would get `x` in the following snippet:
     * ```ruby
     * Foo.bar(baz: x) # API::getTopLevelMember("Foo").getMethod("bar").getKeywordArgument("baz")
     * ```
     */
    pragma[inline]
    Node getKeywordArgument(string name) {
      // This predicate is currently not 'inline_late' because 'name' can be an input or output
      Impl::keywordArgumentEdge(this, name, result)
    }

    /**
     * Gets the block parameter of a callable that can reach this sink.
     *
     * For example, this would get the `&blk` in the following snippet:
     * ```ruby
     * # API::getTopLevelMember("Foo").getMethod("bar").getArgument(0).getBlockParameter()
     * Foo.bar(->(&blk) {})
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    Node getBlockParameter() { Impl::blockParameterEdge(this.getAnEpsilonSuccessor(), result) }

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
     * Gets the block argument to this call, or the block parameter of this callable.
     *
     * Note: this predicate may refer to either an argument or a parameter. When referring to a block parameter,
     * it is recommended to use `getBlockParameter()` instead.
     *
     * For example:
     * ```ruby
     * Foo.bar do |x| # API::getTopLevelMember("Foo").getMethod("bar").getBlock().getParameter(0)
     * end
     * ```
     */
    bindingset[this]
    pragma[inline_late]
    Node getBlock() { Impl::blockParameterOrArgumentEdge(this.getAnEpsilonSuccessor(), result) }

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
     * Gets a `new` call with this value as the receiver.
     */
    bindingset[this]
    pragma[inline_late]
    DataFlow::ExprNode getAnInstantiation() { result = this.getReturn("new").asSource() }

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
     * Gets a representative for the instance field of the given `name`, which must include the `@` character.
     *
     * This can be used to find cases where a class accesses the fields used by a base class.
     *
     * ```ruby
     * class A < B
     *   def m
     *     @foo # API::getTopLevelMember("B").getInstance().getField("@foo")
     *   end
     * end
     * ```
     */
    pragma[inline]
    Node getField(string name) {
      // This predicate is currently not 'inline_late' because 'name' can be an input or output
      Impl::fieldEdge(this.getAnEpsilonSuccessor(), name, result)
    }

    /**
     * Gets a representative for an arbitrary element of this collection.
     *
     * For example:
     * ```ruby
     * Foo.bar.each do |x| # API::getTopLevelMember("Foo").getMethod("bar").getReturn().getAnElement()
     * end
     *
     * Foo.bar[0] # API::getTopLevelMember("Foo").getMethod("bar").getReturn().getAnElement()
     * ```
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
      this = Impl::MkSinkNode(result)
    }

    /** Gets the location of this node. */
    Location getLocation() {
      result = this.getInducingNode().getLocation()
      or
      exists(DataFlow::ModuleNode mod |
        this = Impl::MkModuleObjectDown(mod)
        or
        this = Impl::MkModuleInstanceUp(mod)
      |
        result = mod.getLocation()
      )
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

  /** A node representing a module/class object with epsilon edges to its descendents. */
  private class ModuleObjectDownNode extends Node, Impl::MkModuleObjectDown {
    /** Gets the module represented by this API node. */
    DataFlow::ModuleNode getModule() { this = Impl::MkModuleObjectDown(result) }

    override string toString() { result = "ModuleObjectDown(" + this.getModule() + ")" }
  }

  /** A node representing a module/class object with epsilon edges to its ancestors. */
  private class ModuleObjectUpNode extends Node, Impl::MkModuleObjectUp {
    /** Gets the module represented by this API node. */
    DataFlow::ModuleNode getModule() { this = Impl::MkModuleObjectUp(result) }

    override string toString() { result = "ModuleObjectUp(" + this.getModule() + ")" }
  }

  /** A node representing instances of a module/class with epsilon edges to its ancestors. */
  private class ModuleInstanceUpNode extends Node, Impl::MkModuleInstanceUp {
    /** Gets the module whose instances are represented by this API node. */
    DataFlow::ModuleNode getModule() { this = Impl::MkModuleInstanceUp(result) }

    override string toString() { result = "ModuleInstanceUp(" + this.getModule() + ")" }
  }

  /** A node representing instances of a module/class with epsilon edges to its descendents. */
  private class ModuleInstanceDownNode extends Node, Impl::MkModuleInstanceDown {
    /** Gets the module whose instances are represented by this API node. */
    DataFlow::ModuleNode getModule() { this = Impl::MkModuleInstanceDown(result) }

    override string toString() { result = "ModuleInstanceDown(" + this.getModule() + ")" }
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
    private import codeql.ruby.frameworks.data.ModelsAsData
  }

  /** Gets the root node. */
  Node root() { result instanceof RootNode }

  /**
   * Gets an access to the top-level constant `name`.
   *
   * To access nested constants, use `getMember()` on the resulting node. For example, for nodes corresponding to the class `Gem::Version`,
   * use `getTopLevelMember("Gem").getMember("Version")`.
   */
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
      node = prev.track(t2, t) and
      notSelfParameter(node)
    )
  }

  bindingset[node]
  pragma[inline_late]
  private predicate notSelfParameter(DataFlow::Node node) {
    not node instanceof DataFlow::SelfParameterNode
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
    predicate specificEpsilonEdge(ApiNode pred, ApiNode succ) {
      exists(DataFlow::ModuleNode mod |
        moduleReferenceEdge(mod, pred, succ)
        or
        moduleInheritanceEdge(mod, pred, succ)
        or
        pred = getForwardEndNode(getSuperClassNode(mod)) and
        succ = Impl::MkModuleObjectDown(mod)
      )
      or
      implicitCallEdge(pred, succ)
    }

    /**
     * Holds if the epsilon edge `pred -> succ` should be generated, to handle inheritance relations of `mod`.
     */
    pragma[inline]
    private predicate moduleInheritanceEdge(DataFlow::ModuleNode mod, ApiNode pred, ApiNode succ) {
      pred = Impl::MkModuleObjectDown(mod) and
      succ = Impl::MkModuleObjectDown(mod.getAnImmediateDescendent())
      or
      pred = Impl::MkModuleInstanceDown(mod) and
      succ = Impl::MkModuleInstanceDown(mod.getAnImmediateDescendent())
      or
      exists(DataFlow::ModuleNode ancestor |
        ancestor = mod.getAnImmediateAncestor() and
        // Restrict flow back to Object to avoid spurious flow for methods that happen
        // to exist on Object, such as top-level methods.
        not ancestor.getQualifiedName() = "Object"
      |
        pred = Impl::MkModuleInstanceUp(mod) and
        succ = Impl::MkModuleInstanceUp(ancestor)
        or
        pred = Impl::MkModuleObjectUp(mod) and
        succ = Impl::MkModuleObjectUp(ancestor)
      )
      or
      // Due to multiple inheritance, allow upwards traversal after downward traversal,
      // so we can detect calls sideways in the hierarchy.
      // Note that a similar case does not exist for ModuleObject since singleton methods are only inherited
      // from the superclass, and there can only be one superclass.
      pred = Impl::MkModuleInstanceDown(mod) and
      succ = Impl::MkModuleInstanceUp(mod)
    }

    /**
     * Holds if the epsilon `pred -> succ` should be generated, to associate `mod` with its references in the codebase.
     */
    bindingset[mod]
    pragma[inline_late]
    private predicate moduleReferenceEdge(DataFlow::ModuleNode mod, ApiNode pred, ApiNode succ) {
      pred = Impl::MkModuleObjectDown(mod) and
      succ = getForwardStartNode(getAModuleReference(mod))
      or
      pred = getBackwardEndNode(getAModuleReference(mod)) and
      (
        succ = Impl::MkModuleObjectUp(mod)
        or
        succ = Impl::MkModuleObjectDown(mod)
      )
      or
      pred = Impl::MkModuleInstanceUp(mod) and
      succ = getAModuleInstanceUseNode(mod)
      or
      pred = getAModuleInstanceDefNode(mod) and
      succ = Impl::MkModuleInstanceUp(mod)
      or
      pred = getAModuleDescendentInstanceDefNode(mod) and
      succ = Impl::MkModuleInstanceDown(mod)
    }

    /**
     * Holds if the epsilon step `pred -> succ` should be generated to account for the fact that `getMethod("call")`
     * may be omitted when dealing with blocks, lambda, or procs.
     *
     * For example, a block may be invoked by a `yield`, or can be converted to a proc and then invoked via `.call`.
     * To simplify this, the implicit proc conversion is seen as a no-op and the `.call` is omitted.
     */
    pragma[nomagic]
    private predicate implicitCallEdge(ApiNode pred, ApiNode succ) {
      // Step from &block parameter to yield call without needing `getMethod("call")`.
      exists(DataFlow::MethodNode method |
        pred = getForwardEndNode(method.getBlockParameter()) and
        succ = Impl::MkMethodAccessNode(method.getABlockCall())
      )
      or
      // Step from x -> x.call (the call itself, not its return value), without needing `getMethod("call")`.
      exists(DataFlow::CallNode call |
        call.getMethodName() = "call" and
        pred = getForwardEndNode(getALocalSourceStrict(call.getReceiver())) and
        succ = Impl::MkMethodAccessNode(call)
      )
      or
      exists(DataFlow::ModuleNode mod |
        // Step from module/class to its own `call` method without needing `getMethod("call")`.
        (pred = Impl::MkModuleObjectDown(mod) or pred = Impl::MkModuleObjectUp(mod)) and
        succ = getBackwardEndNode(mod.getOwnSingletonMethod("call"))
        or
        pred = Impl::MkModuleInstanceUp(mod) and
        succ = getBackwardEndNode(mod.getOwnInstanceMethod("call"))
      )
      or
      // Step through callable wrappers like `proc` and `lambda` calls.
      exists(DataFlow::Node node |
        pred = getBackwardEndNode(node) and
        succ = getBackwardStartNode(node.asCallable())
      )
    }

    pragma[nomagic]
    private DataFlow::LocalSourceNode getAModuleReference(DataFlow::ModuleNode mod) {
      result = mod.getAnImmediateReference()
      or
      mod.getAnAncestor().getAnOwnInstanceSelf() = getANodeReachingClassCall(result)
    }

    /**
     * Gets an API node that may refer to an instance of `mod`.
     */
    bindingset[mod]
    pragma[inline_late]
    private ApiNode getAModuleInstanceUseNode(DataFlow::ModuleNode mod) {
      result = getForwardStartNode(mod.getAnOwnInstanceSelf())
    }

    /**
     * Gets a node that can be backtracked to an instance of `mod`.
     */
    bindingset[mod]
    pragma[inline_late]
    private ApiNode getAModuleInstanceDefNode(DataFlow::ModuleNode mod) {
      result = getBackwardEndNode(mod.getAnImmediateReference().getAMethodCall("new"))
    }

    /**
     * Gets a node that can be backtracked to an instance of `mod` or any of its descendents.
     */
    bindingset[mod]
    pragma[inline_late]
    private ApiNode getAModuleDescendentInstanceDefNode(DataFlow::ModuleNode mod) {
      result = getBackwardEndNode(mod.getAnOwnInstanceSelf())
    }

    /**
     * Holds if `superclass` is the superclass of `mod`.
     */
    pragma[nomagic]
    private DataFlow::LocalSourceNode getSuperClassNode(DataFlow::ModuleNode mod) {
      result.getALocalUse().asExpr().getExpr() =
        mod.getADeclaration().(ClassDeclaration).getSuperclassExpr()
    }

    /** Gets a node that can reach the receiver of the given `.class` call. */
    private DataFlow::LocalSourceNode getANodeReachingClassCall(
      DataFlow::CallNode call, TypeBackTracker t
    ) {
      t.start() and
      call.getMethodName() = "class" and
      result = getALocalSourceStrict(call.getReceiver())
      or
      exists(DataFlow::LocalSourceNode prev, TypeBackTracker t2 |
        prev = getANodeReachingClassCall(call, t2) and
        result = prev.backtrack(t2, t) and
        notSelfParameter(prev)
      )
    }

    /** Gets a node that can reach the receiver of the given `.class` call. */
    private DataFlow::LocalSourceNode getANodeReachingClassCall(DataFlow::CallNode call) {
      result = getANodeReachingClassCall(call, TypeBackTracker::end())
    }
  }

  /** INTERNAL USE ONLY. */
  module Internal {
    private module MkShared = ApiGraphShared<SharedArg>;

    import MkShared

    /** Gets the API node corresponding to the module/class object for `mod`. */
    bindingset[mod]
    pragma[inline_late]
    Node getModuleNode(DataFlow::ModuleNode mod) { result = Impl::MkModuleObjectDown(mod) }

    /** Gets the API node corresponding to instances of `mod`. */
    bindingset[mod]
    pragma[inline_late]
    Node getModuleInstance(DataFlow::ModuleNode mod) { result = getModuleNode(mod).getInstance() }
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
      /** The module object `mod` with epsilon edges to its ancestors. */
      MkModuleObjectUp(DataFlow::ModuleNode mod) { not mod.getQualifiedName() = "Object" } or
      /** The module object `mod` with epsilon edges to its descendents. */
      MkModuleObjectDown(DataFlow::ModuleNode mod) { not mod.getQualifiedName() = "Object" } or
      /** Instances of `mod` with epsilon edges to its ancestors. */
      MkModuleInstanceUp(DataFlow::ModuleNode mod) { not mod.getQualifiedName() = "Object" } or
      /** Instances of `mod` with epsilon edges to its descendents, and to its upward node. */
      MkModuleInstanceDown(DataFlow::ModuleNode mod) { not mod.getQualifiedName() = "Object" } or
      /** Intermediate node for following forward data flow. */
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

    private string resolveTopLevel(ConstantReadAccess read) {
      result = read.getModule().getQualifiedName() and
      not result.matches("%::%")
    }

    /**
     * Holds `pred` should have a member edge to `mod`.
     */
    pragma[nomagic]
    private predicate moduleScope(DataFlow::ModuleNode mod, Node pred, string name) {
      exists(Namespace namespace |
        name = namespace.getName() and
        namespace = mod.getADeclaration()
      |
        exists(DataFlow::Node scopeNode |
          scopeNode.asExpr().getExpr() = namespace.getScopeExpr() and
          pred = getForwardEndNode(getALocalSourceStrict(scopeNode))
        )
        or
        not exists(namespace.getScopeExpr()) and
        if namespace.hasGlobalScope() or namespace.getEnclosingModule() instanceof Toplevel
        then pred = MkRoot()
        else pred = MkModuleObjectDown(namespace.getEnclosingModule().getModule())
      )
    }

    cached
    predicate memberEdge(Node pred, string name, Node succ) {
      exists(ConstantReadAccess read | succ = getForwardStartNode(getNodeFromExpr(read)) |
        name = resolveTopLevel(read) and
        pred = MkRoot()
        or
        not exists(resolveTopLevel(read)) and
        not exists(read.getScopeExpr()) and
        name = read.getName() and
        pred = MkRoot()
        or
        pred = getForwardEndNode(getALocalSourceStrict(getNodeFromExpr(read.getScopeExpr()))) and
        name = read.getName()
      )
      or
      exists(DataFlow::ModuleNode mod |
        moduleScope(mod, pred, name) and
        (succ = MkModuleObjectDown(mod) or succ = MkModuleObjectUp(mod))
      )
    }

    cached
    predicate topLevelMember(string name, Node node) { memberEdge(root(), name, node) }

    cached
    predicate toplevelCall(string name, Node node) {
      exists(DataFlow::CallNode call |
        call.asExpr().getExpr().getCfgScope() instanceof Toplevel and
        call.getMethodName() = name and
        node = MkMethodAccessNode(call)
      )
    }

    cached
    predicate anyMemberEdge(Node pred, Node succ) { memberEdge(pred, _, succ) }

    cached
    predicate methodEdge(Node pred, string name, Node succ) {
      exists(DataFlow::ModuleNode mod, DataFlow::CallNode call |
        // Treat super calls as if they were calls to the module object/instance.
        succ = MkMethodAccessNode(call) and
        name = call.getMethodName()
      |
        pred = MkModuleObjectDown(mod) and
        call = mod.getAnOwnSingletonMethod().getASuperCall()
        or
        pred = MkModuleInstanceUp(mod) and
        call = mod.getAnOwnInstanceMethod().getASuperCall()
      )
      or
      exists(DataFlow::CallNode call |
        // from receiver to method call node
        pred = getForwardEndNode(getALocalSourceStrict(call.getReceiver())) and
        succ = MkMethodAccessNode(call) and
        name = call.getMethodName()
      )
      or
      exists(DataFlow::ModuleNode mod |
        (pred = MkModuleObjectDown(mod) or pred = MkModuleObjectUp(mod)) and
        succ = getBackwardStartNode(mod.getOwnSingletonMethod(name))
        or
        pred = MkModuleInstanceUp(mod) and
        succ = getBackwardStartNode(mod.getOwnInstanceMethod(name))
      )
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
        not c.isSingleton(any(DataFlow::Content::AttributeNameContent k)) and
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
        parameter.isSourceParameterOf(callable.asExpr().getExpr(), paramPos) and
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
      argumentEdge(pred, any(DataFlowDispatch::ArgumentPosition pos | pos.isPositional(n)), succ)
    }

    cached
    predicate keywordArgumentEdge(Node pred, string name, Node succ) {
      argumentEdge(pred, any(DataFlowDispatch::ArgumentPosition pos | pos.isKeyword(name)), succ)
    }

    private predicate blockArgumentEdge(Node pred, Node succ) {
      argumentEdge(pred, any(DataFlowDispatch::ArgumentPosition pos | pos.isBlock()), succ)
    }

    private predicate positionalParameterEdge(Node pred, int n, Node succ) {
      parameterEdge(pred, any(DataFlowDispatch::ParameterPosition pos | pos.isPositional(n)), succ)
    }

    private predicate keywordParameterEdge(Node pred, string name, Node succ) {
      parameterEdge(pred, any(DataFlowDispatch::ParameterPosition pos | pos.isKeyword(name)), succ)
    }

    cached
    predicate blockParameterEdge(Node pred, Node succ) {
      parameterEdge(pred, any(DataFlowDispatch::ParameterPosition pos | pos.isBlock()), succ)
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
    predicate blockParameterOrArgumentEdge(Node pred, Node succ) {
      blockArgumentEdge(pred, succ)
      or
      blockParameterEdge(pred, succ)
    }

    pragma[nomagic]
    private predicate newCall(DataFlow::LocalSourceNode receiver, DataFlow::CallNode call) {
      call = receiver.getAMethodCall("new")
    }

    cached
    predicate instanceEdge(Node pred, Node succ) {
      exists(DataFlow::ModuleNode mod |
        pred = MkModuleObjectDown(mod) and
        succ = MkModuleInstanceUp(mod)
      )
      or
      exists(DataFlow::LocalSourceNode receiver, DataFlow::CallNode call |
        newCall(receiver, call) and
        pred = getForwardEndNode(receiver) and
        succ = getForwardStartNode(call)
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
    predicate entryPointEdge(EntryPoint entry, Node node) {
      node = MkSinkNode(entry.getASink()) or
      node = getForwardStartNode(entry.getASource()) or
      node = MkMethodAccessNode(entry.getACall())
    }
  }
}
