/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * The nodes of the API graph represent definitions and uses of API components. The edges are
 * directed and labeled; they specify how the components represented by nodes relate to each other.
 */

private import python
import semmle.python.dataflow.new.DataFlow

/**
 * Provides classes and predicates for working with APIs used in a database.
 */
module API {
  /**
   * An abstract representation of a definition or use of an API component such as a function
   * exported by a Python package, or its result.
   */
  class Node extends Impl::TApiNode {
    /**
     * Gets a data-flow node corresponding to a use of the API component represented by this node.
     *
     * For example, `import re; re.escape` is a use of the `escape` function from the
     * `re` module, and `import re; re.escape("hello")` is a use of the return of that function.
     *
     * This includes indirect uses found via data flow, meaning that in
     * ```python
     * def f(x):
     *     pass
     *
     * f(obj.foo)
     * ```
     * both `obj.foo` and `x` are uses of the `foo` member from `obj`.
     */
    DataFlow::Node getAUse() {
      exists(DataFlow::LocalSourceNode src | Impl::use(this, src) |
        Impl::trackUseNode(src).flowsTo(result)
      )
    }

    /**
     * Gets an immediate use of the API component represented by this node.
     *
     * For example, `import re; re.escape` is a an immediate use of the `escape` member
     * from the `re` module.
     *
     * Unlike `getAUse()`, this predicate only gets the immediate references, not the indirect uses
     * found via data flow. This means that in `x = re.escape` only `re.escape` is a reference
     * to the `escape` member of `re`, neither `x` nor any node that `x` flows to is a reference to
     * this API component.
     */
    DataFlow::LocalSourceNode getAnImmediateUse() { Impl::use(this, result) }

    /**
     * Gets a call to the function represented by this API component.
     */
    DataFlow::CallCfgNode getACall() { result = this.getReturn().getAnImmediateUse() }

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
     * Gets a node representing a subclass of the class represented by this node.
     */
    Node getASubclass() { result = this.getASuccessor(Label::subclass()) }

