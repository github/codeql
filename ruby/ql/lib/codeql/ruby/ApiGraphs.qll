/**
 * Provides an implementation of  _API graphs_, which are an abstract representation of the API
 * surface used and/or defined by a code base.
 *
 * The nodes of the API graph represent definitions and uses of API components. The edges are
 * directed and labeled; they specify how the components represented by nodes relate to each other.
 */

private import ruby
import codeql.ruby.DataFlow
import codeql.ruby.typetracking.TypeTracker
import codeql.ruby.ast.internal.Module
private import codeql.ruby.controlflow.CfgNodes

/**
 * Provides classes and predicates for working with APIs used in a database.
 */
module API {
  /**
   * An abstract representation of a definition or use of an API component such as a Ruby module,
   * or the result of a method call.
   */
  class Node extends Impl::TApiNode {
    /**
     * Gets a data-flow node corresponding to a use of the API component represented by this node.
     *
     * For example, `Kernel.format "%s world!", "Hello"` is a use of the return of the `format` function of
     * the `Kernel` module.
     *
     * This includes indirect uses found via data flow.
     */
    DataFlow::Node getAUse() {
      exists(DataFlow::LocalSourceNode src | Impl::use(this, src) |
        Impl::trackUseNode(src).flowsTo(result)
      )
    }

    /**
     * Gets an immediate use of the API component represented by this node.
     *
     * Unlike `getAUse()`, this predicate only gets the immediate references, not the indirect uses
     * found via data flow.
     */
    DataFlow::LocalSourceNode getAnImmediateUse() { Impl::use(this, result) }

    /**
     * Gets a call to a method on the receiver represented by this API component.
     */
    DataFlow::CallNode getAMethodCall(string method) {
      result = this.getReturn(method).getAnImmediateUse()
    }

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
     * Gets a node representing an instance of this API component, that is, an object whose
     * constructor is the function represented by this node.
     *
     * For example, if this node represents a use of some class `A`, then there might be a node
     * representing instances of `A`, typically corresponding to expressions `A.new` at the
     * source level.
     *
     * This predicate may have multiple results when there are multiple constructor calls invoking this API component.
     * Consider using `getAnInstantiation()` if there is a need to distinguish between individual constructor calls.
     */
    Node getInstance() { result = this.getASuccessor(Label::instance()) }

    /**
     * Gets a node representing the result of calling a method on the receiver represented by this node.
     */
    Node getReturn(string method) { result = this.getASuccessor(Label::return(method)) }

    /**
     * Gets a `new` call to the function represented by this API component.
     */
    DataFlow::ExprNode getAnInstantiation() { result = this.getInstance().getAnImmediateUse() }

    /**
     * Gets a node representing a subclass of the class represented by this node.
     */
    Node getASubclass() { result = this.getASuccessor(Label::subclass()) }

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

