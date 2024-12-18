/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * See `API::Node` for more in-depth documentation.
 */

import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
private import semmle.javascript.dataflow.internal.PreCallGraphStep
private import internal.CachedStages

/**
 * Provides classes and predicates for working with the API boundary between the current
 * codebase and external libraries.
 *
 * See `API::Node` for more in-depth documentation.
 */
module API {
  /**
   * A node in the API graph, representing a value that has crossed the boundary between this
   * codebase and an external library (or in general, any external codebase).
   *
   * ### Basic usage
   *
   * API graphs are typically used to identify "API calls", that is, calls to an external function
   * whose implementation is not necessarily part of the current codebase.
   *
   * The most basic use of API graphs is typically as follows:
   * 1. Start with `API::moduleImport` for the relevant library.
   * 2. Follow up with a chain of accessors such as `getMember` describing how to get to the relevant API function.
   * 3. Map the resulting API graph nodes to data-flow nodes, using `asSource` or `asSink`.
   *
   * For example, a simplified way to get arguments to `underscore.extend` would be
   * ```ql
   * API::moduleImport("underscore").getMember("extend").getParameter(0).asSink()
   * ```
   *
   * The most commonly used accessors are `getMember`, `getParameter`, and `getReturn`.
   *
   * ### API graph nodes
   *
   * There are two kinds of nodes in the API graphs, distinguished by who is "holding" the value:
   * - **Use-nodes** represent values held by the current codebase, which came from an external library.
   *   (The current codebase is "using" a value that came from the library).
   * - **Def-nodes** represent values held by the external library, which came from this codebase.
   *   (The current codebase "defines" the value seen by the library).
   *
   * API graph nodes are associated with data-flow nodes in the current codebase.
   * (Since external libraries are not part of the database, there is no way to associate with concrete
   * data-flow nodes from the external library).
   * - **Use-nodes** are associated with data-flow nodes where a value enters the current codebase,
   *   such as the return value of a call to an external function.
   * - **Def-nodes** are associated with data-flow nodes where a value leaves the current codebase,
   *   such as an argument passed in a call to an external function.
   *
   *
   * ### Access paths and edge labels
   *
   * Nodes in the API graph are associated with a set of access paths, describing a series of operations
   * that may be performed to obtain that value.
   *
   * For example, the access path `API::moduleImport("lodash").getMember("extend")` represents the action of
   * importing `lodash` and then accessing the member `extend` on the resulting object.
   * It would be associated with an expression such as `require("lodash").extend`.
   *
   * Each edge in the graph is labelled by such an "operation". For an edge `A->B`, the type of the `A` node
   * determines who is performing the operation, and the type of the `B` node determines who ends up holding
   * the result:
   * - An edge starting from a use-node describes what the current codebase is doing to a value that
   *   came from a library.
   * - An edge starting from a def-node describes what the external library might do to a value that
   *   came from the current codebase.
   * - An edge ending in a use-node means the result ends up in the current codebase (at its associated data-flow node).
   * - An edge ending in a def-node means the result ends up in external code (its associated data-flow node is
   *   the place where it was "last seen" in the current codebase before flowing out)
   *
   * Because the implementation of the external library is not visible, it is not known exactly what operations
   * it will perform on values that flow there. Instead, the edges starting from a def-node are operations that would
   * lead to an observable effect within the current codebase; without knowing for certain if the library will actually perform
   * those operations. (When constructing these edges, we assume the library is somewhat well-behaved).
   *
   * For example, given this snippet:
   * ```js
   * require('foo')(x => { doSomething(x) })
   * ```
   * A callback is passed to the external function `foo`. We can't know if `foo` will actually invoke this callback.
   * But _if_ the library should decide to invoke the callback, then a value will flow into the current codebase via the `x` parameter.
   * For that reason, an edge is generated representing the argument-passing operation that might be performed by `foo`.
   * This edge is going from the def-node associated with the callback to the use-node associated with the parameter `x`.
   *
   * ### Thinking in operations versus code patterns
   *
   * Treating edges as "operations" helps avoid a pitfall in which library models become overly specific to certain code patterns.
   * Consider the following two equivalent calls to `foo`:
   * ```js
   * const foo = require('foo');
   *
   * foo({
   *   myMethod(x) {...}
   * });
   *
   * foo({
   *   get myMethod() {
   *     return function(x) {...}
   *   }
   * });
   * ```
   * If `foo` calls `myMethod` on its first parameter, either of the `myMethod` implementations will be invoked.
   * And indeed, the access path `API::moduleImport("foo").getParameter(0).getMember("myMethod").getParameter(0)` correctly
   * identifies both `x` parameters.
   *
   * Observe how `getMember("myMethod")` behaves when the member is defined via a getter. When thinking in code patterns,
   * it might seem obvious that `getMember` should have obtained a reference to the getter method itself.
   * But when seeing it as an access to `myMethod` performed by the library, we can deduce that the relevant expression
   * on the client side is actually the return-value of the getter.
   *
   * Although one may think of API graphs as a tool to find certain program elements in the codebase,
   * it can lead to some situations where intuition does not match what works best in practice.
   */
  class Node extends Impl::TApiNode {
    /**
     * Get a data-flow node where this value may flow after entering the current codebase.
     *
     * This is similar to `asSource()` but additionally includes nodes that are transitively reachable by data flow.
     * See `asSource()` for examples.
     */
    pragma[inline]
    DataFlow::Node getAValueReachableFromSource() {
      Impl::trackUseNode(this.asSource()).flowsTo(result)
    }

    /**
     * Get a data-flow node where this value enters the current codebase.
     *
     * For example:
     * ```js
     * // API::moduleImport("fs").asSource()
     * require('fs');
     *
     * // API::moduleImport("fs").getMember("readFile").asSource()
     * require('fs').readFile;
     *
     * // API::moduleImport("fs").getMember("readFile").getReturn().asSource()
     * require('fs').readFile();
     *
     * require('fs').readFile(
     *  filename,
     *  // 'y' matched by API::moduleImport("fs").getMember("readFile").getParameter(1).getParameter(0).asSource()
     *  y => {
     *    ...
     * });
     * ```
     */
    DataFlow::SourceNode asSource() { Impl::use(this, result) }

    /**
     * Gets a call to the function represented by this API component.
     */
    CallNode getACall() { result = this.getReturn().asSource() }

    /**
     * Gets a call to the function represented by this API component,
     * or a promisified version of the function.
     */
    CallNode getMaybePromisifiedCall() {
      result = this.getACall()
      or
      result = Impl::getAPromisifiedInvocation(this, _, _)
    }

    /**
     * Gets a `new` call to the function represented by this API component.
     */
    NewNode getAnInstantiation() { result = this.getInstance().asSource() }

    /**
     * Gets an invocation (with our without `new`) to the function represented by this API component.
     */
    InvokeNode getAnInvocation() { result = this.getACall() or result = this.getAnInstantiation() }

