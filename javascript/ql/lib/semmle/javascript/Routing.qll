/**
 * A model of routing trees, describing the composition of route handlers and middleware functions
 * in a web server application. See `Routing::Node` for more details.
 */

private import javascript
private import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.DynamicPropertyAccess

/**
 * A model of routing trees, describing the composition of route handlers and middleware functions
 * in a web server application. See `Routing::Node` for more details.
 */
module Routing {
  private newtype TNode =
    /**
     * A data flow node whose value corresponds to a route node.
     */
    MkValueNode(ValueNode::Range range) or
    /**
     * A place where a route is installed on a mutable router object, or where a mutable
     * router object escapes into a function leading to such route setups.
     *
     * The call performing the route setup usually returns the router itself, not
     * the particular route installed here, which is why this is not a value node.
     */
    MkRouteSetup(RouteSetup::Base range) or
    /**
     * A node representing the state of a mutable router object at the exit of `container`.
     *
     * When routers are passed around and mutated from multiple functions, we need to reason about the relative
     * ordering of route setups in different functions. To simplify this, a separate node is generated for a each
     * function that mutates the router.
     */
    MkRouter(Router::Range range, StmtContainer container) {
      routerIsLiveInContainer(range, container)
    }

  private predicate routerIsLiveInContainer(Router::Range router, StmtContainer container) {
    container = router.getContainer()
    or
    exists(RouteSetup::Range setup, ControlFlowNode cfg |
      setup.isInstalledAt(router, cfg) and
      container = cfg.getContainer()
    )
    or
    // 'container' contains a call to a function in which 'router' is live
    exists(DataFlow::InvokeNode invoke, Function f |
      routerIsLiveInContainer(router, f) and
      not f = router.getContainer() and // 'f' does not contain the creation of the router
      FlowSteps::calls(invoke, f) and
      container = invoke.getContainer()
    )
  }

  /** Gets the routing node corresponding to the value of `node`. */
  Node getNode(DataFlow::Node node) { result = MkValueNode(node) }

  /**
   * Gets the routing node corresponding to the route installed at the given route setup.
   *
   * This is not generally the same as `getNode(call)`, since the route setup method can return a value
   * that does not correspond to the route that was just installed.
   * Typically this occurs when the route setup method is chainable and returns the router itself.
   */
  Node getRouteSetupNode(DataFlow::Node call) { result = MkRouteSetup(call) }

  /**
   * A node in a routing tree modeling the composition of middleware functions and route handlers.
   *
   * More precisely, this is a node in a graph representing a set of possible routing trees, as the
   * concrete shape of the routing tree may be depend on branching control flow.
   *
   * Each node represents a function that can receive an incoming request, though not necessarily
   * a function with an explicit body in the source code.
   *
   * A node may either consume the request, dispatching to its first child, or pass it on to its successor
   * in the tree. The successor is the next sibling, or in case there is no next sibling, it is the next sibling
   * of the first ancestor that has a next sibling.
   */
  class Node extends TNode {
    /** Gets a textual representation of this element. */
    string toString() { none() } // Overridden in subclass

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      none()
    } // overridden in subclass

    /**
     * Gets the next sibling of this node in the routing tree.
     */
    final Node getNextSibling() { areSiblings(this, result) }

    /**
     * Gets the previous sibling of this node in the routing tree.
     */
    final Node getPreviousSibling() { areSiblings(result, this) }

    /**
     * Gets a child of this node in the routing tree.
     */
    Node getAChild() { none() } // Overridden in subclass

    /**
     * Gets the parent of this node in the routing tree.
     */
    final Node getParent() { result.getAChild() = this }

    /**
     * Gets the first child of this node in the routing tree.
     */
    Node getFirstChild() { none() } // Overridden in subclass

    /**
     * Gets the last child of this node in the routing tree.
     */
    Node getLastChild() { none() } // Overridden in subclass

    /**
     * Gets the root node of this node in the routing tree.
     */
    final RootNode getRootNode() { this = result.getADescendant() }