    /** Gets the location of this node. */
    Location getLocation() {
      result = this.getInducingNode().getLocation()
      or
      // For nodes that do not have a meaningful location, `path` is the empty string and all other
      // parameters are zero.
      not exists(this.getInducingNode()) and
      result instanceof EmptyLocation
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
  class Use extends Node, Impl::MkUse {
    override string toString() {
      exists(string type | type = "Use " |
        result = type + this.getPath()
        or
        not exists(this.getPath()) and result = type + "with no path"
      )
    }
  }

  /** Gets the root node. */
  Root root() { any() }

  /**
   * Gets a node corresponding to a top-level member `m` (typically a module).
   *
   * This is equivalent to `root().getAMember("m")`.
   *
   * Note: You should only use this predicate for top level modules or classes. If you want nodes corresponding to a nested module or class,
   * you should use `.getMember` on the parent module/class. For example, for nodes corresponding to the class `Gem::Version`,
   * use `getTopLevelMember("Gem").getMember("Version")`.
   */
  Node getTopLevelMember(string m) { result = root().getMember(m) }

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
      /** A use of an API member at the node `nd`. */
      MkUse(DataFlow::Node nd) { isUse(nd) }

    private string resolveTopLevel(ConstantReadAccess read) {
      TResolved(result) = resolveConstantReadAccess(read) and
      not result.matches("%::%")
    }

    /**
     * Holds if `ref` is a use of a node that should have an incoming edge from the root
     * node labeled `lbl` in the API graph.
     */
    pragma[nomagic]
    private predicate useRoot(string lbl, DataFlow::Node ref) {
      exists(string name, ConstantReadAccess read |
        read = ref.asExpr().getExpr() and
        lbl = Label::member(read.getName())
      |
        name = resolveTopLevel(read)
        or
        name = read.getName() and
        not exists(resolveTopLevel(read)) and
        not exists(read.getScopeExpr())
      )
    }

    /**
     * Holds if `ref` is a use of a node that should have an incoming edge labeled `lbl`,
     * from a use node that flows to `node`.
     */
    private predicate useStep(string lbl, ExprCfgNode node, DataFlow::Node ref) {
      // // Referring to an attribute on a node that is a use of `base`:
      // pred = `Rails` part of `Rails::Whatever`
      // lbl = `Whatever`
      // ref = `Rails::Whatever`
      exists(ExprNodes::ConstantAccessCfgNode c, ConstantReadAccess read |
        not exists(resolveTopLevel(read)) and
        node = c.getScopeExpr() and
        lbl = Label::member(read.getName()) and
        ref.asExpr() = c and
        read = c.getExpr()
      )
      or
      // Calling a method on a node that is a use of `base`
      exists(ExprNodes::MethodCallCfgNode call, string name |
        node = call.getReceiver() and
        name = call.getExpr().getMethodName() and
        lbl = Label::return(name) and
        name != "new" and
        ref.asExpr() = call
      )
      or
      // Calling the `new` method on a node that is a use of `base`, which creates a new instance
      exists(ExprNodes::MethodCallCfgNode call |
        node = call.getReceiver() and
        lbl = Label::instance() and
        call.getExpr().getMethodName() = "new" and
        ref.asExpr() = call
      )
    }

    pragma[nomagic]
    private predicate isUse(DataFlow::Node nd) {
      useRoot(_, nd)
      or
      exists(ExprCfgNode node, DataFlow::LocalSourceNode pred |
        pred = useCandFwd() and
        pred.flowsTo(any(DataFlow::ExprNode n | n.getExprNode() = node)) and
        useStep(_, node, nd)
      )
    }

    /**
     * Holds if `ref` is a use of node `nd`.
     */
    cached
    predicate use(TApiNode nd, DataFlow::Node ref) { nd = MkUse(ref) }

    private DataFlow::LocalSourceNode useCandFwd(TypeTracker t) {
      t.start() and
      isUse(result)
      or
      exists(TypeTracker t2 | result = useCandFwd(t2).track(t2, t))
    }

    private DataFlow::LocalSourceNode useCandFwd() { result = useCandFwd(TypeTracker::end()) }

    private DataFlow::Node useCandRev(TypeBackTracker tb) {
      result = useCandFwd() and
      tb.start()
      or
      exists(TypeBackTracker tb2, DataFlow::LocalSourceNode mid, TypeTracker t |
        mid = useCandRev(tb2) and
        result = mid.backtrack(tb2, tb) and
        pragma[only_bind_out](result) = useCandFwd(t) and
        pragma[only_bind_out](t) = pragma[only_bind_out](tb).getACompatibleTypeTracker()
      )
    }

    private DataFlow::LocalSourceNode useCandRev() {
      result = useCandRev(TypeBackTracker::end()) and
      isUse(result)
    }

    /**
     * Gets a data-flow node to which `src`, which is a use of an API-graph node, flows.
     *
     * The flow from `src` to the returned node may be inter-procedural.
     */
    private DataFlow::Node trackUseNode(DataFlow::LocalSourceNode src, TypeTracker t) {
      result = src and
      result = useCandRev() and
      t.start()
      or
      exists(TypeTracker t2, DataFlow::LocalSourceNode mid, TypeBackTracker tb |
        mid = trackUseNode(src, t2) and
        result = mid.track(t2, t) and
        pragma[only_bind_out](result) = useCandRev(tb) and
        pragma[only_bind_out](t) = pragma[only_bind_out](tb).getACompatibleTypeTracker()
      )
    }

    /**
     * Gets a data-flow node to which `src`, which is a use of an API-graph node, flows.
     *
     * The flow from `src` to the returned node may be inter-procedural.
     */
    cached
    DataFlow::LocalSourceNode trackUseNode(DataFlow::LocalSourceNode src) {
      result = trackUseNode(src, TypeTracker::end())
    }

    /**
     * Holds if there is an edge from `pred` to `succ` in the API graph that is labeled with `lbl`.
     */
    cached
    predicate edge(TApiNode pred, string lbl, TApiNode succ) {
      /* Every node that is a use of an API component is itself added to the API graph. */
      exists(DataFlow::LocalSourceNode ref | succ = MkUse(ref) |
        pred = MkRoot() and
        useRoot(lbl, ref)
        or
        exists(ExprCfgNode node, DataFlow::Node src |
          pred = MkUse(src) and
          trackUseNode(src).flowsTo(any(DataFlow::ExprNode n | n.getExprNode() = node)) and
          useStep(lbl, node, ref)
        )
      )
      or
      // `pred` is a use of class A
      // `succ` is a use of class B
      // there exists a class declaration B < A
      exists(ClassDeclaration c, DataFlow::Node a, DataFlow::Node b |
        use(pred, a) and
        use(succ, b) and
        resolveConstant(b.asExpr().getExpr()) = resolveConstantWriteAccess(c) and
        c.getSuperclassExpr() = a.asExpr().getExpr() and
        lbl = Label::subclass()
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
  /** Gets the `member` edge label for member `m`. */
  bindingset[m]
  bindingset[result]
  string member(string m) { result = "getMember(\"" + m + "\")" }

  /** Gets the `member` edge label for the unknown member. */
  string unknownMember() { result = "getUnknownMember()" }

  /** Gets the `instance` edge label. */
  string instance() { result = "instance" }

  /** Gets the `return` edge label. */
  bindingset[m]
  bindingset[result]
  string return(string m) { result = "getReturn(\"" + m + "\")" }

  string subclass() { result = "getASubclass()" }
}
