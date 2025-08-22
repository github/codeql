/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * The nodes of the API graph represent definitions and uses of API components. The edges are
 * directed and labeled; they specify how the components represented by nodes relate to each other.
 */

// Importing python under the `py` namespace to avoid importing `CallNode` from `Flow.qll` and thereby having a naming conflict with `API::CallNode`.
private import python as PY
import semmle.python.dataflow.new.DataFlow
private import semmle.python.internal.CachedStages

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
   * For example, a simplified way to get the first argument of a call to `json.dumps` would be
   * ```ql
   * API::moduleImport("json").getMember("dumps").getParameter(0).asSink()
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
   * (API graphs are designed to work when external libraries are not part of the database,
   * so we do not associate with concrete data-flow nodes from the external library).
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
   * For example, the access path `API::moduleImport("json").getMember("dumps")` represents the action of
   * importing `json` and then accessing the member `dumps` on the resulting object.
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
   * ```python
   * import foo
   * foo.bar(lambda x: doSomething(x))
   * ```
   * A callback is passed to the external function `foo.bar`. We can't know if `foo.bar` will actually invoke this callback.
   * But _if_ the library should decide to invoke the callback, then a value will flow into the current codebase via the `x` parameter.
   * For that reason, an edge is generated representing the argument-passing operation that might be performed by `foo.bar`.
   * This edge is going from the def-node associated with the callback to the use-node associated with the parameter `x`.
   */
  class Node extends Impl::TApiNode {
    /**
     * Gets a data-flow node where this value may flow after entering the current codebase.
     *
     * This is similar to `asSource()` but additionally includes nodes that are transitively reachable by data flow.
     * See `asSource()` for examples.
     */
    DataFlow::Node getAValueReachableFromSource() {
      exists(DataFlow::LocalSourceNode src | Impl::use(this, src) |
        Impl::trackUseNode(src).flowsTo(result)
      )
    }

    /**
     * Gets a data-flow node where this value leaves the current codebase and flows into an
     * external library (or in general, any external codebase).
     *
     * Concretely, this is either an argument passed to a call to external code,
     * or the right-hand side of an attribute write on an object flowing into such a call.
     *
     * For example:
     * ```python
     * import foo
     *
     * # 'x' is matched by API::moduleImport("foo").getMember("bar").getParameter(0).asSink()
     * foo.bar(x)
     *
     * # 'x' is matched by API::moduleImport("foo").getMember("bar").getParameter(0).getMember("prop").asSink()
     * obj.prop = x
     * foo.bar(obj);
     * ```
     *
     * This predicate does not include nodes transitively reaching the sink by data flow;
     * use `getAValueReachingSink` for that.
     */
    DataFlow::Node asSink() { Impl::rhs(this, result) }

    /**
     * Gets a data-flow node that transitively flows to an external library (or in general, any external codebase).
     *
     * This is similar to `asSink()` but additionally includes nodes that transitively reach a sink by data flow.
     * See `asSink()` for examples.
     */
    DataFlow::Node getAValueReachingSink() { result = Impl::trackDefNode(this.asSink()) }

    /**
     * Gets a data-flow node where this value enters the current codebase.
     *
     * For example:
     * ```python
     * # API::moduleImport("re").asSource()
     * import re
     *
     * # API::moduleImport("re").getMember("escape").asSource()
     * re.escape
     *
     * # API::moduleImport("re").getMember("escape").getReturn().asSource()
     * re.escape()
     * ```
     *
     * This predicate does not include nodes transitively reachable by data flow;
     * use `getAValueReachableFromSource` for that.
     */
    DataFlow::LocalSourceNode asSource() { Impl::use(this, result) }

    /**
     * Gets a call to the function represented by this API component.
     */
    CallNode getACall() { result = this.getReturn().asSource() }

    /**
     * Gets a node representing member `m` of this API component.
     *
     * For example, a member can be:
     *
     * - A submodule of a module
     * - An attribute of an object
     */
    bindingset[m]
    bindingset[result]
    Node getMember(string m) { result = this.getASuccessor(Label::member(m)) }

    /**
     * Gets a node representing a member of this API component where the name of the member is
     * not known statically.
     */
    Node getUnknownMember() { result = this.getASuccessor(Label::unknownMember()) }

    /**
     * Gets a node representing a member of this API component where the name of the member may
     * or may not be known statically.
     */
    Node getAMember() {
      result = this.getASuccessor(Label::member(_)) or
      result = this.getUnknownMember()
    }

    /**
     * Gets a node representing the result of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getACall()` if there is a need to distinguish between individual calls.
     */
    Node getReturn() { result = this.getASuccessor(Label::return()) }

    /**
     * Gets a node representing instances of the class represented by this node, as specified via
     * type annotations.
     */
    Node getInstanceFromAnnotation() { result = this.getASuccessor(Label::annotation()) }

    /**
     * Gets a node representing the `i`th parameter of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distinguish between individual calls.
     */
    Node getParameter(int i) { result = this.getASuccessor(Label::parameter(i)) }

    /**
     * Gets the node representing the keyword parameter `name` of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distinguish between individual calls.
     */
    Node getKeywordParameter(string name) {
      result = this.getASuccessor(Label::keywordParameter(name))
    }

    /** Gets the node representing the self parameter */
    Node getSelfParameter() { result = this.getASuccessor(Label::selfParameter()) }

    /**
     * Gets the number of parameters of the function represented by this node.
     */
    int getNumParameter() { result = max(int s | exists(this.getParameter(s))) + 1 }

    /**
     * Gets a node representing a subclass of the class represented by this node.
     */
    Node getASubclass() { result = this.getASuccessor(Label::subclass()) }

    /**
     * Gets a node representing an instance of the class (or a transitive subclass of the class) represented by this node.
     */
    Node getAnInstance() {
      result in [this.getASubclass*().getReturn(), this.getASubclass*().getInstanceFromAnnotation()]
    }

    /**
     * Gets a node representing the result from awaiting this node.
     */
    Node getAwaited() { result = this.getASuccessor(Label::await()) }

    /**
     * Gets a node representing a subscript of this node.
     * For example `obj[x]` is a subscript of `obj`.
     */
    Node getASubscript() { result = this.getASuccessor(Label::subscript()) }

    /**
     * Gets a node representing an index of a subscript of this node.
     * For example, in `obj[x]`, `x` is an index of `obj`.
     */
    Node getIndex() { result = this.getASuccessor(Label::index()) }

    /**
     * Gets a node representing a subscript of this node at (string) index `key`.
     * This requires that the index can be statically determined.
     *
     * For example, the subscripts of `a` and `b` below would be found using
     * the index `foo`:
     * ```py
     * a["foo"]
     * x = "foo" if cond else "bar"
     * b[x]
     * ```
     */
    Node getSubscript(string key) {
      exists(API::Node index | result = this.getSubscriptAt(index) |
        key = index.getAValueReachingSink().asExpr().(PY::StringLiteral).getText()
      )
    }

    /**
     * Gets a node representing a subscript of this node at index `index`.
     */
    Node getSubscriptAt(API::Node index) {
      result = this.getASubscript() and
      index = this.getIndex() and
      (
        // subscripting
        exists(PY::SubscriptNode subscript |
          subscript.getObject() = this.getAValueReachableFromSource().asCfgNode() and
          subscript.getIndex() = index.asSink().asCfgNode()
        |
          // reading
          subscript = result.asSource().asCfgNode()
          or
          // writing
          subscript.(PY::DefinitionNode).getValue() = result.asSink().asCfgNode()
        )
        or
        // dictionary literals
        exists(PY::Dict dict, PY::KeyValuePair item |
          dict = this.getAValueReachingSink().asExpr() and
          dict.getItem(_) = item and
          item.getKey() = index.asSink().asExpr()
        |
          item.getValue() = result.asSink().asExpr()
        )
      )
    }

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
     * Gets the data-flow node that gives rise to this node, if any.
     */
    DataFlow::Node getInducingNode() { this = Impl::MkUse(result) or this = Impl::MkDef(result) }

    /** Gets the location of this node */
    PY::Location getLocation() { result = this.getInducingNode().getLocation() }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    deprecated predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getInducingNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      or
      // For nodes that do not have a meaningful location, `path` is the empty string and all other
      // parameters are zero.
      not exists(this.getInducingNode()) and
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }

    /**
     * Gets a textual representation of this element.
     */
    abstract string toString();

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

  /** A node corresponding to the use of an API component. */
  class Use extends Node, Impl::TUse {
    override string toString() {
      exists(string type |
        this = Impl::MkUse(_) and type = "Use "
        or
        this = Impl::MkModuleImport(_) and type = "ModuleImport "
      |
        result = type + this.getPath()
        or
        not exists(this.getPath()) and result = type + "with no path"
      )
    }
  }

  /** A node corresponding to the rhs of an API component. */
  class Def extends Node, Impl::TDef {
    override string toString() {
      exists(string type | this = Impl::MkDef(_) and type = "Def " |
        result = type + this.getPath()
        or
        not exists(this.getPath()) and result = type + "with no path"
      )
    }
  }

  /** Gets the root node. */
  Root root() { any() }

  /**
   * Gets a node corresponding to an import of module `m`.
   *
   * Note: You should only use this predicate for top level modules. If you want nodes corresponding to a submodule,
   * you should use `.getMember` on the parent module. For example, for nodes corresponding to the module `foo.bar`,
   * use `moduleImport("foo").getMember("bar")`.
   */
  Node moduleImport(string m) {
    result = Impl::MkModuleImport(m) and
    // restrict `moduleImport` so it will never give results for a dotted name. Note
    // that we cannot move this logic to the `MkModuleImport` construction, since we
    // need the intermediate API graph nodes for the prefixes in `import foo.bar.baz`.
    not m.matches("%.%")
  }

  /**
   * Holds if an import of module `m` exists.
   *
   * This is determined without referring to `Node`,
   * allowing this predicate to be used in a negative
   * context when constructing new nodes.
   */
  predicate moduleImportExists(string m) {
    Impl::isImported(m) and
    // restrict `moduleImport` so it will never give results for a dotted name. Note
    // that we cannot move this logic to the `MkModuleImport` construction, since we
    // need the intermediate API graph nodes for the prefixes in `import foo.bar.baz`.
    not m.matches("%.%")
  }

  /** Gets a node corresponding to the built-in with the given name, if any. */
  Node builtin(string n) { result = moduleImport("builtins").getMember(n) }

  /**
   * A `CallCfgNode` that is connected to the API graph.
   *
   * Can be used to reason about calls to an external API in which the correlation between
   * parameters and/or return values must be retained.
   *
   * The member predicates `getParameter`, `getKeywordParameter`, `getReturn`, and `getInstance` mimic
   * the corresponding predicates from `API::Node`. These are guaranteed to exist and be unique to this call.
   */
  class CallNode extends DataFlow::CallCfgNode {
    API::Node callee;

    CallNode() { this = callee.getReturn().asSource() }

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
    private Node getAParameterCandidate(int i) { result.asSink() = this.getArg(i) }

    /** Gets the API node for a parameter of this invocation. */
    Node getAParameter() { result = this.getParameter(_) }

    /** Gets the object that this method-call is being called on, if this is a method-call */
    Node getSelfParameter() {
      result.asSink() = this.(DataFlow::MethodCallNode).getObject() and
      result = callee.getSelfParameter()
    }

    /** Gets the API node for the keyword parameter `name` of this invocation. */
    Node getKeywordParameter(string name) {
      result = callee.getKeywordParameter(name) and
      result = this.getAKeywordParameterCandidate(name)
    }

    /** Gets the API node for the parameter that has index `i` or has keyword `name`. */
    bindingset[i, name]
    Node getParameter(int i, string name) {
      result = this.getParameter(i)
      or
      result = this.getKeywordParameter(name)
    }

    pragma[noinline]
    private Node getAKeywordParameterCandidate(string name) {
      result.asSink() = this.getArgByName(name)
    }

    /** Gets the API node for the return value of this call. */
    Node getReturn() {
      result = callee.getReturn() and
      result.asSource() = this
    }

    /**
     * Gets the number of positional arguments of this call.
     *
     * Note: This is used for `WithArity[<n>]` in modeling-as-data, where we thought
     * including keyword arguments didn't make much sense.
     */
    int getNumArgument() { result = count(this.getArg(_)) }
  }

  /**
   * An API entry point.
   *
   * By default, API graph nodes are only created for nodes that come from an external
   * library or escape into an external library. The points where values are cross the boundary
   * between codebases are called "entry points".
   *
   * Anything imported from an external package is considered to be an entry point, but
   * additional entry points may be added by extending this class.
   */
  abstract class EntryPoint extends string {
    bindingset[this]
    EntryPoint() { any() }

    /** Gets a data-flow node corresponding to a use-node for this entry point. */
    DataFlow::LocalSourceNode getASource() { none() }

    /** Gets a data-flow node corresponding to a def-node for this entry point. */
    DataFlow::Node getASink() { none() }

    /** Gets an API-node for this entry point. */
    API::Node getANode() { result = root().getASuccessor(Label::entryPoint(this)) }
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
    /*
     * Modeling imports is slightly tricky because of the way we handle dotted name imports in our
     * libraries. In dotted imports such as
     *
     * ```python
     * import foo.bar.baz as fbb
     * from foo.bar.baz import quux as fbbq
     * ```
     *
     * the dotted name is simply represented as a string. We would like `fbb.quux` and `fbbq` to
     * be represented as API graph nodes with the following path:
     *
     * ```ql
     * moduleImport("foo").getMember("bar").getMember("baz").getMember("quux")
     * ```
     *
     * To do this, we produce an API graph node for each dotted name prefix we find in the set of
     * imports. Thus, for the above two imports, we would get nodes for
     *
     * ```python
     * foo
     * foo.bar
     * foo.bar.baz
     * ```
     *
     * Only the first of these can act as the beginning of a path (and become a
     * `moduleImport`-labeled edge from the global root node).
     *
     * (Using prefixes rather than simply `foo`, `bar`, and `baz` is important. We don't want
     * potential crosstalk between `foo.bar.baz` and `ham.bar.eggs`.)
     *
     * We then add `getMember` edges between these prefixes: `foo` steps to `foo.bar` via an edge
     * labeled `getMember("bar")` and so on.
     *
     * When we then see `import foo.bar.baz as fbb`, the data-flow node `fbb` gets marked as a use
     * of the API graph node corresponding to the prefix `foo.bar.baz`. Because of the edges leading to
     * this node, it is reachable via `moduleImport("foo").getMember("bar").getMember("baz")` and
     * thus `fbb.quux` is reachable via the path mentioned above.
     *
     * When we see `from foo.bar.baz import quux as fbbq` a similar thing happens. First, `foo.bar.baz`
     * is seen as a use of the API graph node as before. Then `import quux as fbbq` is seen as
     * a member lookup of `quux` on the API graph node for `foo.bar.baz`, and then finally the
     * data-flow node `fbbq` is marked as a use of the same path mentioned above.
     *
     * Finally, in a non-aliased import such as
     *
     * ```python
     * import foo.bar.baz
     * ```
     *
     * we only consider this as a definition of the name `foo` (thus making it a use of the corresponding
     * API graph node for the prefix `foo`), in accordance with the usual semantics of Python.
     */

    cached
    newtype TApiNode =
      /** The root of the API graph. */
      MkRoot() or
      /** An abstract representative for imports of the module called `name`. */
      MkModuleImport(string name) {
        // Ignore the following module name for Python 2, as we alias `__builtin__` to `builtins` elsewhere
        (name != "__builtin__" or PY::major_version() = 3) and
        (
          imports(_, name)
          or
          // When we `import foo.bar.baz` we want to create API graph nodes also for the prefixes
          // `foo` and `foo.bar`:
          name = any(PY::ImportExpr e | not e.isRelative()).getAnImportedModuleName()
        )
        or
        // The `builtins` module should always be implicitly available
        name = "builtins"
      } or
      /** A use of an API member at the node `nd`. */
      MkUse(DataFlow::Node nd) { use(_, _, nd) } or
      MkDef(DataFlow::Node nd) { rhs(_, _, nd) }

    class TUse = MkModuleImport or MkUse;

    class TDef = MkDef;

    /**
     * Holds if the dotted module name `sub` refers to the `member` member of `base`.
     *
     * For instance, `prefix_member("foo.bar", "baz", "foo.bar.baz")` would hold.
     */
    cached
    predicate prefix_member(TApiNode base, string member, TApiNode sub) {
      exists(string sub_str, string regexp |
        regexp = "(.+)[.]([^.]+)" and
        base = MkModuleImport(sub_str.regexpCapture(regexp, 1)) and
        member = sub_str.regexpCapture(regexp, 2) and
        sub = MkModuleImport(sub_str)
      )
    }

    /**
     * Holds if `imp` is a data-flow node inside an import statement that refers to a module by the
     * name `name`.
     *
     * Ignores relative imports, such as `from ..foo.bar import baz`.
     */
    private predicate imports(DataFlow::CfgNode imp, string name) {
      exists(PY::ImportExprNode iexpr |
        imp.getNode() = iexpr and
        not iexpr.getNode().isRelative() and
        name = iexpr.getNode().getImportedModuleName()
      )
    }

    /**
     * Holds if the module `name` is imported.
     *
     * This is determined syntactically.
     */
    cached
    predicate isImported(string name) {
      // Ignore the following module name for Python 2, as we alias `__builtin__` to `builtins` elsewhere
      (name != "__builtin__" or PY::major_version() = 3) and
      (
        exists(PY::ImportExpr iexpr |
          not iexpr.isRelative() and
          name = iexpr.getImportedModuleName()
        )
        or
        // When we `import foo.bar.baz` we want to create API graph nodes also for the prefixes
        // `foo` and `foo.bar`:
        name = any(PY::ImportExpr e | not e.isRelative()).getAnImportedModuleName()
      )
      or
      // The `builtins` module should always be implicitly available
      name = "builtins"
    }

    private import semmle.python.dataflow.new.internal.Builtins
    private import semmle.python.dataflow.new.internal.ImportStar

    /**
     * Gets the API graph node for all modules imported with `from ... import *` inside the scope `s`.
     *
     * For example, given
     *
     * ```python
     * from foo.bar import *
     * ```
     *
     * this would be the API graph node with the path
     *
     * `moduleImport("foo").getMember("bar")`
     */
    private TApiNode potential_import_star_base(PY::Scope s) {
      exists(DataFlow::Node n |
        n.(DataFlow::CfgNode).getNode() = ImportStar::potentialImportStarBase(s) and
        use(result, n)
      )
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of a node that should have an
     * incoming edge from `base` labeled `lbl` in the API graph.
     */
    cached
    predicate rhs(TApiNode base, Label::ApiLabel lbl, DataFlow::Node rhs) {
      exists(DataFlow::Node def, DataFlow::LocalSourceNode pred |
        rhs(base, def) and pred = trackDefNode(def)
      |
        // from `x` to a definition of `x.prop`
        exists(DataFlow::AttrWrite aw | aw = pred.getAnAttributeWrite() |
          lbl = Label::memberFromRef(aw) and
          rhs = aw.getValue()
        )
        or
        // dictionary literals
        exists(PY::Dict dict, PY::KeyValuePair item |
          dict = pred.(DataFlow::ExprNode).getNode().getNode() and
          dict.getItem(_) = item
        |
          // from `x` to `{ "key": x }`
          // TODO: once convenient, this should be done at a higher level than the AST,
          // at least at the CFG layer, to take splitting into account.
          rhs.(DataFlow::ExprNode).getNode().getNode() = item.getValue() and
          lbl = Label::subscript()
          or
          // from `"key"` to `{ "key": x }`
          // TODO: once convenient, this should be done at a higher level than the AST,
          // at least at the CFG layer, to take splitting into account.
          rhs.(DataFlow::ExprNode).getNode().getNode() = item.getKey() and
          lbl = Label::index()
        )
        or
        // list literals, from `x` to `[x]`
        // TODO: once convenient, this should be done at a higher level than the AST,
        // at least at the CFG layer, to take splitting into account.
        // Also consider `SequenceNode for generality.
        exists(PY::List list | list = pred.(DataFlow::ExprNode).getNode().getNode() |
          rhs.(DataFlow::ExprNode).getNode().getNode() = list.getAnElt() and
          lbl = Label::subscript()
        )
        or
        exists(PY::CallableExpr fn | fn = pred.(DataFlow::ExprNode).getNode().getNode() |
          not fn.getInnerScope().isAsync() and
          lbl = Label::return() and
          exists(PY::Return ret |
            rhs.(DataFlow::ExprNode).getNode().getNode() = ret.getValue() and
            ret.getScope() = fn.getInnerScope()
          )
        )
      )
      or
      argumentPassing(base, lbl, rhs)
      or
      exists(DataFlow::LocalSourceNode src, DataFlow::AttrWrite aw |
        use(base, src) and aw = trackUseNode(src).getAnAttributeWrite() and rhs = aw.getValue()
      |
        lbl = Label::memberFromRef(aw)
      )
      or
      // subscripting
      exists(DataFlow::LocalSourceNode src, DataFlow::Node subscript, DataFlow::Node index |
        use(base, src) and
        subscript = trackUseNode(src).getSubscript(index)
      |
        // from `x` to a definition of `x[...]`
        rhs.asCfgNode() = subscript.asCfgNode().(PY::DefinitionNode).getValue() and
        lbl = Label::subscript()
        or
        // from `x` to `"key"` in `x["key"]`
        rhs = index and
        lbl = Label::index()
      )
      or
      exists(EntryPoint entry |
        base = root() and
        lbl = Label::entryPoint(entry) and
        rhs = entry.getASink()
      )
    }

    /**
     * Holds if `ref` is a use of a node that should have an incoming edge from `base` labeled
     * `lbl` in the API graph.
     */
    cached
    predicate use(TApiNode base, Label::ApiLabel lbl, DataFlow::Node ref) {
      exists(DataFlow::LocalSourceNode src, DataFlow::LocalSourceNode pred |
        // First, we find a predecessor of the node `ref` that we want to determine. The predecessor
        // is any node that is a type-tracked use of a data flow node (`src`), which is itself a
        // reference to the API node `base`. Thus, `pred` and `src` both represent uses of `base`.
        //
        // Once we have identified the predecessor, we define its relation to the successor `ref` as
        // well as the label on the edge from `pred` to `ref`. This label describes the nature of
        // the relationship between `pred` and `ref`.
        use(base, src) and pred = trackUseNode(src)
      |
        // Referring to an attribute on a node that is a use of `base`:
        lbl = Label::memberFromRef(ref) and
        ref = pred.getAnAttributeRead()
        or
        // Calling a node that is a use of `base`
        lbl = Label::return() and
        ref = pred.getACall()
        or
        // Getting an instance via a type annotation
        lbl = Label::annotation() and
        ref = pred.getAnAnnotatedInstance()
        or
        // Awaiting a node that is a use of `base`
        lbl = Label::await() and
        ref = pred.getAnAwaited()
        or
        // Subscripting a node that is a use of `base`
        lbl = Label::subscript() and
        ref = pred.getSubscript(_) and
        ref.asCfgNode().isLoad()
        or
        // Subscript via comprehension
        lbl = Label::subscript() and
        exists(PY::Comp comp |
          pred.asExpr() = comp.getIterable() and
          ref.asExpr() = comp.getNthInnerLoop(0).getTarget()
        )
        or
        // Subclassing a node
        lbl = Label::subclass() and
        exists(PY::ClassExpr clsExpr, DataFlow::Node superclass | pred.flowsTo(superclass) |
          clsExpr.getABase() = superclass.asExpr() and
          // Potentially a class decorator could do anything, but we assume they are
          // "benign" and let subclasses edges flow through anyway.
          // see example in https://github.com/django/django/blob/c2250cfb80e27cdf8d098428824da2800a18cadf/tests/auth_tests/test_views.py#L40-L46
          (
            ref.(DataFlow::ExprNode).getNode().getNode() = clsExpr
            or
            ref.(DataFlow::ExprNode).getNode().getNode() = clsExpr.getADecoratorCall()
          )
        )
      )
      or
      exists(DataFlow::Node def, PY::CallableExpr fn |
        rhs(base, def) and fn = trackDefNode(def).(DataFlow::ExprNode).getNode().getNode()
      |
        exists(int i, int offset |
          if exists(PY::Parameter p | p = fn.getInnerScope().getAnArg() and p.isSelf())
          then offset = 1
          else offset = 0
        |
          lbl = Label::parameter(i - offset) and
          ref.(DataFlow::ExprNode).getNode().getNode() = fn.getInnerScope().getArg(i)
        )
        or
        exists(string name, PY::Parameter param |
          lbl = Label::keywordParameter(name) and
          param = fn.getInnerScope().getArgByName(name) and
          not param.isSelf() and
          ref.(DataFlow::ExprNode).getNode().getNode() = param
        )
        or
        lbl = Label::selfParameter() and
        ref.(DataFlow::ExprNode).getNode().getNode() =
          any(PY::Parameter p | p = fn.getInnerScope().getAnArg() and p.isSelf())
      )
      or
      // Built-ins, treated as members of the module `builtins`
      base = MkModuleImport("builtins") and
      lbl = Label::member(any(string name | ref = Builtins::likelyBuiltin(name)))
      or
      // Unknown variables that may belong to a module imported with `import *`
      exists(PY::Scope s |
        base = potential_import_star_base(s) and
        lbl =
          Label::member(any(string name |
              ImportStar::namePossiblyDefinedInImportStar(ref.(DataFlow::CfgNode).getNode(), name, s)
            ))
      )
      or
      exists(EntryPoint entry |
        base = root() and
        lbl = Label::entryPoint(entry) and
        ref = entry.getASource()
      )
    }

    /**
     * Holds if `ref` is a use of node `nd`.
     */
    cached
    predicate use(TApiNode nd, DataFlow::Node ref) {
      exists(string name |
        nd = MkModuleImport(name) and
        imports(ref, name)
      )
      or
      // Ensure the Python 2 `__builtin__` module gets the name of the Python 3 `builtins` module.
      PY::major_version() = 2 and
      nd = MkModuleImport("builtins") and
      imports(ref, "__builtin__")
      or
      nd = MkUse(ref)
    }

    /**
     * Gets a data-flow node to which `src`, which is a use of an API-graph node, flows.
     *
     * The flow from `src` to that node may be inter-procedural.
     */
    private DataFlow::TypeTrackingNode trackUseNode(
      DataFlow::LocalSourceNode src, DataFlow::TypeTracker t
    ) {
      t.start() and
      use(_, src) and
      result = src
      or
      exists(DataFlow::TypeTracker t2 | result = trackUseNode(src, t2).track(t2, t))
    }

    /**
     * Holds if `arg` is passed as an argument to a use of `base`.
     *
     * `lbl` is represents which parameter of the function was passed. Either a numbered parameter, or a keyword parameter.
     */
    private predicate argumentPassing(TApiNode base, Label::ApiLabel lbl, DataFlow::Node arg) {
      exists(DataFlow::Node use, DataFlow::LocalSourceNode pred |
        use(base, use) and pred = trackUseNode(use)
      |
        exists(int i |
          lbl = Label::parameter(i) and
          arg = pred.getACall().getArg(i)
        )
        or
        exists(string name | lbl = Label::keywordParameter(name) |
          arg = pred.getACall().getArgByName(name)
        )
        or
        lbl = Label::selfParameter() and
        arg = pred.getACall().(DataFlow::MethodCallNode).getObject()
      )
    }

    /**
     * Gets a node that inter-procedurally flows into `nd`, which is a definition of some node.
     */
    cached
    DataFlow::LocalSourceNode trackDefNode(DataFlow::Node nd) {
      result = trackDefNode(nd, DataFlow::TypeBackTracker::end())
    }

    private DataFlow::LocalSourceNode trackDefNode(DataFlow::Node nd, DataFlow::TypeBackTracker t) {
      t.start() and
      rhs(_, nd) and
      result = nd.getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = trackDefNode(nd, t2).backtrack(t2, t))
    }

    /**
     * Gets a data-flow node to which `src`, which is a use of an API-graph node, flows.
     *
     * The flow from `src` to that node may be inter-procedural.
     */
    cached
    DataFlow::LocalSourceNode trackUseNode(DataFlow::LocalSourceNode src) {
      Stages::TypeTracking::ref() and
      result = trackUseNode(src, DataFlow::TypeTracker::end()) and
      result instanceof DataFlow::LocalSourceNodeNotModuleVariableNode
    }

    /**
     * Holds if `rhs` is the right-hand side of a definition of node `nd`.
     */
    cached
    predicate rhs(TApiNode nd, DataFlow::Node rhs) { nd = MkDef(rhs) }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(TApiNode pred, Label::ApiLabel lbl, TApiNode succ) {
      /* There's an edge from the root node for each imported module. */
      exists(string m |
        pred = MkRoot() and
        lbl = Label::mod(m) and
        succ = MkModuleImport(m) and
        // Only allow undotted names to count as base modules.
        not m.matches("%.%")
      )
      or
      /* Step from the dotted module name `foo.bar` to `foo.bar.baz` along an edge labeled `baz` */
      exists(string member |
        prefix_member(pred, member, succ) and
        lbl = Label::member(member)
      )
      or
      /* Every node that is a use of an API component is itself added to the API graph. */
      exists(DataFlow::LocalSourceNode ref |
        use(pred, lbl, ref) and
        succ = MkUse(ref)
      )
      or
      exists(DataFlow::Node rhs |
        rhs(pred, lbl, rhs) and
        succ = MkDef(rhs)
      )
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph.
     */
    private predicate edge(TApiNode pred, TApiNode succ) { edge(pred, _, succ) }

    /** Gets the shortest distance from the root to `nd` in the API graph. */
    cached
    int distanceFromRoot(TApiNode nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)
  }

  /** Provides classes modeling the various edges (labels) in the API graph. */
  module Label {
    /** A label in the API-graph */
    class ApiLabel extends TLabel {
      /** Gets a string representation of this label. */
      string toString() { result = "???" }
    }

    private import LabelImpl

    private module LabelImpl {
      private import semmle.python.dataflow.new.internal.Builtins
      private import semmle.python.dataflow.new.internal.ImportStar

      newtype TLabel =
        MkLabelModule(string mod) {
          exists(Impl::MkModuleImport(mod)) and
          not mod.matches("%.%") // only top level modules count as base modules
        } or
        MkLabelMember(string member) {
          member = any(DataFlow::AttrRef pr).getAttributeName() or
          exists(Builtins::likelyBuiltin(member)) or
          ImportStar::namePossiblyDefinedInImportStar(_, member, _) or
          Impl::prefix_member(_, member, _)
        } or
        MkLabelUnknownMember() or
        MkLabelParameter(int i) {
          exists(any(DataFlow::CallCfgNode c).getArg(i))
          or
          exists(any(PY::Function f).getArg(i))
        } or
        MkLabelKeywordParameter(string name) {
          exists(any(DataFlow::CallCfgNode c).getArgByName(name))
          or
          exists(any(PY::Function f).getArgByName(name))
        } or
        MkLabelSelfParameter() or
        MkLabelReturn() or
        MkLabelAnnotation() or
        MkLabelSubclass() or
        MkLabelAwait() or
        MkLabelSubscript() or
        MkLabelIndex() or
        MkLabelEntryPoint(EntryPoint ep)

      /** A label for a module. */
      class LabelModule extends ApiLabel, MkLabelModule {
        string mod;

        LabelModule() { this = MkLabelModule(mod) }

        /** Gets the module associated with this label. */
        string getMod() { result = mod }

        override string toString() { result = "moduleImport(\"" + mod + "\")" }
      }

      /** A label for the member named `prop`. */
      class LabelMember extends ApiLabel, MkLabelMember {
        string member;

        LabelMember() { this = MkLabelMember(member) }

        /** Gets the property associated with this label. */
        string getMember() { result = member }

        override string toString() { result = "getMember(\"" + member + "\")" }
      }

      /** A label for a member with an unknown name. */
      class LabelUnknownMember extends ApiLabel, MkLabelUnknownMember {
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

      /** A label for a keyword parameter `name`. */
      class LabelKeywordParameter extends ApiLabel, MkLabelKeywordParameter {
        string name;

        LabelKeywordParameter() { this = MkLabelKeywordParameter(name) }

        override string toString() { result = "getKeywordParameter(\"" + name + "\")" }

        /** Gets the name of the parameter for this label. */
        string getName() { result = name }
      }

      /** A label for the self parameter. */
      class LabelSelfParameter extends ApiLabel, MkLabelSelfParameter {
        override string toString() { result = "getSelfParameter()" }
      }

      /** A label that gets the return value of a function. */
      class LabelReturn extends ApiLabel, MkLabelReturn {
        override string toString() { result = "getReturn()" }
      }

      /** A label for annotations. */
      class LabelAnnotation extends ApiLabel, MkLabelAnnotation {
        override string toString() { result = "getAnnotatedInstance()" }
      }

      /** A label that gets the subclass of a class. */
      class LabelSubclass extends ApiLabel, MkLabelSubclass {
        override string toString() { result = "getASubclass()" }
      }

      /** A label for awaited values. */
      class LabelAwait extends ApiLabel, MkLabelAwait {
        override string toString() { result = "getAwaited()" }
      }

      /** A label that gets the subscript of a sequence/mapping. */
      class LabelSubscript extends ApiLabel, MkLabelSubscript {
        override string toString() { result = "getASubscript()" }
      }

      /** A label that gets the index of a subscript. */
      class LabelIndex extends ApiLabel, MkLabelIndex {
        override string toString() { result = "getIndex()" }
      }

      /** A label for entry points. */
      class LabelEntryPoint extends ApiLabel, MkLabelEntryPoint {
        private EntryPoint entry;

        LabelEntryPoint() { this = MkLabelEntryPoint(entry) }

        override string toString() { result = "entryPoint(\"" + entry + "\")" }
      }
    }

    /** Gets the edge label for the module `m`. */
    LabelModule mod(string m) { result.getMod() = m }

    /** Gets the `member` edge label for member `m`. */
    LabelMember member(string m) { result.getMember() = m }

    /** Gets the `member` edge label for the unknown member. */
    LabelUnknownMember unknownMember() { any() }

    /** Gets the `member` edge label for the given attribute reference. */
    ApiLabel memberFromRef(DataFlow::AttrRef ref) {
      result = member(ref.getAttributeName())
      or
      ref.unknownAttribute() and
      result = unknownMember()
    }

    /** Gets the `parameter` edge label for parameter `i`. */
    LabelParameter parameter(int i) { result.getIndex() = i }

    /** Gets the `parameter` edge label for the keyword parameter `name`. */
    LabelKeywordParameter keywordParameter(string name) { result.getName() = name }

    /** Gets the edge label for the self parameter. */
    LabelSelfParameter selfParameter() { any() }

    /** Gets the `return` edge label. */
    LabelReturn return() { any() }

    /** Gets the `annotation` edge label. */
    LabelAnnotation annotation() { any() }

    /** Gets the `subclass` edge label. */
    LabelSubclass subclass() { any() }

    /** Gets the `await` edge label. */
    LabelAwait await() { any() }

    /** Gets the `subscript` edge label. */
    LabelSubscript subscript() { any() }

    /** Gets the `subscript` edge label. */
    LabelIndex index() { any() }

    /** Gets the label going from the root node to the nodes associated with the given entry point. */
    LabelEntryPoint entryPoint(EntryPoint ep) { result = MkLabelEntryPoint(ep) }
  }
}