    /**
     * Holds if this node may invoke its continuation after having dispatched the
     * request to its children, that is, the incoming request may be partially processed by
     * this subtree, and subsequently passed on to the successor.
     */
    predicate mayResumeDispatch() {
      this.getLastChild().mayResumeDispatch()
      or
      exists(this.(RouteHandler).getAContinuationInvocation())
      or
      // Leaf nodes that aren't functions are assumed to invoke their continuation
      not exists(this.getLastChild()) and
      not this instanceof RouteHandler
      or
      this instanceof MkRouter
    }

    /**
     * Like `mayResumeDispatch` but without the assumption that functions with an unknown
     * implementation invoke their continuation.
     */
    predicate definitelyResumesDispatch() {
      this.getLastChild().definitelyResumesDispatch()
      or
      exists(this.(RouteHandler).getAContinuationInvocation())
      or
      this instanceof MkRouter
    }

    /** Gets the parent of this node, provided that this node may invoke its continuation. */
    private Node getContinuationParent() {
      result = this.getParent() and
      result.mayResumeDispatch()
    }

    /**
     * Gets a path prefix to be matched against the path of incoming requests.
     *
     * If the prefix matches, the request is dispatched to the first child, with a modified path
     * where the matched prefix has been removed. For example, if the prefix is `/foo` and the incoming
     * request has path `/foo/bar`, a request with path `/bar` is dispatched to the first child.
     *
     * If the prefix does not match, the request is passed on to the continuation.
     */
    string getRelativePath() { none() } // Overridden in subclass

    /**
     * Holds if this is a node where the request can flow from one child to the next.
     */
    private predicate isFork() {
      exists(Node child |
        child = this.getAChild() and
        child.mayResumeDispatch() and
        exists(child.getNextSibling())
      )
    }

    /**
     * Gets the path prefix needed to reach this node from the given ancestor, that is, the concatenation
     * of all relative paths between this node and the ancestor.
     *
     * To restrict the size of the predicate, this is only available for the ancestors that are "fork" nodes,
     * that is, a node that has siblings (i.e. multiple children).
     */
    private string getPathFromFork(Node fork) {
      this.isFork() and
      this = fork and
      result = ""
      or
      exists(Node parent | parent = this.getParent() |
        not exists(parent.getRelativePath()) and
        result = parent.getPathFromFork(fork)
        or
        result = parent.getPathFromFork(fork) + parent.getRelativePath() and
        result.length() < 100
      )
    }

    /**
     * Gets an HTTP method required to reach this node from the given ancestor, or `*` if any method
     * can be used.
     *
     * To restrict the size of the predicate, this is only available for the ancestors that are "fork" nodes,
     * that is, a node that has siblings (i.e. multiple children).
     */
    private string getHttpMethodFromFork(Node fork) {
      this.isFork() and
      this = fork and
      (
        result = this.getOwnHttpMethod()
        or
        not exists(this.getOwnHttpMethod()) and
        result = "*"
      )
      or
      result = this.getParent().getHttpMethodFromFork(fork) and
      (
        // Only the ancestor restricts the HTTP method
        not exists(this.getOwnHttpMethod())
        or
        // Intersect permitted HTTP methods
        result = this.getOwnHttpMethod()
      )
      or
      // The ancestor allows any HTTP method, but this node restricts it
      this.getParent().getHttpMethodFromFork(fork) = "*" and
      result = this.getOwnHttpMethod()
    }

    /**
     * Holds if `guard` has processed the incoming request strictly prior to this node.
     */
    pragma[inline]
    private predicate isGuardedByNodeInternal(Node guard) {
      // Look for a common ancestor `fork` whose child leading to `guard` ("base1") precedes
      // the child leading to `this` ("base2").
      //
      // Schematically:
      //      fork
      //     /    \
      //   base1  base2
      //    |       |   <-- (zero or more steps)
      //   guard   this
      exists(Node base1, Node base2, Node fork |
        base1 = guard.getContinuationParent*() and
        base2 = base1.getNextSibling+() and
        this = base2.getAChild*() and
        fork = base1.getParent() and
        isEitherPrefixOfTheOther(this.getPathFromFork(fork), guard.getPathFromFork(fork)) and
        areHttpMethodsMatching(base1.getHttpMethodFromFork(fork), base2.getHttpMethodFromFork(fork))
      )
    }

