/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * The nodes of the API graph represent definitions and uses of API components. The edges are
 * directed and labeled; they specify how the components represented by nodes relate to each other.
 */

import python
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
    DataFlow::Node getACall() { result = getReturn().getAnImmediateUse() }

    /**
     * Gets a node representing member `m` of this API component.
     *
     * For example, modules have an `exports` member representing their exports, and objects have
     * their properties as members.
     */
    bindingset[m]
    bindingset[result]
    Node getMember(string m) { result = getASuccessor(Label::member(m)) }

    /**
     * Gets a node representing a member of this API component where the name of the member is
     * not known statically.
     */
    Node getUnknownMember() { result = getASuccessor(Label::unknownMember()) }

    /**
     * Gets a node representing a member of this API component where the name of the member may
     * or may not be known statically.
     */
    Node getAMember() {
      result = getASuccessor(Label::member(_)) or
      result = getUnknownMember()
    }

    /**
     * Gets a node representing the result of the function represented by this node.
     *
     * This predicate may have multiple results when there are multiple invocations of this API component.
     * Consider using `getACall()` if there is a need to distingiush between individual calls.
     */
    Node getReturn() { result = getASuccessor(Label::return()) }

    /**
     * Gets a string representation of the lexicographically least among all shortest access paths
     * from the root to this node.
     */
    string getPath() { result = min(string p | p = getAPath(Impl::distanceFromRoot(this)) | p) }

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
    Node getAPredecessor() { result = getAPredecessor(_) }

    /**
     * Gets a node such that there is an edge in the API graph between that other node and
     * this one.
     */
    Node getASuccessor() { result = getASuccessor(_) }

    /**
     * Gets the data-flow node that gives rise to this node, if any.
     */
    DataFlow::Node getInducingNode() { this = Impl::MkUse(result) }

    /**
     * Holds if this node is located in file `path` between line `startline`, column `startcol`,
     * and line `endline`, column `endcol`.
     *
     * For nodes that do not have a meaningful location, `path` is the empty string and all other
     * parameters are zero.
     */
    predicate hasLocationInfo(string path, int startline, int startcol, int endline, int endcol) {
      getInducingNode().hasLocationInfo(path, startline, startcol, endline, endcol)
      or
      not exists(getInducingNode()) and
      path = "" and
      startline = 0 and
      startcol = 0 and
      endline = 0 and
      endcol = 0
    }

    /**
     * Gets a textual representation of this node.
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
        result = type + getPath()
        or
        not exists(this.getPath()) and result = type + "with no path"
      )
    }
  }

  /** Gets the root node. */
  Root root() { any() }

  /** Gets a node corresponding to an import of module `m`. */
  Node moduleImport(string m) { result = Impl::MkModuleImport(m) }

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
      /** The root of the API graph. */
      MkRoot() or
      /** An abstract representative for imports of the module called `name`. */
      MkModuleImport(string name) {
        imports(_, name) or name = any(ImportExpr e | not e.isRelative()).getAnImportedModuleName()
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
      exists(string base_str, string sub_str |
        base = MkModuleImport(base_str) and
        sub = MkModuleImport(sub_str)
      |
        base_str + "." + member = sub_str and
        not member.matches("%.%")
      )
    }

    /** Holds if `imp` is an import of a module named `name` */
    private predicate imports(DataFlow::Node import_node, string name) {
      exists(Variable var, Import imp, Alias alias |
        alias = imp.getAName() and
        alias.getAsname() = var.getAStore() and
        (
          name = alias.getValue().(ImportMember).getImportedModuleName()
          or
          name = alias.getValue().(ImportExpr).getImportedModuleName() and
          not alias.getValue().(ImportExpr).isRelative()
        ) and
        import_node.asExpr() = alias.getValue()
      )
      or
      exists(ImportExpr imp_expr |
        not imp_expr.isRelative() and
        imp_expr.getName() = name and
        import_node.asCfgNode().getNode() = imp_expr and
        // in `import foo.bar` we DON'T want to give a result for `importNode("foo.bar")`,
        // only for `importNode("foo")`. We exclude those cases with the following clause.
        not exists(Import imp | imp.getAName().getValue() = imp_expr)
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
        // reference to the API node `base`.
        //
        // Once we have identified the predecessor, we define its relation to the successor `ref` as
        // well as the label on the edge from `pred` to `ref`. This label describes the nature of
        // the relationship between `pred` and `ref`.
        use(base, src) and pred = trackUseNode(src)
      |
        // Reading an attribute on a node that is a use of `base`:
        lbl = Label::memberFromRef(ref) and
        ref = pred.getAnAttributeRead()
        or
        // Calling a node that is a use of `base`
        lbl = Label::return() and
        ref = pred.getACall()
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
      nd = MkUse(ref)
    }

    /**
     * Gets a data-flow node to which `nd`, which is a use of an API-graph node, flows.
     *
     * The flow from `nd` to that node may be inter-procedural.
     */
    private DataFlow::LocalSourceNode trackUseNode(
      DataFlow::LocalSourceNode src, DataFlow::TypeTracker t
    ) {
      t.start() and
      use(_, src) and
      result = src
      or
      // Due to bad performance when using `trackUseNode(t2, attr_name).track(t2, t)`
      // we have inlined that code and forced a join
      exists(DataFlow::StepSummary summary |
        t = trackUseNode_first_join(src, result, summary).append(summary)
      )
    }

    pragma[nomagic]
    private DataFlow::TypeTracker trackUseNode_first_join(
      DataFlow::LocalSourceNode src, DataFlow::LocalSourceNode res, DataFlow::StepSummary summary
    ) {
      DataFlow::StepSummary::step(trackUseNode(src, result), res, summary)
    }

    cached
    DataFlow::LocalSourceNode trackUseNode(DataFlow::LocalSourceNode src) {
      result = trackUseNode(src, DataFlow::TypeTracker::end())
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(Node pred, string lbl, Node succ) {
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
}
