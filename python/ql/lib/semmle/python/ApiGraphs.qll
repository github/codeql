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
     * Gets a data-flow node corresponding to the right-hand side of a definition of the API
     * component represented by this node.
     *
     * For example, in the property write `foo.bar = x`, variable `x` is the the right-hand side
     * of a write to the `bar` property of `foo`.
     *
     * Note that for parameters, it is the arguments flowing into that parameter that count as
     * right-hand sides of the definition, not the declaration of the parameter itself.
     * Consequently, in :
     * ```python
     * from mypkg import foo;
     * foo.bar(x)
     * ```
     * `x` is the right-hand side of a definition of the first parameter of `bar` from the `mypkg.foo` module.
     */
    DataFlow::Node getARhs() { Impl::rhs(this, result) }

    /**
     * Gets a data-flow node that may interprocedurally flow to the right-hand side of a definition
     * of the API component represented by this node.
     */
    DataFlow::Node getAValueReachingRhs() { result = Impl::trackDefNode(this.getARhs()) }

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
    CallNode getACall() { result = this.getReturn().getAnImmediateUse() }

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
     * Gets a node representing the `i`th parameter of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distingiush between individual calls.
     */
    Node getParameter(int i) { result = this.getASuccessor(Label::parameter(i)) }

    /**
     * Gets the node representing the keyword parameter `name` of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getAnInvocation()` if there is a need to distingiush between individual calls.
     */
    Node getKeywordParameter(string name) {
      result = this.getASuccessor(Label::keywordParameter(name))
    }

    /**
     * Gets the number of parameters of the function represented by this node.
     */
    int getNumParameter() { result = max(int s | exists(this.getParameter(s))) + 1 }

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
  Node moduleImport(string m) { result = Impl::MkModuleImport(m) }

  /** Gets a node corresponding to the built-in with the given name, if any. */
  Node builtin(string n) { result = moduleImport("builtins").getMember(n) }

  /**
   * An `CallCfgNode` that is connected to the API graph.
   *
   * Can be used to reason about calls to an external API in which the correlation between
   * parameters and/or return values must be retained.
   *
   * The member predicates `getParameter`, `getKeywordParameter`, `getReturn`, and `getInstance` mimic
   * the corresponding predicates from `API::Node`. These are guaranteed to exist and be unique to this call.
   */
  class CallNode extends DataFlow::CallCfgNode {
    API::Node callee;

    CallNode() { this = callee.getReturn().getAnImmediateUse() }

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
    private Node getAParameterCandidate(int i) { result.getARhs() = this.getArg(i) }

    /** Gets the API node for a parameter of this invocation. */
    Node getAParameter() { result = this.getParameter(_) }

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
      result.getARhs() = this.getArgByName(name)
    }

    /** Gets the API node for the return value of this call. */
    Node getReturn() {
      result = callee.getReturn() and
      result.getAnImmediateUse() = this
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
    private predicate imports(DataFlow::Node imp, string name) {
      exists(PY::ImportExprNode iexpr |
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
    private TApiNode potential_import_star_base(PY::Scope s) {
      exists(DataFlow::Node n |
        n.asCfgNode() = ImportStar::potentialImportStarBase(s) and
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
        // TODO: I had expected `DataFlow::AttrWrite` to contain the attribute writes from a dict, that's how JS works.
        exists(PY::Dict dict, PY::KeyValuePair item |
          dict = pred.asExpr() and
          dict.getItem(_) = item and
          lbl = Label::member(item.getKey().(PY::StrConst).getS()) and
          rhs.asExpr() = item.getValue()
        )
        or
        exists(PY::CallableExpr fn | fn = pred.asExpr() |
          not fn.getInnerScope().isAsync() and
          lbl = Label::return() and
          exists(PY::Return ret |
            rhs.asExpr() = ret.getValue() and
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
        // Subclassing a node
        lbl = Label::subclass() and
        exists(DataFlow::Node superclass | pred.flowsTo(superclass) |
          ref.asExpr().(PY::ClassExpr).getABase() = superclass.asExpr()
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
      exists(DataFlow::Node def, PY::CallableExpr fn |
        rhs(base, def) and fn = trackDefNode(def).asExpr()
      |
        exists(int i |
          lbl = Label::parameter(i) and
          ref.asExpr() = fn.getInnerScope().getArg(i)
        )
        or
        exists(string name |
          lbl = Label::keywordParameter(name) and
          ref.asExpr() = fn.getInnerScope().getArgByName(name)
        )
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
      not result instanceof DataFlow::ModuleVariableNode
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
          Impl::prefix_member(_, member, _) or
          member = any(PY::Dict d).getAnItem().(PY::KeyValuePair).getKey().(PY::StrConst).getS()
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
        MkLabelReturn() or
        MkLabelSubclass() or
        MkLabelAwait()

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

      /** A label that gets the return value of a function. */
      class LabelReturn extends ApiLabel, MkLabelReturn {
        override string toString() { result = "getReturn()" }
      }

      /** A label that gets the subclass of a class. */
      class LabelSubclass extends ApiLabel, MkLabelSubclass {
        override string toString() { result = "getASubclass()" }
      }

      /** A label for awaited values. */
      class LabelAwait extends ApiLabel, MkLabelAwait {
        override string toString() { result = "getAwaited()" }
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
      not exists(ref.getAttributeName()) and
      result = unknownMember()
    }

    /** Gets the `parameter` edge label for parameter `i`. */
    LabelParameter parameter(int i) { result.getIndex() = i }

    /** Gets the `parameter` edge label for the keyword parameter `name`. */
    LabelKeywordParameter keywordParameter(string name) { result.getName() = name }

    /** Gets the `return` edge label. */
    LabelReturn return() { any() }

    /** Gets the `subclass` edge label. */
    LabelSubclass subclass() { any() }

    /** Gets the `await` edge label. */
    LabelAwait await() { any() }
  }
}