    /**
     * Holds if `node` has processed the incoming request strictly prior to this node.
     */
    pragma[inline]
    predicate isGuardedByNode(Node node) {
      this.isGuardedByNodeInternal(pragma[only_bind_out](node))
    }

    /**
     * Holds if the middleware corresponding to `node` has processed the incoming request strictly prior to this node.
     */
    pragma[inline]
    predicate isGuardedBy(DataFlow::Node node) { this.isGuardedByNode(getNode(node)) }

    /**
     * Gets an HTTP method name which this node will accept, or nothing if the node accepts all HTTP methods, not
     * taking into account the context from ancestors or children nodes.
     */
    Http::RequestMethodName getOwnHttpMethod() { none() } // Overridden in subclass

    private Node getAUseSiteInRouteSetup() {
      if this.getParent() instanceof RouteSetup
      then result = this
      else result = this.getParent().getAUseSiteInRouteSetup()
    }

    /** Gets a place where this route node is installed as a route handler. */
    Node getRouteInstallation() {
      result = this.getAUseSiteInRouteSetup()
      or
      not exists(this.getAUseSiteInRouteSetup()) and
      result = this
    }

    /**
     * Gets a node whose value can be accessed via the given access path on the `n`th route handler parameter,
     * from any route handler that follows after this one.
     *
     * This predicate may be overridden by framework models and only accounts for assignments made by the framework;
     * not necessarily assignments that are explicit in the application code.
     *
     * For example, in the context of Express, the `app` object is available as `req.app`:
     * ```js
     * app.get('/', (req, res) => {
     *   req.app; // alias for 'app'
     * })
     * ```
     * This can be modeled by mapping `(0, "app")` to the `app` data-flow node (`n=0` corresponds
     * to the `req` parameter).
     */
    DataFlow::Node getValueImplicitlyStoredInAccessPath(int n, string path) { none() }
  }

  /** Holds if `pred` and `succ` are adjacent siblings and `succ` is installed after `pred`. */
  private predicate areSiblings(Node pred, Node succ) {
    exists(ValueNode::Range base, int n |
      pred = base.getChild(n) and
      succ = base.getChild(n + 1)
    )
    or
    exists(RouteSetup::Range base, int n |
      pred = base.getChild(n) and
      succ = base.getChild(n + 1)
    )
    or
    exists(Router::Range router, ControlFlowNode cfgNode |
      isInstalledAt(succ, router, cfgNode) and
      pred = getMostRecentRouteSetupAt(router, cfgNode.getAPredecessor()) and
      pred != succ // simplify analysis of loops
    )
  }

  /** Holds if `a` is a prefix of `b` or the other way around. */
  bindingset[a, b]
  private predicate isEitherPrefixOfTheOther(string a, string b) {
    a = b + any(string s) or b = a + any(string s)
  }

  /** Holds if `a` and `b` are the same HTTP method name or either of them is `*`. */
  bindingset[a, b]
  private predicate areHttpMethodsMatching(string a, string b) { a = "*" or b = "*" or a = b }

  /**
   * Companion module to the `Node` class, containing abstract classes
   * that can be used to extend the routing model.
   */
  module ValueNode {
    /**
     * A node in the routing tree which corresponds to a data-flow node,
     * and has a linear sequence of children (or no children).
     *
     * This class can be extended to contribute new kinds of nodes to tree,
     * though in common cases it is preferrable to extend one of the more specialized classes:
     * - `Routing::ValueNode::UseSite` to mark values that are used as a route handler,
     * - `Routing::ValueNode::WithArguments` for nodes with an indexed sequence of children,
     * - `Routing::RouteSetup::MethodCall` for nodes manipulating a router object
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the `n`th child of this route node. */
      Node getChild(int n) { none() }

      /** Gets the number of children of this route node. */
      final int getNumChild() { result = count(int n | exists(this.getChild(n))) }

      /**
       * Gets a path prefix to be matched against the path of incoming requests.
       *
       * If the prefix matches, the request is dispatched to the first child, with a modified path
       * where the matched prefix has been removed. For example, if the prefix is `/foo` and the incoming
       * request has path `/foo/bar`, a request with path `/bar` is dispatched to the first child.
       *
       * If the prefix does not match, the request is passed on to the continuation.
       */
      string getRelativePath() { none() }

      /**
       * Gets an HTTP request method name (in upper case) matched by this node, or nothing
       * if all HTTP request method names are accepted.
       */
      Http::RequestMethodName getHttpMethod() { none() }
    }

    private class ValueNodeImpl extends Node, MkValueNode {
      Range range;

      ValueNodeImpl() { this = MkValueNode(range) }

      override string toString() { result = range.toString() }

      override predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        range.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      override Node getAChild() { result = range.getChild(_) }

      override Node getFirstChild() { result = range.getChild(0) }

      override Node getLastChild() { result = range.getChild(range.getNumChild() - 1) }

      override string getRelativePath() { result = range.getRelativePath() }

      override Http::RequestMethodName getOwnHttpMethod() { result = range.getHttpMethod() }
    }

    private StepSummary routeStepSummary() {
      // Do not allow call steps as they lead to loss of context.
      // Such steps are usually handled by the 'ImpliedRouteHandler' class.
      result = LevelStep() or result = ReturnStep()
    }

    /**
     * A node that is used as a route handler.
     *
     * Values that flow to this use site are themselves considered use sites, and are
     * considered children of this one. (Intuitively, requests dispatched to this use-site
     * are delagated to any node that flows here.)
     *
     * Framework models may extend this class to mark nodes as being use sites.
     */
    abstract class UseSite extends Range {
      /**
       * Gets a data flow node that flows to this use-site in one step.
       */
      DataFlow::Node getSource() {
        result = this.getALocalSource()
        or
        StepSummary::smallstep(result, this, routeStepSummary())
        or
        Http::routeHandlerStep(result, this)
        or
        RouteHandlerTrackingStep::step(result, this)
        or
        exists(string prop |
          StepSummary::smallstep(result, this.getSourceProp(prop).getALocalUse(), StoreStep(prop))
        )
        or
        this = getAnEnumeratedArrayElement(result)
      }

      /** Gets a node whose `prop` property flows to this use site. */
      private DataFlow::SourceNode getSourceProp(string prop) {
        StepSummary::step(result, this, LoadStep(prop))
        or
        StepSummary::step(result, this.getSourceProp(prop), routeStepSummary())
        or
        StepSummary::step(result, this.getSourceProp(prop), CopyStep(prop))
        or
        exists(string oldProp |
          StepSummary::step(result, this.getSourceProp(oldProp), LoadStoreStep(prop, oldProp))
        )
      }

      private DataFlow::Node getStrictSource() {
        result = this.getSource() and
        result != this
      }

      final override Routing::Node getChild(int n) {
        n = 0 and
        result = MkValueNode(this.getStrictSource())
        or
        // If we cannot find the source of the use-site, but we know it's somehow a reference to a router,
        // treat the router as the source. This is needed to handle chaining calls on the router, as the
        // specific framework model knows about chaining steps, but the general `getSource()` predicate doesn't.
        n = 0 and
        not exists(this.getStrictSource()) and
        exists(Router::Range router |
          this = router.getAReference().getALocalUse() and
          result = MkRouter(router, this.getContainer())
        )
      }
    }

    /**
     * A node flowing into a use site, modeled as a child of the use site.
     */
    private class UseSiteSource extends UseSite {
      UseSiteSource() { this = any(UseSite use).getSource() }
    }

    /**
     * A node that has a linear sequence of children, which should all be marked as route objects.
     */
    abstract class WithArguments extends Range {
      /**
       * Gets a data flow node that should be seen as the `n`th child of this node.
       *
       * Overriding this predicate ensures that a routing node is generated for the child.
       */
      abstract DataFlow::Node getArgumentNode(int n);

      final override Node getChild(int n) { result = MkValueNode(this.getArgumentNode(n)) }
    }

    /** An argument to a `WithArguments` instance, seen as a use site. */
    private class Argument extends UseSite {
      Argument() { this = any(WithArguments n).getArgumentNode(_) }
    }

    /**
     * An array which has been determined to be a route node, seen as a route node with arguments.
     */
    private class ImpliedArrayRoute extends ValueNode::WithArguments, DataFlow::ArrayCreationNode instanceof ValueNode::UseSite
    {
      override DataFlow::Node getArgumentNode(int n) { result = this.getElement(n) }
    }
  }

  /**
   * An edge that should be used for tracking route handler definitions to their use-sites.
   *
   * This may be subclassed by framework models to contribute additional steps.
   */
  class RouteHandlerTrackingStep extends Unit {
    /** Holds if route handlers should be propagated along the edge `pred -> succ`. */
    predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }
  }

  private module RouteHandlerTrackingStep {
    predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      any(RouteHandlerTrackingStep s).step(pred, succ)
    }
  }

  /**
   * A node in the routing tree which has no parent.
   */
  class RootNode extends Node {
    RootNode() { not exists(this.getParent()) }

    /** Gets a node that is part of this subtree. */
    final Node getADescendant() { result = this.getAChild*() }
  }

  /**
   * A node representing a place where one or more routes are installed onto a mutable
   * router object.
   *
   * The children of this node are the individual route handlers installed here.
   *
   * The siblings of this node are the other route setups locally affecting the same router,
   * in the order in which they are installed.
   *
   * In case of branching control flow, the siblings are non-linear, that is, some route setups
   * will have multiple previous/next siblings, reflecting the different paths the program may take
   * during setup.
   */
  class RouteSetup extends Node, MkRouteSetup {
    /**
     * Gets the router affected by this route setup.
     *
     * This is an alias for `getParent`, but may be preferred for readability.
     */
    final Node getRouter() { result = this.getParent() }
  }

  /**
   * Companion module to the `RouteSetup` class, containing classes that can be use to contribute
   * new kinds of route setups.
   */
  module RouteSetup {
    // To avoid negative recursion, the route setup range class is split into 'Base' and 'Range', where
    // 'Range' contains those contributed by frameworks, and 'Base' contains some additional route setups
    // where the router escapes into a function that contains other route setups.
    /**
     * INTERNAL. Use `RouteSetup::Range` instead.
     *
     * Class containing explicit route setups in addition to implied route setups, that is,
     * places where a router escapes into a function containing route setups.
     */
    abstract class Base extends DataFlow::Node {
      /** Gets the `n`th child of this route node. */
      Node getChild(int n) { none() }

      /** Gets the number of children of this route node. */
      final int getNumChild() { result = count(int n | exists(this.getChild(n))) }

      /**
       * Gets a path prefix to be matched against the path of incoming requests.
       *
       * If the prefix matches, the request is dispatched to the first child, with a modified path
       * where the matched prefix has been removed. For example, if the prefix is `/foo` and the incoming
       * request has path `/foo/bar`, a request with path `/bar` is dispatched to the first child.
       *
       * If the prefix does not match, the request is passed on to the continuation.
       */
      string getRelativePath() { none() }

      /**
       * Gets an HTTP request method name (in upper case) matched by this node, or nothing
       * if all HTTP request method names are accepted.
       */
      Http::RequestMethodName getHttpMethod() { none() }

      /**
       * Holds if this route setup targets `router` and occurs at the given `cfgNode`.
       */
      abstract predicate isInstalledAt(Router::Range router, ControlFlowNode cfgNode);
    }

    /**
     * This class can be extended to contribute new kinds of route setups.
     */
    abstract class Range extends Base {
      // Note: all member predicates are defined in RouteSetup::Base, declared above.
    }

    private class RouteSetupImpl extends Node, MkRouteSetup {
      Base range;

      RouteSetupImpl() { this = MkRouteSetup(range) }

      override string toString() { result = range.toString() }

      override predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        range.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      override Node getAChild() { result = range.getChild(_) }

      override Node getFirstChild() { result = range.getChild(0) }

      override Node getLastChild() { result = range.getChild(range.getNumChild() - 1) }

      override string getRelativePath() { result = range.getRelativePath() }

      override Http::RequestMethodName getOwnHttpMethod() { result = range.getHttpMethod() }
    }

    /**
     * A route setup that is method call on a router object, installing its arguments as route handlers.
     *
     * This class can be extended to contribute new kinds of route handlers.
     */
    abstract class MethodCall extends RouteSetup::Range, DataFlow::MethodCallNode {
      override Node getChild(int n) { result = MkValueNode(this.getChildNode(n)) }

      /** Gets the `n`th child of this route setup. */
      DataFlow::Node getChildNode(int n) { result = this.getArgument(n) }

      override predicate isInstalledAt(Router::Range router, ControlFlowNode cfgNode) {
        this = router.getAReference().getAMethodCall() and cfgNode = this.getEnclosingExpr()
      }
    }

    private class RouteSetupArgument extends ValueNode::UseSite {
      RouteSetupArgument() { this = any(RouteSetup::MethodCall c).getChildNode(_) }
    }
  }

  /**
   * Provides classes for generating `Router` nodes, to be subclassed by framework models.
   */
  module Router {
    /**
     * The creation of a mutable router object.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets a reference to this router. */
      abstract DataFlow::SourceNode getAReference();
    }

    private class RouterImpl extends Node, MkRouter {
      Router::Range router;
      StmtContainer container;

      RouterImpl() { this = MkRouter(router, container) }

      override string toString() {
        result =
          router.toString() + " in " +
            [container.(Function).describe(), container.(TopLevel).getFile().getRelativePath()]
      }

      override predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        router.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      private RouteSetup::Base getARouteSetup() {
        result.isInstalledAt(router, any(ControlFlowNode cfg | cfg.getContainer() = container))
      }

      override Node getAChild() { result = MkRouteSetup(this.getARouteSetup()) }

      override Node getLastChild() {
        result = getMostRecentRouteSetupAt(router, container.getExit())
      }

      override Node getFirstChild() {
        result = this.getAChild() and not exists(result.getPreviousSibling())
      }
    }
  }

  /**
   * Like `RouteSetup::Base.isInstalledAt` but with the route setup call mapped to the `MkRouteSetup` node.
   */
  private predicate isInstalledAt(
    RouteSetup setupNode, Router::Range router, ControlFlowNode cfgNode
  ) {
    exists(RouteSetup::Base setup |
      setup.isInstalledAt(router, cfgNode) and
      setupNode = MkRouteSetup(setup)
    )
  }

  /**
   * Gets the route setup most recently performed on `router` at `node`, or in the case of branching control flow,
   * gets any route setup that could be the most recent one.
   */
  private RouteSetup getMostRecentRouteSetupAt(Router::Range router, ControlFlowNode node) {
    isInstalledAt(result, router, node)
    or
    result = getMostRecentRouteSetupAt(router, node.getAPredecessor()) and
    not isInstalledAt(_, router, node)
  }

  /**
   * A call where a mutable router object escapes into a parameter or is returned from a function.
   *
   * This is modeled as a route setup targeting the "local router" value and having
   * the "target router" as its only child.
   *
   * For example,
   * ```js
   * function addMiddleware(r) {
   *   r.use(bodyParser());
   *   r.use(auth());
   * }
   *
   * let app = express();
   * addMiddleware(app); // <-- implied route setup
   * app.get('/', handleRequest);
   * ```
   * here the call to `addMiddleware` is an implied route setup with `app`
   * as the "local router" and `r` as the "target router".
   *
   * The routing tree ends up having the following shape:
   * - `app`
   *   - `addMiddleware(app)`
   *     - `r`
   *       - `r.use()`
   *         - `bodyParser()`
   *       - `r.use()`
   *         - `auth()`
   *   - `app.get(...)`
   *     - `'/'`
   *     - `handleRequest`
   */
  private class ImpliedRouteSetup extends RouteSetup::Base, DataFlow::InvokeNode {
    Router::Range router;
    Function target;

    ImpliedRouteSetup() {
      FlowSteps::calls(this, target) and
      routerIsLiveInContainer(router, target) and
      routerIsLiveInContainer(router, this.getContainer())
    }

    override Routing::Node getChild(int n) { result = MkRouter(router, target) and n = 0 }

    override predicate isInstalledAt(Router::Range r, ControlFlowNode cfgNode) {
      r = router and
      cfgNode = this.getEnclosingExpr()
    }
  }

  /**
   * A function that handles an incoming request.
   */
  class RouteHandler extends Node {
    DataFlow::FunctionNode function;

    RouteHandler() { this = MkValueNode(function) }

    /**
     * Gets the `i`th parameter of this route handler.
     *
     * To find all references to this parameter, use `getParameter(n).ref()`.
     */
    final RouteHandlerParameter getParameter(int n) { result = function.getParameter(n) }

    /**
     * Gets a parameter of this route handler.
     *
     * To find all references to a parameter, use `getAParameter().ref()`.
     */
    final RouteHandlerParameter getAParameter() { result = function.getAParameter() }

    /** Gets the function implementing this route handler. */
    DataFlow::FunctionNode getFunction() { result = function }

    /**
     * Gets a call that delegates the incoming request to the next route handler in the stack,
     * usually a call of the form `next()`.
     *
     * By default, any 0-argument invocation of one of the route handler's parameters
     * is considered a continuation invocation, since the other parameters (request and response)
     * will generally not be invoked as a function. Framework models may override this method
     * if the default behavior is inadequate for that framework.
     */
    DataFlow::CallNode getAContinuationInvocation() {
      result = this.getAParameter().ref().getAnInvocation() and
      result.getNumArgument() = 0
      or
      result.(DataFlow::MethodCallNode).getMethodName() = "then" and
      result.getArgument(0) = this.getAParameter().ref().getALocalUse()
    }
  }

  /**
   * Gets the `RouteHandler` node corresponding to the given function.
   *
   * This has the same result as `getNode(function)` but is declared with a different return type.
   */
  RouteHandler getRouteHandler(DataFlow::FunctionNode function) { result.getFunction() = function }

  /**
   * A parameter to a route handler function.
   */
  class RouteHandlerParameter extends DataFlow::ParameterNode {
    private RouteHandler handler;

    RouteHandlerParameter() { this = handler.getFunction().getAParameter() }

    /** Gets a data flow node referring to this route handler parameter. */
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      result = this
      or
      exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
    }

    /** Gets a data flow node referring to this route handler parameter. */
    DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }

    /**
     * Gets the corresponding route handler, that is, the function on which this is a parameter.
     */
    final RouteHandler getRouteHandler() { result = handler }

    /**
     * Gets a node that is stored in the given access path on this route handler parameter, either
     * during execution of this router handler, or in one of the preceding ones.
     */
    pragma[inline]
    DataFlow::Node getValueFromAccessPath(string path) {
      exists(int i, Node predecessor |
        pragma[only_bind_out](this) = handler.getFunction().getParameter(i) and
        result = getAnAccessPathRhs(predecessor, i, path) and
        (handler.isGuardedByNode(predecessor) or predecessor = handler)
      )
    }
  }

  /**
   * Gets a value that flows into the given access path of the `n`th route handler parameter of `base`.
   *
   * For example,
   * ```js
   * function handler(req, res, next) {
   *   res.locals.foo = 123;
   *   next();
   * }
   * ```
   * the node `123` flows into the `locals.foo` access path on the `res` parameter (`n=1`) of `handler`.
   *
   * Only route handlers that may invoke the continuation (`next()`) are considered, as the effect
   * is otherwise not observable by other route handlers.
   *
   * In addition to the above, also contains implicit assignments contributed by framework models,
   * based on `Node::Range::getValueAtAccessPath`.
   */
  private DataFlow::Node getAnAccessPathRhs(Node base, int n, string path) {
    // Assigned in the body of a route handler function, whi
    exists(RouteHandler handler | base = handler |
      result = AccessPath::getAnAssignmentTo(handler.getParameter(n).ref(), path) and
      exists(handler.getAContinuationInvocation())
    )
    or
    // Implicit assignment contributed by framework model
    exists(DataFlow::Node value, string path1 |
      value = base.getValueImplicitlyStoredInAccessPath(n, path1)
    |
      result = value and path = path1
      or
      exists(string path2 |
        result = AccessPath::getAnAssignmentTo(value.getALocalSource(), path2) and
        path = path1 + "." + path2
      )
    )
  }

  /**
   * Gets a value that refers to the given access path of the `n`th route handler parameter of `base`.
   *
   * For example,
   * ```js
   * function handler2(req, res) {
   *   res.send(res.locals.foo);
   * }
   * ```
   * here the `res.locals.foo` expression refers to the `locals.foo` path on the `res` parameter (`n=1`)
   * of `handler2`.
   */
  private DataFlow::SourceNode getAnAccessPathRead(RouteHandler base, int n, string path) {
    result = AccessPath::getAReferenceTo(base.getParameter(n).ref(), path) and
    not AccessPath::DominatingPaths::hasDominatingWrite(result)
  }

  /**
   * Like `getAnAccessPathRhs` but with `base` mapped to its root node.
   */
  pragma[nomagic]
  private DataFlow::Node getAnAccessPathRhsUnderRoot(RootNode root, int n, string path) {
    result = getAnAccessPathRhs(root.getADescendant(), n, path)
  }

  /**
   * Like `getAnAccessPathRead` but with `base` mapped to its root node.
   */
  pragma[nomagic]
  private DataFlow::SourceNode getAnAccessPathReadUnderRoot(RootNode root, int n, string path) {
    result = getAnAccessPathRead(root.getADescendant(), n, path)
  }

  /**
   * Holds if `pred -> succ` is an API-graph step between access paths on request input objects.
   *
   * Since API graphs are mainly used to propagate type-like information, we do not require
   * a happens-before relation for this step. We only require that we stay within the same
   * web application, which is ensured by having a common root node.
   */
  private predicate middlewareApiStep(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
    exists(RootNode root, int n, string path |
      pred = getAnAccessPathRhsUnderRoot(root, n, path) and
      succ = getAnAccessPathReadUnderRoot(root, n, pragma[only_bind_out](path))
    )
    or
    // We can't augment the call graph as this depends on type tracking, so just
    // manually add steps out of functions stored on a request input.
    exists(DataFlow::FunctionNode function, DataFlow::CallNode call |
      middlewareApiStep(function, call.getCalleeNode().getALocalSource()) and
      pred = function.getReturnNode() and
      succ = call
    )
  }

  /** Contributes `middlewareApiStep` as an API graph step. */
  private class MiddlewareApiStep extends API::AdditionalUseStep {
    override predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
      middlewareApiStep(pred, succ)
    }
  }

  pragma[nomagic]
  private predicate potentialAccessPathStep(
    Node writer, DataFlow::SourceNode pred, Node reader, DataFlow::SourceNode succ, int n,
    string path
  ) {
    pred = getAnAccessPathRhs(writer, n, path) and
    succ = getAnAccessPathRead(reader, n, pragma[only_bind_out](path))
  }

  /**
   * Holds if `pred -> succ` is a data-flow step between access paths on request input objects.
   */
  private predicate middlewareDataFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Node writer, Node reader |
      potentialAccessPathStep(writer, pred, reader, succ, _, _) and
      pragma[only_bind_out](reader).isGuardedByNode(pragma[only_bind_out](writer))
    )
    or
    // Same as in `apiStep`: we can't augment the call graph, so just add flow out
    // of functions stored on a request input.
    exists(DataFlow::FunctionNode function, DataFlow::CallNode call |
      middlewareDataFlowStep(function.getALocalUse(), call.getCalleeNode().getALocalSource()) and
      pred = function.getReturnNode() and
      succ = call
    )
  }

  /** Contributes `middlewareDataFlowStep` as a value-preserving data flow step. */
  private class MiddlewareFlowStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      middlewareDataFlowStep(pred, succ)
    }
  }
}