    /**
     * Gets a node representing the result from awaiting this node.
     */
    Node getAwaited() { result = this.getASuccessor(Label::await()) }

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
    Node getASuccessor(string lbl) { Impl::edge(this, lbl, result) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one, and that edge is labeled with `lbl`
     */
    Node getAPredecessor(string lbl) { this = result.getASuccessor(lbl) }

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
    DataFlow::Node getInducingNode() { this = Impl::MkUse(result) }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
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
      exists(Node pred, string lbl, string predpath |
        Impl::edge(pred, lbl, this) and
        lbl != "" and
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

  /** Gets the root node. */
  Root root() { any() }

  /**
   * Gets a node corresponding to an import of module `m`.
   *
   * Note: You should only use this predicate for top level modules. If you want nodes corresponding to a submodule,
   * you should use `.getMember` on the parent module. For example, for nodes corresponding to the module `foo.bar`,
   * use `moduleImport("foo").getMember("bar")`.
   */
  Node moduleImport(string m) { result = Impl::MkModuleImport(m) }

  /** Gets a node corresponding to the built-in with the given name, if any. */
  Node builtin(string n) { result = moduleImport("builtins").getMember(n) }

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

    private import semmle.python.internal.Awaited

    cached
    newtype TApiNode =
      /** The root of the API graph. */
      MkRoot() or
      /** An abstract representative for imports of the module called `name`. */
      MkModuleImport(string name) {
        // Ignore the following module name for Python 2, as we alias `__builtin__` to `builtins` elsewhere
        (name != "__builtin__" or major_version() = 3) and
        (
          imports(_, name)
          or
          // When we `import foo.bar.baz` we want to create API graph nodes also for the prefixes
          // `foo` and `foo.bar`:
          name = any(ImportExpr e | not e.isRelative()).getAnImportedModuleName()
        )
        or
        // The `builtins` module should always be implicitly available
        name = "builtins"
      } or
      /** A use of an API member at the node `nd`. */
      MkUse(DataFlow::Node nd) { use(_, _, nd) }

    class TUse = MkModuleImport or MkUse;

    /**
     * Holds if the dotted module name `sub` refers to the `member` member of `base`.
     *
     * For instance, `prefix_member("foo.bar", "baz", "foo.bar.baz")` would hold.
     */
    private predicate prefix_member(TApiNode base, string member, TApiNode sub) {
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
    private predicate imports(DataFlow::Node imp, string name) {
      exists(ImportExprNode iexpr |
        imp.asCfgNode() = iexpr and
        not iexpr.getNode().isRelative() and
        name = iexpr.getNode().getImportedModuleName()
      )
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
    private TApiNode potential_import_star_base(Scope s) {
      exists(DataFlow::Node n |
        n.asCfgNode() = ImportStar::potentialImportStarBase(s) and
        use(result, n)
      )
    }

    /**
     * Holds if `ref` is a use of a node that should have an incoming edge from `base` labeled
     * `lbl` in the API graph.
     */
    cached
    predicate use(TApiNode base, string lbl, DataFlow::Node ref) {
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
        ref = pred.getAnAttributeReference()
        or
        // Calling a node that is a use of `base`
        lbl = Label::return() and
        ref = pred.getACall()
        or
        // Subclassing a node
        lbl = Label::subclass() and
        exists(DataFlow::Node superclass | pred.flowsTo(superclass) |
          ref.asExpr().(ClassExpr).getABase() = superclass.asExpr()
        )
        or
        // awaiting
        exists(DataFlow::Node awaitedValue |
          lbl = Label::await() and
          ref = awaited(awaitedValue) and
          pred.flowsTo(awaitedValue)
        )
      )
      or
      // Built-ins, treated as members of the module `builtins`
      base = MkModuleImport("builtins") and
      lbl = Label::member(any(string name | ref = Builtins::likelyBuiltin(name)))
      or
      // Unknown variables that may belong to a module imported with `import *`
      exists(Scope s |
        base = potential_import_star_base(s) and
        lbl =
          Label::member(any(string name |
              ImportStar::namePossiblyDefinedInImportStar(ref.asCfgNode(), name, s)
            ))
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
      major_version() = 2 and
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
     * Gets a data-flow node to which `src`, which is a use of an API-graph node, flows.
     *
     * The flow from `src` to that node may be inter-procedural.
     */
    cached
    DataFlow::LocalSourceNode trackUseNode(DataFlow::LocalSourceNode src) {
      result = trackUseNode(src, DataFlow::TypeTracker::end()) and
      not result instanceof DataFlow::ModuleVariableNode
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(TApiNode pred, string lbl, TApiNode succ) {
      /* There's an edge from the root node for each imported module. */
      exists(string m |
        pred = MkRoot() and
        lbl = Label::mod(m)
      |
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
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph.
     */
    private predicate edge(TApiNode pred, TApiNode succ) { edge(pred, _, succ) }

    /** Gets the shortest distance from the root to `nd` in the API graph. */
    cached
    int distanceFromRoot(TApiNode nd) = shortestDistances(MkRoot/0, edge/2)(_, nd, result)
  }
}

private module Label {
  /** Gets the edge label for the module `m`. */
  bindingset[m]
  bindingset[result]
  string mod(string m) { result = "moduleImport(\"" + m + "\")" }

  /** Gets the `member` edge label for member `m`. */
  bindingset[m]
  bindingset[result]
  string member(string m) { result = "getMember(\"" + m + "\")" }

  /** Gets the `member` edge label for the unknown member. */
  string unknownMember() { result = "getUnknownMember()" }

  /** Gets the `member` edge label for the given attribute reference. */
  string memberFromRef(DataFlow::AttrRef pr) {
    result = member(pr.getAttributeName())
    or
    not exists(pr.getAttributeName()) and
    result = unknownMember()
  }

  /** Gets the `return` edge label. */
  string return() { result = "getReturn()" }

  /** Gets the `subclass` edge label. */
  string subclass() { result = "getASubclass()" }

  /** Gets the `await` edge label. */
  string await() { result = "getAwaited()" }
}