    /**
     * Get a data-flow node where this value leaves the current codebase and flows into an
     * external library (or in general, any external codebase).
     *
     * Concretely, this is either an argument passed to a call to external code,
     * or the right-hand side of a property write on an object flowing into such a call.
     *
     * For example:
     * ```js
     * // 'x' is matched by API::moduleImport("foo").getParameter(0).asSink()
     * require('foo')(x);
     *
     * // 'x' is matched by API::moduleImport("foo").getParameter(0).getMember("prop").asSink()
     * require('foo')({
     *   prop: x
     * });
     * ```
     */
    DataFlow::Node asSink() { Impl::rhs(this, result) }

    /**
     * Get a data-flow node that transitively flows to an external library (or in general, any external codebase).
     *
     * This is similar to `asSink()` but additionally includes nodes that transitively reach a sink by data flow.
     * See `asSink()` for examples.
     */
    DataFlow::Node getAValueReachingSink() { result = Impl::trackDefNode(this.asSink()) }

    /**
     * Gets a node representing member `m` of this API component.
     *
     * For example, modules have an `exports` member representing their exports, and objects have
     * their properties as members.
     */
    cached
    Node getMember(string m) {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::member(m))
    }

    /**
     * Gets a node representing a member of this API component where the name of the member is
     * not known statically.
     */
    cached
    Node getUnknownMember() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::unknownMember())
    }

    /**
     * Gets a node representing a member of this API component where the name of the member may
     * or may not be known statically.
     */
    cached
    Node getAMember() {
      Stages::ApiStage::ref() and
      result = this.getMember(_)
      or
      result = this.getUnknownMember()
    }

    /**
     * Gets a node representing an instance of the class represented by this node.
     * This includes instances of subclasses.
     *
     * For example:
     * ```js
     * import { C } from "foo";
     *
     * new C(); // API::moduleImport("foo").getMember("C").getInstance()
     *
     * class D extends C {
     *   m() {
     *     this; // API::moduleImport("foo").getMember("C").getInstance()
     *  }
     * }
     *
     * new D(); // API::moduleImport("foo").getMember("C").getInstance()
     * ```
     */
    cached
    Node getInstance() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::instance())
    }

    /**
     * Gets a node representing the `i`th parameter of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distingiush between individual calls.
     */
    cached
    Node getParameter(int i) {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::parameter(i))
    }

    /**
     * Gets the number of parameters of the function represented by this node.
     */
    int getNumParameter() { result = max(int s | exists(this.getParameter(s))) + 1 }

    /**
     * Gets a node representing the last parameter of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distingiush between individual calls.
     */
    Node getLastParameter() { result = this.getParameter(this.getNumParameter() - 1) }

    /**
     * Gets a node representing the receiver of the function represented by this node.
     */
    cached
    Node getReceiver() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::receiver())
    }

    /**
     * Gets a node representing a parameter of the function represented by this node.
     *
     * This predicate may result in a mix of parameters from different call sites in cases where
     * there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distingiush between individual calls.
     */
    cached
    Node getAParameter() {
      Stages::ApiStage::ref() and
      result = this.getParameter(_)
    }

    /**
     * Gets a node representing the result of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getACall()` if there is a need to distingiush between individual calls.
     */
    cached
    Node getReturn() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::return())
    }

    /**
     * Gets a node representing the promised value wrapped in the `Promise` object represented by
     * this node.
     */
    cached
    Node getPromised() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::promised())
    }

    /**
     * Gets a node representing the error wrapped in the `Promise` object represented by this node.
     */
    cached
    Node getPromisedError() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::promisedError())
    }

    /**
     * Gets a node representing a function that is a wrapper around the function represented by this node.
     *
     * Concretely, a function that forwards all its parameters to a call to `f` and returns the result of that call
     * is considered a wrapper around `f`.
     *
     * Examples:
     * ```js
     * function f(x) {
     *   return g(x); // f = g.getForwardingFunction()
     * }
     *
     * function doExec(x) {
     *   console.log(x);
     *   return exec(x); // doExec = exec.getForwardingFunction()
     * }
     *
     * function doEither(x, y) {
     *   if (x > y) {
     *     return foo(x, y); // doEither = foo.getForwardingFunction()
     *   } else {
     *     return bar(x, y); // doEither = bar.getForwardingFunction()
     *   }
     * }
     *
     * function wrapWithLogging(f) {
     *   return (x) => {
     *     console.log(x);
     *     return f(x); // f.getForwardingFunction() = anonymous arrow function
     *   }
     * }
     * wrapWithLogging(g); // g.getForwardingFunction() = wrapWithLogging(g)
     * ```
     */
    cached
    Node getForwardingFunction() {
      Stages::ApiStage::ref() and
      result = this.getASuccessor(Label::forwardingFunction())
    }

    /**
     * Gets any class that has this value as a decorator.
     *
     * For example:
     * ```js
     * import { D } from "foo";
     *
     * // moduleImport("foo").getMember("D").getADecoratedClass()
     * @D
     * class C1 {}
     *
     * // moduleImport("foo").getMember("D").getReturn().getADecoratedClass()
     * @D()
     * class C2 {}
     * ```
     */
    cached
    Node getADecoratedClass() { result = this.getASuccessor(Label::decoratedClass()) }

    /**
     * Gets any method, field, or accessor that has this value as a decorator.
     *
     * In the case of an accessor, this gets the return value of a getter, or argument to a setter.
     *
     * For example:
     * ```js
     * import { D } from "foo";
     *
     * class C {
     *   // moduleImport("foo").getMember("D").getADecoratedMember()
     *   @D m1() {}
     *   @D f;
     *   @D get g() { return this.x; }
     *
     *   // moduleImport("foo").getMember("D").getReturn().getADecoratedMember()
     *   @D() m2() {}
     *   @D() f2;
     *   @D() get g2() { return this.x; }
     * }
     * ```
     */
    cached
    Node getADecoratedMember() { result = this.getASuccessor(Label::decoratedMember()) }

    /**
     * Gets any parameter that has this value as a decorator.
     *
     * For example:
     * ```js
     * import { D } from "foo";
     *
     * class C {
     *   method(
     *     // moduleImport("foo").getMember("D").getADecoratedParameter()
     *     @D
     *     param1,
     *     // moduleImport("foo").getMember("D").getReturn().getADecoratedParameter()
     *     @D()
     *     param2
     *  ) {}
     * }
     * ```
     */
    cached
    Node getADecoratedParameter() { result = this.getASuccessor(Label::decoratedParameter()) }

    /**
     * Gets a string representation of the lexicographically least among all shortest access paths
     * from the root to this node.
     */
    string getPath() {
      result = min(string p | p = this.getAPath(Impl::distanceFromRoot(this)) | p)
    }

    /**
     * Gets a node such that there is an edge in the API graph between this node and the other
     * one, and that edge is labeled with `lbl`.
     */
    Node getASuccessor(Label::ApiLabel lbl) { Impl::edge(this, lbl, result) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one, and that edge is labeled with `lbl`
     */
    Node getAPredecessor(Label::ApiLabel lbl) { this = result.getASuccessor(lbl) }

    /**
     * Gets a node such that there is an edge in the API graph between this node and the other
     * one.
     */
    Node getAPredecessor() { result = this.getAPredecessor(_) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one.
     */
    Node getASuccessor() { result = this.getASuccessor(_) }

    /**
     * Holds if this node may take its value from `that` node.
     *
     * In other words, the value of a use of `that` may flow into the right-hand side of a
     * definition of this node.
     */
    pragma[inline]
    predicate refersTo(Node that) { this.asSink() = that.getAValueReachableFromSource() }

    /**
     * Gets the data-flow node that gives rise to this node, if any.
     */
    DataFlow::Node getInducingNode() {
      this = Impl::MkClassInstance(result) or
      this = Impl::MkUse(result) or
      this = Impl::MkDef(result) or
      this = Impl::MkSyntheticCallbackArg(_, _, result)
    }

    /**
     * Gets the location of this API node, if it corresponds to a program element with a source location.
     */
    final Location getLocation() { result = this.getInducingNode().getLocation() }

    /**
     * DEPRECATED: Use `getLocation().hasLocationInfo()` instead.
     *
     * Holds if this node is located in file `path` between line `startline`, column `startcol`,
     * and line `endline`, column `endcol`.
     *
     * For nodes that do not have a meaningful location, `path` is the empty string and all other
     * parameters are zero.
     */
    deprecated predicate hasLocationInfo(
      string path, int startline, int startcol, int endline, int endcol
    ) {
      this.getLocation().hasLocationInfo(path, startline, startcol, endline, endcol)
      or
      not exists(this.getLocation()) and
      path = "" and
      startline = 0 and
      startcol = 0 and
      endline = 0 and
      endcol = 0
    }

    /**
     * Gets a textual representation of this node.
     */
    string toString() {
      none() // defined in subclasses
    }

    /**
     * Gets a path of the given `length` from the root to this node.
     */
    private string getAPath(int length) {
      this instanceof Impl::MkRoot and
      length = 0 and
      result = ""
      or
      exists(Node pred, Label::ApiLabel lbl, string predpath |
        Impl::edge(pred, lbl, this) and
        predpath = pred.getAPath(length - 1) and
        exists(string dot | if length = 1 then dot = "" else dot = "." |
          result = predpath + dot + lbl and
          // avoid producing strings longer than 1MB
          result.length() < 1000 * 1000
        )
      ) and
      length in [1 .. Impl::distanceFromRoot(this)]
    }

    /** Gets the shortest distance from the root to this node in the API graph. */
    int getDepth() { result = Impl::distanceFromRoot(this) }
  }

  /** The root node of an API graph. */
  class Root extends Node, Impl::MkRoot {
    override string toString() { result = "root" }
  }

  /** A node corresponding to a definition of an API component. */
  class Definition extends Node, Impl::TDef {
    override string toString() { result = "def " + this.getPath() }
  }

  /** A node corresponding to the use of an API component. */
  class Use extends Node, Impl::TUse {
    override string toString() { result = "use " + this.getPath() }
  }

  /** Gets the root node. */
  Root root() { any() }

  /** Gets a node corresponding to an import of module `m`. */
  Node moduleImport(string m) {
    result = Internal::getAModuleImportRaw(m)
    or
    result = ModelOutput::getATypeNode(m, "")
  }

  /** Gets a node corresponding to an export of module `m`. */
  Node moduleExport(string m) { result = Impl::MkModuleDef(m).(Node).getMember("exports") }

  /** Provides helper predicates for accessing API-graph nodes. */
  module Node {
    /** Gets a node whose type has the given qualified name. */
    Node ofType(string moduleName, string exportedName) {
      result = Internal::getANodeOfTypeRaw(moduleName, exportedName)
      or
      result = ModelOutput::getATypeNode(moduleName, exportedName)
    }
  }

  /** Provides access to API graph nodes without taking into account types from models. */
  module Internal {
    /** Gets a node corresponding to an import of module `m` without taking into account types from models. */
    Node getAModuleImportRaw(string m) {
      result = Impl::MkModuleImport(m) or
      result = Impl::MkModuleImport(m).(Node).getMember("default")
    }

    /** Gets a node whose type has the given qualified name, not including types from models. */
    Node getANodeOfTypeRaw(string moduleName, string exportedName) {
      result = Impl::MkTypeUse(moduleName, exportedName).(Node).getInstance()
      or
      exportedName = "" and
      result = getAModuleImportRaw(moduleName)
    }

    /** Gets a sink node that represents instances of `cls`. */
    Node getClassInstance(DataFlow::ClassNode cls) { result = Impl::MkClassInstance(cls) }
  }

  /**
   * An API entry point.
   *
   * By default, API graph nodes are only created for nodes that come from an external
   * library or escape into an external library. The points where values are cross the boundary
   * between codebases are called "entry points".
   *
   * Imports and exports are considered entry points by default, but additional entry points may
   * be added by extending this class. Typical examples include global variables.
   */
  abstract class EntryPoint extends string {
    bindingset[this]
    EntryPoint() { any() }

    /** Gets a data-flow node where a value enters the current codebase through this entry-point. */
    DataFlow::SourceNode getASource() { none() }

    /** Gets a data-flow node where a value leaves the current codebase through this entry-point. */
    DataFlow::Node getASink() { none() }

    /** Gets an API-node for this entry point. */
    API::Node getANode() { result = root().getASuccessor(Label::entryPoint(this)) }
  }

  /**
   * A class for contributing new steps for tracking uses of an API.
   */
  class AdditionalUseStep extends Unit {
    /**
     * Holds if use nodes should flow from `pred` to `succ`.
     */
    predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ) { none() }
  }

  private module AdditionalUseStep {
    pragma[nomagic]
    predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
      any(AdditionalUseStep st).step(pred, succ)
    }
  }

  /**
   * Provides the actual implementation of API graphs, cached for performance.
   *
   * Ideally, we'd like nodes to correspond to (global) access paths, with edge labels
   * corresponding to extending the access path by one element. We also want to be able to map
   * nodes to their definitions and uses in the data-flow graph, and this should happen modulo
   * (inter-procedural) data flow.
   *
   * This, however, is not easy to implement, since access paths can have unbounded length
   * and we need some way of recognizing cycles to avoid non-termination. Unfortunately, expressing
   * a condition like "this node hasn't been involved in constructing any predecessor of
   * this node in the API graph" without negative recursion is tricky.
   *
   * So instead most nodes are directly associated with a data-flow node, representing
   * either a use or a definition of an API component. This ensures that we only have a finite
   * number of nodes. However, we can now have multiple nodes with the same access
   * path, which are essentially indistinguishable for a client of the API.
   *
   * On the other hand, a single node can have multiple access paths (which is, of
   * course, unavoidable). We pick as canonical the alphabetically least access path with
   * shortest length.
   */
  cached
  private module Impl {
    cached
    newtype TApiNode =
      MkRoot() or
      MkModuleDef(string m) { exists(MkModuleExport(m)) } or
      MkModuleUse(string m) { exists(MkModuleImport(m)) } or
      MkModuleExport(string m) {
        exists(Module mod | mod = importableModule(m) |
          // exclude modules that don't actually export anything
          exports(m, _)
          or
          exports(m, _, _)
          or
          exists(NodeModule nm | nm = mod |
            exists(Ssa::implicitInit([nm.getModuleVariable(), nm.getExportsVariable()]))
          )
        )
      } or
      MkModuleImport(string m) {
        imports(_, m)
        or
        any(TypeAnnotation n).hasQualifiedName(m, _)
        or
        any(Type t).hasUnderlyingType(m, _)
      } or
      MkClassInstance(DataFlow::ClassNode cls) { needsDefNode(cls) } or
      MkDef(DataFlow::Node nd) { rhs(_, _, nd) } or
      MkUse(DataFlow::Node nd) { use(_, _, nd) } or
      /** A use of a TypeScript type. */
      MkTypeUse(string moduleName, string exportName) {
        any(TypeAnnotation n).hasQualifiedName(moduleName, exportName)
        or
        any(Type t).hasUnderlyingType(moduleName, exportName)
      } or
      MkSyntheticCallbackArg(DataFlow::Node src, int bound, DataFlow::InvokeNode nd) {
        trackUseNode(src, true, bound, "").flowsTo(nd.getCalleeNode())
      }

    private predicate needsDefNode(DataFlow::ClassNode cls) {
      hasSemantics(cls) and
      (
        cls = trackDefNode(_)
        or
        cls.getAnInstanceReference() = trackDefNode(_)
        or
        needsDefNode(cls.getADirectSubClass())
      )
    }

    class TDef = MkModuleDef or TNonModuleDef;

    class TNonModuleDef = MkModuleExport or MkClassInstance or MkDef or MkSyntheticCallbackArg;

    class TUse = MkModuleUse or MkModuleImport or MkUse or MkTypeUse;

    private predicate hasSemantics(DataFlow::Node nd) { not nd.getTopLevel().isExterns() }

    /** Holds if `imp` is an import of module `m`. */
    private predicate imports(DataFlow::Node imp, string m) {
      imp = DataFlow::moduleImport(m) and
      // path must not start with a dot or a slash
      m.regexpMatch("[^./].*") and
      hasSemantics(imp)
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of a node that should have an
     * incoming edge from `base` labeled `lbl` in the API graph.
     */
    cached
    predicate rhs(TApiNode base, Label::ApiLabel lbl, DataFlow::Node rhs) {
      hasSemantics(rhs) and
      (
        base = MkRoot() and
        exists(EntryPoint e |
          lbl = Label::entryPoint(e) and
          rhs = e.getASink()
        )
        or
        exists(string m, string prop |
          base = MkModuleExport(m) and
          lbl = Label::member(prop) and
          exports(m, prop, rhs)
        )
        or
        exists(DataFlow::Node def, DataFlow::SourceNode pred |
          rhs(base, def) and pred = trackDefNode(def)
        |
          // from `x` to a definition of `x.prop`
          exists(DataFlow::PropWrite pw | pw = pred.getAPropertyWrite() |
            lbl = Label::memberFromRef(pw) and
            rhs = pw.getRhs()
          )
          or
          // special case: from `require('m')` to an export of `prop` in `m`
          exists(Import imp, Module m, string prop |
            pred = imp.getImportedModuleNode() and
            m = imp.getImportedModule() and
            lbl = Label::member(prop) and
            rhs = m.getAnExportedValue(prop)
          )
          or
          // In general, turn store steps into member steps for def-nodes
          exists(string prop |
            PreCallGraphStep::storeStep(rhs, pred, prop) and
            lbl = Label::member(prop) and
            not DataFlow::PseudoProperties::isPseudoProperty(prop)
          )
          or
          exists(DataFlow::FunctionNode fn |
            fn = pred and
            lbl = Label::return()
          |
            if fn.getFunction().isAsync() then rhs = fn.getReturnNode() else rhs = fn.getAReturn()
          )
          or
          lbl = Label::promised() and
          PromiseFlow::storeStep(rhs, pred, Promises::valueProp())
          or
          lbl = Label::promisedError() and
          PromiseFlow::storeStep(rhs, pred, Promises::errorProp())
          or
          // The return-value of a getter G counts as a definition of property G
          // (Ordinary methods and properties are handled as PropWrite nodes)
          exists(string name | lbl = Label::member(name) |
            rhs = pred.(DataFlow::ObjectLiteralNode).getPropertyGetter(name).getAReturn()
            or
            rhs =
              pred.(DataFlow::ClassNode)
                  .getStaticMember(name, DataFlow::MemberKind::getter())
                  .getAReturn()
          )
        )
        or
        exists(DataFlow::ClassNode cls, string name |
          base = MkClassInstance(cls) and
          lbl = Label::member(name)
        |
          rhs = cls.getInstanceMethod(name)
          or
          rhs = cls.getInstanceMember(name, DataFlow::MemberKind::getter()).getAReturn()
        )
        or
        exists(DataFlow::FunctionNode f |
          f.getFunction().isAsync() and
          base = MkDef(f.getReturnNode())
        |
          lbl = Label::promised() and
          rhs = f.getAReturn()
          or
          lbl = Label::promisedError() and
          rhs = f.getExceptionalReturn()
        )
        or
        exists(int i | argumentPassing(base, i, rhs) |
          lbl = Label::parameter(i)
          or
          i = -1 and lbl = Label::receiver()
        )
        or
        exists(DataFlow::SourceNode src, DataFlow::PropWrite pw |
          use(base, src) and pw = trackUseNode(src).getAPropertyWrite() and rhs = pw.getRhs()
        |
          lbl = Label::memberFromRef(pw)
        )
      )
      or
      decoratorDualEdge(base, lbl, rhs)
      or
      decoratorRhsEdge(base, lbl, rhs)
      or
      exists(DataFlow::PropWrite write |
        decoratorPropEdge(base, lbl, write) and
        rhs = write.getRhs()
      )
    }

    /**
     * Holds if `arg` is passed as the `i`th argument to a use of `base`, either by means of a
     * full invocation, or in a partial function application.
     *
     * The receiver is considered to be argument -1.
     */
    private predicate argumentPassing(TApiNode base, int i, DataFlow::Node arg) {
      exists(DataFlow::Node use, DataFlow::SourceNode pred, int bound |
        use(base, use) and pred = trackUseNode(use, _, bound, "")
      |
        arg = pred.getAnInvocation().getArgument(i - bound)
        or
        arg = pred.getACall().getReceiver() and
        bound = 0 and
        i = -1
        or
        exists(DataFlow::PartialInvokeNode pin, DataFlow::Node callback | pred.flowsTo(callback) |
          pin.isPartialArgument(callback, arg, i - bound)
          or
          arg = pin.getBoundReceiver(callback) and
          bound = 0 and
          i = -1
        )
      )
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of node `nd`.
     */
    cached
    predicate rhs(TApiNode nd, DataFlow::Node rhs) {
      exists(string m | nd = MkModuleExport(m) | exports(m, rhs))
      or
      nd = MkDef(rhs)
    }

    /**
     * Holds if `ref` is a read of a property described by `lbl` on `pred`, and
     * `propDesc` is compatible with that property, meaning it is either the
     * name of the property itself or the empty string.
     */
    pragma[noinline]
    private predicate propertyRead(
      DataFlow::SourceNode pred, string propDesc, Label::ApiLabel lbl, DataFlow::Node ref
    ) {
      ref = pred.getAPropertyRead() and
      lbl = Label::memberFromRef(ref) and
      (
        lbl = Label::member(propDesc)
        or
        propDesc = ""
      )
      or
      PromiseFlow::loadStep(pred.getALocalUse(), ref, Promises::valueProp()) and
      lbl = Label::promised() and
      (propDesc = Promises::valueProp() or propDesc = "")
      or
      PromiseFlow::loadStep(pred.getALocalUse(), ref, Promises::errorProp()) and
      lbl = Label::promisedError() and
      (propDesc = Promises::errorProp() or propDesc = "")
    }

    pragma[nomagic]
    private DataFlow::ClassNode getALocalSubclass(DataFlow::SourceNode node) {
      result.getASuperClassNode().getALocalSource() = node
    }

    bindingset[node]
    pragma[inline_late]
    private DataFlow::ClassNode getALocalSubclassFwd(DataFlow::SourceNode node) {
      result = getALocalSubclass(node)
    }

    /**
     * Holds if `ref` is a use of a node that should have an incoming edge from `base` labeled
     * `lbl` in the API graph.
     */
    cached
    predicate use(TApiNode base, Label::ApiLabel lbl, DataFlow::Node ref) {
      hasSemantics(ref) and
      (
        base = MkRoot() and
        exists(EntryPoint e |
          lbl = Label::entryPoint(e) and
          ref = e.getASource()
        )
        or
        // property reads
        exists(DataFlow::SourceNode src, DataFlow::SourceNode pred, string propDesc |
          use(base, src) and
          pred = trackUseNode(src, false, 0, propDesc) and
          propertyRead(pred, propDesc, lbl, ref) and
          // `module.exports` is special: it is a use of a def-node, not a use-node,
          // so we want to exclude it here
          (base instanceof TNonModuleDef or base instanceof TUse)
        )
        or
        exists(DataFlow::SourceNode src, DataFlow::SourceNode pred |
          use(base, src) and pred = trackUseNode(src)
        |
          lbl = Label::instance() and
          ref = pred.getAnInstantiation()
          or
          lbl = Label::return() and
          ref = pred.getAnInvocation()
          or
          lbl = Label::forwardingFunction() and
          DataFlow::functionForwardingStep(pred.getALocalUse(), ref)
          or
          exists(DataFlow::ClassNode cls |
            lbl = Label::instance() and
            cls = getALocalSubclassFwd(pred).getADirectSubClass*()
          |
            ref = cls.getAReceiverNode()
            or
            ref = cls.getAClassReference().getAnInstantiation()
          )
          or
          exists(string prop |
            PreCallGraphStep::loadStep(pred.getALocalUse(), ref, prop) and
            lbl = Label::member(prop) and
            // avoid generating member edges like "$arrayElement$"
            not DataFlow::PseudoProperties::isPseudoProperty(prop)
          )
        )
        or
        exists(DataFlow::Node def, DataFlow::FunctionNode fn |
          rhs(base, def) and fn = trackDefNode(def)
        |
          exists(int i |
            lbl = Label::parameter(i) and
            ref = fn.getParameter(i)
          )
          or
          lbl = Label::receiver() and
          ref = fn.getReceiver()
        )
        or
        exists(DataFlow::Node def, DataFlow::ClassNode cls, int i |
          rhs(base, def) and cls = trackDefNode(def)
        |
          lbl = Label::parameter(i) and
          ref = cls.getConstructor().getParameter(i)
        )
        or
        exists(string moduleName, string exportName |
          base = MkTypeUse(moduleName, exportName) and
          lbl = Label::instance() and
          ref.(DataFlow::SourceNode).hasUnderlyingType(moduleName, exportName)
        )
        or
        exists(DataFlow::InvokeNode call |
          base = MkSyntheticCallbackArg(_, _, call) and
          lbl = Label::parameter(1) and
          ref = awaited(call)
        )
        or
        decoratorDualEdge(base, lbl, ref)
        or
        decoratorUseEdge(base, lbl, ref)
        or
        // for fields and accessors, mark the reads as use-nodes
        decoratorPropEdge(base, lbl, ref.(DataFlow::PropRead))
      )
    }

    /** Holds if `base` is a use-node that flows to the decorator expression of the given decorator. */
    pragma[nomagic]
    private predicate useNodeFlowsToDecorator(TApiNode base, Decorator decorator) {
      exists(DataFlow::SourceNode decoratorSrc |
        use(base, decoratorSrc) and
        trackUseNode(decoratorSrc).flowsToExpr(decorator.getExpression())
      )
    }

    /**
     * Holds if `ref` corresponds to both a use and def-node that should have an incoming edge from `base` labelled `lbl`.
     *
     * This happens because the decorated value escapes into the decorator function, and is then replaced
     * by the function's return value. In the JS analysis we generally assume decorators return their input,
     * but library models may want to find the return value.
     */
    private predicate decoratorDualEdge(TApiNode base, Label::ApiLabel lbl, DataFlow::Node ref) {
      exists(ClassDefinition cls |
        useNodeFlowsToDecorator(base, cls.getADecorator()) and
        lbl = Label::decoratedClass() and
        ref = DataFlow::valueNode(cls)
      )
      or
      exists(MethodDefinition method |
        useNodeFlowsToDecorator(base, method.getADecorator()) and
        not method instanceof AccessorMethodDefinition and
        lbl = Label::decoratedMember() and
        ref = DataFlow::valueNode(method.getBody())
      )
    }

    /** Holds if `ref` is a use that should have an incoming edge from `base` labelled `lbl`, induced by a decorator. */
    private predicate decoratorUseEdge(TApiNode base, Label::ApiLabel lbl, DataFlow::Node ref) {
      exists(SetterMethodDefinition accessor |
        useNodeFlowsToDecorator(base,
          [accessor.getADecorator(), accessor.getCorrespondingGetter().getADecorator()]) and
        lbl = Label::decoratedMember() and
        ref = DataFlow::parameterNode(accessor.getBody().getParameter(0))
      )
      or
      exists(Parameter param |
        useNodeFlowsToDecorator(base, param.getADecorator()) and
        lbl = Label::decoratedParameter() and
        ref = DataFlow::parameterNode(param)
      )
    }

    /** Holds if `rhs` is a def node that should have an incoming edge from `base` labelled `lbl`, induced by a decorator. */
    private predicate decoratorRhsEdge(TApiNode base, Label::ApiLabel lbl, DataFlow::Node rhs) {
      exists(GetterMethodDefinition accessor |
        useNodeFlowsToDecorator(base,
          [accessor.getADecorator(), accessor.getCorrespondingSetter().getADecorator()]) and
        lbl = Label::decoratedMember() and
        rhs = DataFlow::valueNode(accessor.getBody().getAReturnedExpr())
      )
    }

    /**
     * Holds if `ref` is a reference to a field/accessor that should have en incoming edge from base labelled `lbl`.
     *
     * Since fields do not have their own data-flow nodes, we generate a node for each read or write.
     * For property writes, the right-hand side becomes a def-node and property reads become use-nodes.
     *
     * For accessors this predicate computes each use of the accessor.
     * The return value inside the accessor is computed by the `decoratorRhsEdge` predicate.
     */
    private predicate decoratorPropEdge(TApiNode base, Label::ApiLabel lbl, DataFlow::PropRef ref) {
      exists(MemberDefinition fieldLike, DataFlow::ClassNode cls |
        fieldLike instanceof FieldDefinition
        or
        fieldLike instanceof AccessorMethodDefinition
      |
        useNodeFlowsToDecorator(base, fieldLike.getADecorator()) and
        lbl = Label::decoratedMember() and
        cls = fieldLike.getDeclaringClass().flow() and
        (
          fieldLike.isStatic() and
          ref = cls.getAClassReference().getAPropertyReference(fieldLike.getName())
          or
          not fieldLike.isStatic() and
          ref = cls.getAnInstanceReference().getAPropertyReference(fieldLike.getName())
        )
      )
    }

    /**
     * Holds if `ref` is a use of node `nd`.
     */
    cached
    predicate use(TApiNode nd, DataFlow::Node ref) {
      exists(string m, Module mod | nd = MkModuleDef(m) and mod = importableModule(m) |
        ref = DataFlow::moduleVarNode(mod)
      )
      or
      exists(string m, Module mod | nd = MkModuleExport(m) and mod = importableModule(m) |
        ref = DataFlow::exportsVarNode(mod)
        or
        exists(DataFlow::Node base | use(MkModuleDef(m), base) |
          ref = trackUseNode(base).getAPropertyRead("exports")
        )
      )
      or
      exists(string m |
        nd = MkModuleImport(m) and
        ref = DataFlow::moduleImport(m)
      )
      or
      exists(DataFlow::ClassNode cls | nd = MkClassInstance(cls) |
        ref = cls.getAReceiverNode()
        or
        ref = cls.(DataFlow::ClassNode::FunctionStyleClass).getAPrototypeReference()
      )
      or
      nd = MkUse(ref)
    }

    private import semmle.javascript.dataflow.TypeTracking

    /**
     * Gets a data-flow node to which `nd`, which is a use of an API-graph node, flows.
     *
     * The flow from `nd` to that node may be inter-procedural, and is further described by three
     * flags:
     *
     *   - `promisified`: if true `true`, the flow goes through a promisification;
     *   - `boundArgs`: for function values, tracks how many arguments have been bound throughout
     *     the flow. To ensure termination, we somewhat arbitrarily constrain the number of bound
     *     arguments to be at most ten.
     *   - `prop`: if non-empty, the flow is only guaranteed to preserve the value of this property,
     *     and not necessarily the entire object.
     */
    private DataFlow::SourceNode trackUseNode(
      DataFlow::SourceNode nd, boolean promisified, int boundArgs, string prop,
      DataFlow::TypeTracker t
    ) {
      t.start() and
      use(_, nd) and
      result = nd and
      promisified = false and
      boundArgs = 0 and
      prop = ""
      or
      exists(Promisify::PromisifyCall promisify |
        trackUseNode(nd, false, boundArgs, prop, t.continue()).flowsTo(promisify.getArgument(0)) and
        promisified = true and
        prop = "" and
        result = promisify
      )
      or
      exists(DataFlow::PartialInvokeNode pin, DataFlow::Node pred, int predBoundArgs |
        trackUseNode(nd, promisified, predBoundArgs, prop, t.continue()).flowsTo(pred) and
        prop = "" and
        result = pin.getBoundFunction(pred, boundArgs - predBoundArgs) and
        boundArgs in [0 .. 10]
      )
      or
      exists(DataFlow::SourceNode mid |
        mid = trackUseNode(nd, promisified, boundArgs, prop, t) and
        AdditionalUseStep::step(pragma[only_bind_out](mid), result)
      )
      or
      exists(DataFlow::Node pred, string preprop |
        trackUseNode(nd, promisified, boundArgs, preprop, t.continue()).flowsTo(pred) and
        promisified = false and
        boundArgs = 0 and
        SharedTypeTrackingStep::loadStoreStep(pred, result, prop)
      |
        prop = preprop
        or
        preprop = ""
      )
      or
      t = useStep(nd, promisified, boundArgs, prop, result)
    }

    private import semmle.javascript.dataflow.internal.StepSummary

    /**
     * Holds if `nd`, which is a use of an API-graph node, flows in zero or more potentially
     * inter-procedural steps to some intermediate node, and then from that intermediate node to
     * `res` in one step. The entire flow is described by the resulting `TypeTracker`.
     *
     * This predicate exists solely to enforce a better join order in `trackUseNode` above.
     */
    pragma[noopt]
    private DataFlow::TypeTracker useStep(
      DataFlow::Node nd, boolean promisified, int boundArgs, string prop, DataFlow::Node res
    ) {
      exists(DataFlow::TypeTracker t, StepSummary summary, DataFlow::SourceNode prev |
        prev = trackUseNode(nd, promisified, boundArgs, prop, t) and
        StepSummary::step(prev, res, summary) and
        result = t.append(summary)
      )
    }

    private DataFlow::SourceNode trackUseNode(
      DataFlow::SourceNode nd, boolean promisified, int boundArgs, string prop
    ) {
      result = trackUseNode(nd, promisified, boundArgs, prop, DataFlow::TypeTracker::end())
    }

    /**
     * Gets a node that is inter-procedurally reachable from `nd`, which is a use of some node.
     */
    cached
    DataFlow::SourceNode trackUseNode(DataFlow::SourceNode nd) {
      result = trackUseNode(nd, false, 0, "")
    }

    private DataFlow::SourceNode trackDefNode(DataFlow::Node nd, DataFlow::TypeBackTracker t) {
      t.start() and
      rhs(_, nd) and
      result = nd.getALocalSource()
      or
      // additional backwards step from `require('m')` to `exports` or `module.exports` in m
      exists(Import imp | imp.getImportedModuleNode() = trackDefNode(nd, t.continue()) |
        result = DataFlow::exportsVarNode(imp.getImportedModule())
        or
        result = DataFlow::moduleVarNode(imp.getImportedModule()).getAPropertyRead("exports")
      )
      or
      exists(ObjectExpr obj |
        obj = trackDefNode(nd, t.continue()).asExpr() and
        result =
          obj.getAProperty()
              .(SpreadProperty)
              .getInit()
              .(SpreadElement)
              .getOperand()
              .flow()
              .getALocalSource()
      )
      or
      t = defStep(nd, result)
    }

    /**
     * Holds if `nd`, which is a def of an API-graph node, can be reached in zero or more potentially
     * inter-procedural steps from some intermediate node, and `prev` flows into that intermediate node
     * in one step. The entire flow is described by the resulting `TypeTracker`.
     *
     * This predicate exists solely to enforce a better join order in `trackDefNode` above.
     */
    pragma[noopt]
    private DataFlow::TypeBackTracker defStep(DataFlow::Node nd, DataFlow::SourceNode prev) {
      exists(DataFlow::TypeBackTracker t, StepSummary summary, DataFlow::Node next |
        next = trackDefNode(nd, t) and
        StepSummary::step(prev, next, summary) and
        result = t.prepend(summary)
      )
    }

    /**
     * Gets a node that inter-procedurally flows into `nd`, which is a definition of some node.
     */
    cached
    DataFlow::SourceNode trackDefNode(DataFlow::Node nd) {
      result = trackDefNode(nd, DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode awaited(DataFlow::InvokeNode call, DataFlow::TypeTracker t) {
      t.startInPromise() and
      exists(MkSyntheticCallbackArg(_, _, call)) and
      result = call
      or
      exists(DataFlow::TypeTracker t2 | result = awaited(call, t2).track(t2, t))
    }

    /**
     * Gets a node holding the resolved value of promise `call`.
     */
    private DataFlow::Node awaited(DataFlow::InvokeNode call) {
      result = awaited(call, DataFlow::TypeTracker::end())
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(TApiNode pred, Label::ApiLabel lbl, TApiNode succ) {
      Stages::ApiStage::ref() and
      exists(string m |
        pred = MkRoot() and
        lbl = Label::moduleLabel(m)
      |
        succ = MkModuleDef(m)
        or
        succ = MkModuleUse(m)
      )
      or
      exists(string m |
        pred = MkModuleDef(m) and
        lbl = Label::member("exports") and
        succ = MkModuleExport(m)
        or
        pred = MkModuleUse(m) and
        lbl = Label::member("exports") and
        succ = MkModuleImport(m)
      )
      or
      exists(DataFlow::SourceNode ref |
        use(pred, lbl, ref) and
        succ = MkUse(ref)
      )
      or
      exists(DataFlow::Node rhs | rhs(pred, lbl, rhs) |
        succ = MkDef(rhs)
        or
        exists(DataFlow::ClassNode cls |
          cls.getAnInstanceReference().flowsTo(rhs) and
          succ = MkClassInstance(cls)
        )
      )
      or
      exists(DataFlow::Node def |
        rhs(pred, def) and
        lbl = Label::instance() and
        succ = MkClassInstance(trackDefNode(def))
      )
      or
      exists(string moduleName, string exportName |
        pred = MkModuleImport(moduleName) and
        lbl = Label::member(exportName) and
        succ = MkTypeUse(moduleName, exportName)
      )
      or
      exists(DataFlow::Node nd, DataFlow::FunctionNode f |
        f.getFunction().isAsync() and
        pred = MkDef(nd) and
        f = trackDefNode(nd) and
        lbl = Label::return() and
        succ = MkDef(f.getReturnNode())
      )
      or
      exists(int bound, DataFlow::InvokeNode call |
        lbl = Label::parameter(bound + call.getNumArgument()) and
        call = getAPromisifiedInvocation(pred, bound, succ)
      )
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph.
     */
    private predicate edge(TApiNode pred, TApiNode succ) { edge(pred, _, succ) }

    /** Gets the shortest distance from the root to `nd` in the API graph. */
    cached
    int distanceFromRoot(TApiNode nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)

    /**
     * Gets a call to a promisified function represented by `callee` where
     * `bound` arguments have been bound.
     */
    cached
    DataFlow::InvokeNode getAPromisifiedInvocation(TApiNode callee, int bound, TApiNode succ) {
      exists(DataFlow::SourceNode src |
        Impl::use(callee, src) and
        succ = Impl::MkSyntheticCallbackArg(src, bound, result)
      )
    }
  }

  /**
   * An `InvokeNode` that is connected to the API graph.
   *
   * Can be used to reason about calls to an external API in which the correlation between
   * parameters and/or return values must be retained.
   *
   * The member predicates `getParameter`, `getReturn`, and `getInstance` mimic the corresponding
   * predicates from `API::Node`. These are guaranteed to exist and be unique to this call.
   */
  class InvokeNode extends DataFlow::InvokeNode {
    API::Node callee;

    InvokeNode() {
      this = callee.getReturn().asSource() or
      this = callee.getInstance().asSource() or
      this = Impl::getAPromisifiedInvocation(callee, _, _)
    }

    /** Gets the API node for the `i`th parameter of this invocation. */
    pragma[nomagic]
    Node getParameter(int i) {
      result = callee.getParameter(i) and
      result = this.getAParameterCandidate(i)
    }

    /**
     * Gets an API node where a RHS of the node is the `i`th argument to this call.
     */
    pragma[noinline]
    private Node getAParameterCandidate(int i) { result.asSink() = this.getArgument(i) }

    /** Gets the API node for a parameter of this invocation. */
    Node getAParameter() { result = this.getParameter(_) }

    /** Gets the API node for the last parameter of this invocation. */
    Node getLastParameter() { result = this.getParameter(this.getNumArgument() - 1) }

    /** Gets the API node for the return value of this call. */
    Node getReturn() {
      result = callee.getReturn() and
      result.asSource() = this
    }

    /** Gets the API node for the object constructed by this invocation. */
    Node getInstance() {
      result = callee.getInstance() and
      result.asSource() = this
    }
  }

  /** A call connected to the API graph. */
  class CallNode extends InvokeNode, DataFlow::CallNode { }

  /** A `new` call connected to the API graph. */
  class NewNode extends InvokeNode, DataFlow::NewNode { }

  /** Provides classes modeling the various edges (labels) in the API graph. */
  module Label {
    /** A label in the API-graph */
    class ApiLabel extends TLabel {
      /** Gets a string representation of this label. */
      string toString() { result = "???" }
    }

    /** Gets the edge label for the module `m`. */
    LabelModule moduleLabel(string m) { result.getMod() = m }

    /** Gets the `member` edge label for member `m`. */
    bindingset[m]
    bindingset[result]
    LabelMember member(string m) { result.getProperty() = m }

    /** Gets the `member` edge label for the unknown member. */
    LabelUnknownMember unknownMember() { any() }

    /**
     * Gets a property name referred to by the given dynamic property access,
     * allowing one property flow step in the process (to allow flow through imports).
     *
     * This is to support code patterns where the property name is actually constant,
     * but the property name has been factored into a library.
     */
    private string getAnIndirectPropName(DataFlow::PropRef ref) {
      exists(DataFlow::Node pred |
        FlowSteps::propertyFlowStep(pred, ref.getPropertyNameExpr().flow()) and
        result = pred.getStringValue()
      )
    }

    /**
     * Gets unique result of `getAnIndirectPropName` if there is one.
     */
    private string getIndirectPropName(DataFlow::PropRef ref) {
      result = unique(string s | s = getAnIndirectPropName(ref))
    }

    /** Gets the `member` edge label for the given property reference. */
    ApiLabel memberFromRef(DataFlow::PropRef pr) {
      exists(string pn | pn = pr.getPropertyName() or pn = getIndirectPropName(pr) |
        result = member(pn) and
        // only consider properties with alphanumeric(-ish) names, excluding special properties
        // and properties whose names look like they are meant to be internal
        pn.regexpMatch("(?!prototype$|__)[\\w_$][\\w\\-.$]*")
      )
      or
      not exists(pr.getPropertyName()) and
      not exists(getIndirectPropName(pr)) and
      result = unknownMember()
    }

    /** Gets the `instance` edge label. */
    LabelInstance instance() { any() }

    /**
     * Gets the `parameter` edge label for the `i`th parameter.
     *
     * The receiver is considered to be parameter -1.
     */
    LabelParameter parameter(int i) { result.getIndex() = i }

    /** Gets the edge label for the receiver. */
    LabelReceiver receiver() { any() }

    /** Gets the `return` edge label. */
    LabelReturn return() { any() }

    /** Gets the label representing a function wrapper that forwards to an underlying function. */
    LabelForwardingFunction forwardingFunction() { any() }

    /** Gets the `promised` edge label connecting a promise to its contained value. */
    LabelPromised promised() { any() }

    /** Gets the `promisedError` edge label connecting a promise to its rejected value. */
    LabelPromisedError promisedError() { any() }

    /** Gets the label for an edge leading from a value `D` to any class that has `D` as a decorator. */
    LabelDecoratedClass decoratedClass() { any() }

    /** Gets the label for an edge leading from a value `D` to any method, field, or accessor that has `D` as a decorator. */
    LabelDecoratedMethod decoratedMember() { any() }

    /** Gets the label for an edge leading from a value `D` to any parameter that has `D` as a decorator. */
    LabelDecoratedParameter decoratedParameter() { any() }

    /** Gets an entry-point label for the entry-point `e`. */
    LabelEntryPoint entryPoint(API::EntryPoint e) { result.getEntryPoint() = e }

    private import LabelImpl

    private module LabelImpl {
      newtype TLabel =
        MkLabelModule(string mod) {
          exists(Impl::MkModuleExport(mod)) or
          exists(Impl::MkModuleImport(mod))
        } or
        MkLabelInstance() or
        MkLabelMember(string prop) {
          exports(_, prop, _) or
          exists(any(DataFlow::ClassNode c).getInstanceMethod(prop)) or
          prop = "exports" or
          prop = any(CanonicalName c).getName() or
          prop = any(DataFlow::PropRef p).getPropertyName() or
          exists(Impl::MkTypeUse(_, prop)) or
          exists(any(Module m).getAnExportedValue(prop)) or
          PreCallGraphStep::loadStep(_, _, prop) or
          PreCallGraphStep::storeStep(_, _, prop)
        } or
        MkLabelUnknownMember() or
        MkLabelParameter(int i) {
          i =
            [0 .. max(int args |
                args = any(InvokeExpr invk).getNumArgument() or
                args = any(Function f).getNumParameter()
              )] or
          i = [0 .. 10]
        } or
        MkLabelReceiver() or
        MkLabelReturn() or
        MkLabelPromised() or
        MkLabelPromisedError() or
        MkLabelDecoratedClass() or
        MkLabelDecoratedMember() or
        MkLabelDecoratedParameter() or
        MkLabelForwardingFunction() or
        MkLabelEntryPoint(API::EntryPoint e)

      /** A label for an entry-point. */
      class LabelEntryPoint extends ApiLabel, MkLabelEntryPoint {
        API::EntryPoint e;

        LabelEntryPoint() { this = MkLabelEntryPoint(e) }

        /** Gets the EntryPoint associated with this label. */
        API::EntryPoint getEntryPoint() { result = e }

        override string toString() { result = "entryPoint(\"" + e + "\")" }
      }

      /** A label that gets a promised value. */
      class LabelPromised extends ApiLabel, MkLabelPromised {
        override string toString() { result = "getPromised()" }
      }

      /** A label that gets a rejected promise. */
      class LabelPromisedError extends ApiLabel, MkLabelPromisedError {
        override string toString() { result = "getPromisedError()" }
      }

      /** A label that gets the return value of a function. */
      class LabelReturn extends ApiLabel, MkLabelReturn {
        override string toString() { result = "getReturn()" }
      }

      /** A label for a module. */
      class LabelModule extends ApiLabel, MkLabelModule {
        string mod;

        LabelModule() { this = MkLabelModule(mod) }

        /** Gets the module associated with this label. */
        string getMod() { result = mod }

        // moduleImport is not neccesarilly the predicate to use, but it's close enough for most cases.
        override string toString() { result = "moduleImport(\"" + mod + "\")" }
      }

      /** A label that gets an instance from a `new` call. */
      class LabelInstance extends ApiLabel, MkLabelInstance {
        override string toString() { result = "getInstance()" }
      }

      /** A label for the member named `prop`. */
      class LabelMember extends ApiLabel, MkLabelMember {
        string prop;

        LabelMember() { this = MkLabelMember(prop) }

        /** Gets the property associated with this label. */
        string getProperty() { result = prop }

        override string toString() { result = "getMember(\"" + prop + "\")" }
      }

      /** A label for a member with an unknown name. */
      class LabelUnknownMember extends ApiLabel, MkLabelUnknownMember {
        LabelUnknownMember() { this = MkLabelUnknownMember() }

        override string toString() { result = "getUnknownMember()" }
      }

      /** A label for parameter `i`. */
      class LabelParameter extends ApiLabel, MkLabelParameter {
        int i;

        LabelParameter() { this = MkLabelParameter(i) }

        override string toString() { result = "getParameter(" + i + ")" }

        /** Gets the index of the parameter for this label. */
        int getIndex() { result = i }
      }

      /** A label for the receiver of call, that is, the value passed as `this`. */
      class LabelReceiver extends ApiLabel, MkLabelReceiver {
        override string toString() { result = "getReceiver()" }
      }

      /** A label for a function that is a wrapper around another function. */
      class LabelForwardingFunction extends ApiLabel, MkLabelForwardingFunction {
        override string toString() { result = "getForwardingFunction()" }
      }

      /** A label for a class decorated by the current value. */
      class LabelDecoratedClass extends ApiLabel, MkLabelDecoratedClass {
        override string toString() { result = "getADecoratedClass()" }
      }

      /** A label for a method, field, or accessor decorated by the current value. */
      class LabelDecoratedMethod extends ApiLabel, MkLabelDecoratedMember {
        override string toString() { result = "decoratedMember()" }
      }

      /** A label for a parameter decorated by the current value. */
      class LabelDecoratedParameter extends ApiLabel, MkLabelDecoratedParameter {
        override string toString() { result = "decoratedParameter()" }
      }
    }
  }
}

/** Holds if module `m` exports `rhs`. */
private predicate exports(string m, DataFlow::Node rhs) {
  exists(Module mod | mod = importableModule(m) |
    rhs = mod.(AmdModule).getDefine().getModuleExpr().flow()
    or
    not mod.(ES2015Module).hasBothNamedAndDefaultExports() and
    exports(m, "default", rhs)
    or
    exists(ExportAssignDeclaration assgn | assgn.getTopLevel() = mod |
      rhs = assgn.getExpression().flow()
    )
    or
    rhs = mod.(Closure::ClosureModule).getExportsVariable().getAnAssignedExpr().flow()
  )
}

/** Holds if module `m` exports `rhs` under the name `prop`. */
private predicate exports(string m, string prop, DataFlow::Node rhs) {
  exists(ExportDeclaration exp | exp.getEnclosingModule() = importableModule(m) |
    not exp.isTypeOnly() and
    rhs = exp.getSourceNode(prop)
    or
    exists(Variable v |
      exp.exportsAs(v, prop) and
      rhs = v.getAnAssignedExpr().flow()
    )
  )
}

/** Gets the definition of module `m`. */
private Module importableModule(string m) {
  exists(NpmPackage pkg, PackageJson json | json = pkg.getPackageJson() and not json.isPrivate() |
    result = pkg.getMainModule() and
    not result.isExterns() and
    m = pkg.getPackageName()
  )
}
