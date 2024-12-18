/**
 * Models routing configuration specified using the `ActionDispatch` library, which is part of Rails.
 */

private import codeql.ruby.AST

/**
 * Models routing configuration specified using the `ActionDispatch` library, which is part of Rails.
 */
module Routing {
  /**
   * A block that defines some routes.
   * Route blocks can contribute to the path or controller namespace of their child routes.
   * For example, in the block below
   * ```rb
   * scope path: "/admin" do
   *   get "/dashboard", to: "admin_dashboard#show"
   * end
   * ```
   * the route defined by the call to `get` has the full path `/admin/dashboard`.
   * We track these contributions via `getPathComponent` and `getControllerComponent`.
   */
  abstract private class RouteBlock extends TRouteBlock {
    /**
     * Gets the name of a primary CodeQL class to which this route block belongs.
     */
    string getAPrimaryQlClass() { result = "RouteBlock" }

    /**
     * Gets a string representation of this route block.
     */
    string toString() { none() }

    /**
     * Gets a `Stmt` within this route block.
     */
    abstract Stmt getAStmt();

    /**
     * Gets the parent of this route block, if one exists.
     */
    abstract RouteBlock getParent();

    /**
     * Gets the `n`th parent of this route block.
     * The zeroth parent is this block, the first parent is the direct parent of this block, etc.
     */
    RouteBlock getParent(int n) {
      if n = 0 then result = this else result = this.getParent().getParent(n - 1)
    }

    /**
     * Gets the component of the path defined by this block, if it exists.
     */
    abstract string getPathComponent();

    /**
     * Gets the component of the controller namespace defined by this block, if it exists.
     */
    abstract string getControllerComponent();

    /**
     * Gets the location of this route block.
     */
    abstract Location getLocation();
  }

  /**
   * A route block that is not the top-level block.
   * This block will always have a parent.
   */
  abstract private class NestedRouteBlock extends RouteBlock {
    RouteBlock parent;

    override RouteBlock getParent() { result = parent }

    override string getAPrimaryQlClass() { result = "NestedRouteBlock" }
  }

  /**
   * A top-level routes block.
   * ```rb
   * Rails.application.routes.draw do
   *   ...
   * end
   * ```
   */
  private class TopLevelRouteBlock extends RouteBlock, TTopLevelRouteBlock {
    MethodCall methodCall;
    // Routing blocks create scopes which define the namespace for controllers and paths,
    // though they can be overridden in various ways.
    // The namespaces can differ, so we track them separately.
    Block block;

    TopLevelRouteBlock() { this = TTopLevelRouteBlock(_, methodCall, block) }

    override string getAPrimaryQlClass() { result = "TopLevelRouteBlock" }

    Block getBlock() { result = block }

    override Stmt getAStmt() { result = block.getAStmt() }

    override RouteBlock getParent() { none() }

    override string toString() { result = methodCall.toString() }

    override Location getLocation() { result = methodCall.getLocation() }

    override string getPathComponent() { none() }

    override string getControllerComponent() { none() }
  }

  /**
   * A route block defined by a call to `constraints`.
   * ```rb
   * constraints(foo: /some_regex/) do
   *   get "/posts/:foo", to "posts#something"
   * end
   * ```
   * https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Scoping.html#method-i-constraints
   */
  private class ConstraintsRouteBlock extends NestedRouteBlock, TConstraintsRouteBlock {
    private Block block;
    private MethodCall methodCall;

    ConstraintsRouteBlock() { this = TConstraintsRouteBlock(parent, methodCall, block) }

    override string getAPrimaryQlClass() { result = "ConstraintsRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string getPathComponent() { result = "" }

    override string getControllerComponent() { result = "" }

    override string toString() { result = methodCall.toString() }

    override Location getLocation() { result = methodCall.getLocation() }
  }

  /**
   * A route block defined by a call to `scope`.
   * ```rb
   * scope(path: "/some_path", module: "some_module") do
   *   get "/posts/:foo", to "posts#something"
   * end
   * ```
   * https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Scoping.html#method-i-scope
   */
  private class ScopeRouteBlock extends NestedRouteBlock, TScopeRouteBlock {
    private MethodCall methodCall;
    private Block block;

    ScopeRouteBlock() { this = TScopeRouteBlock(parent, methodCall, block) }

    override string getAPrimaryQlClass() { result = "ScopeRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string toString() { result = methodCall.toString() }

    override Location getLocation() { result = methodCall.getLocation() }

    override string getPathComponent() {
      methodCall.getKeywordArgument("path").getConstantValue().isStringlikeValue(result)
      or
      not exists(methodCall.getKeywordArgument("path")) and
      methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
    }

    override string getControllerComponent() {
      methodCall
          .getKeywordArgument(["controller", "module"])
          .getConstantValue()
          .isStringlikeValue(result)
    }
  }

  private Expr getActionFromMethodCall(MethodCall methodCall) {
    result =
      [
        // e.g. `get "/comments", to: "comments#index"
        methodCall.getKeywordArgument("to"),
        // e.g. `get "/comments" => "comments#index"
        methodCall.getArgument(0).(Pair).getValue()
      ]
  }

  /**
   * Gets a string representation of the controller-action pair that is routed
   * to by this method call.
   */
  private string getActionStringFromMethodCall(MethodCall methodCall) {
    getActionFromMethodCall(methodCall).getConstantValue().isStringlikeValue(result)
    or
    // TODO: use the redirect call argument to resolve the redirect target
    getActionFromMethodCall(methodCall).(MethodCall).getMethodName() = "redirect" and
    result = "<redirect>#<redirect>"
  }

  /**
   * A route block defined by a call to `resources`.
   * ```rb
   * resources :articles do
   *   get "/comments", to "comments#index"
   * end
   * ```
   * https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-resources
   */
  private class ResourcesRouteBlock extends NestedRouteBlock, TResourcesRouteBlock {
    private MethodCall methodCall;
    private Block block;

    ResourcesRouteBlock() { this = TResourcesRouteBlock(parent, methodCall, block) }

    override string getAPrimaryQlClass() { result = "ResourcesRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    /**
     * Gets the `resources` call that gives rise to this route block.
     */
    MethodCall getDefiningMethodCall() { result = methodCall }

    override string getPathComponent() {
      exists(string resource |
        methodCall.getArgument(0).getConstantValue().isStringlikeValue(resource)
      |
        result = resource + "/:" + singularize(resource) + "_id"
      )
    }

    override string getControllerComponent() { result = "" }

    override string toString() { result = methodCall.toString() }

    override Location getLocation() { result = methodCall.getLocation() }
  }

  /**
   * A route block that is guarded by a conditional statement.
   * For example:
   * ```rb
   * if Rails.env.test?
   *   get "/foo/bar", to: "foo#bar"
   * end
   * ```
   * We ignore the condition and analyze both branches to obtain as
   * much routing information as possible.
   */
  private class ConditionalRouteBlock extends NestedRouteBlock, TConditionalRouteBlock {
    private ConditionalExpr e;

    ConditionalRouteBlock() { this = TConditionalRouteBlock(parent, e) }

    override string getAPrimaryQlClass() { result = "ConditionalRouteBlock" }

    override Stmt getAStmt() { result = e.getBranch(_).(StmtSequence).getAStmt() }

    override string getPathComponent() { none() }

    override string getControllerComponent() { none() }

    override string toString() { result = e.toString() }

    override Location getLocation() { result = e.getLocation() }
  }

  /**
   * A route block defined by a call to `namespace`.
   * ```rb
   * namespace :admin do
   *   resources :posts
   * end
   * ```
   * https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Scoping.html#method-i-namespace
   */
  private class NamespaceRouteBlock extends NestedRouteBlock, TNamespaceRouteBlock {
    private MethodCall methodCall;
    private Block block;

    NamespaceRouteBlock() { this = TNamespaceRouteBlock(parent, methodCall, block) }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string getPathComponent() { result = this.getNamespace() }

    override string getControllerComponent() { result = this.getNamespace() }

    private string getNamespace() {
      methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
    }

    override string toString() { result = methodCall.toString() }

    override Location getLocation() { result = methodCall.getLocation() }
  }

  /**
   * A route configuration. This defines a combination of HTTP method and URL
   * path which should be routed to a particular controller-action pair.
   * This can arise from an explicit call to a routing method, for example:
   * ```rb
   * get "/photos", to: "photos#index"
   * ```
   * or via a convenience method like `resources`, which defines multiple routes at once:
   * ```rb
   * resources :photos
   * ```
   */
  class Route extends TRoute instanceof RouteImpl {
    /**
     * Gets the name of a primary CodeQL class to which this route belongs.
     */
    string getAPrimaryQlClass() { result = "Route" }

    /** Gets a string representation of this route. */
    string toString() { result = super.toString() }

    /**
     * Gets the location of the method call that defines this route.
     */
    Location getLocation() { result = super.getLocation() }

    /**
     * Gets the full controller targeted by this route.
     */
    string getController() { result = super.getController() }

    /**
     * Gets the action targeted by this route.
     */
    string getAction() { result = super.getAction() }

    /**
     * Gets the HTTP method of this route.
     * The result is one of [get, post, put, patch, delete].
     */
    string getHttpMethod() { result = super.getHttpMethod() }

    /**
     * Gets the full path of the route.
     */
    string getPath() { result = super.getPath() }

    /**
     * Get a URL capture. This is a wildcard URL segment whose value is placed in `params`.
     * For example, in
     * ```ruby
     * get "/foo/:bar/baz", to: "users#index"
     * ```
     * the capture is `:bar`.
     */
    string getACapture() { result = super.getACapture() }
  }

  /**
   * The implementation of `Route`.
   * This class is abstract and is thus kept private so we don't expose it to
   * users.
   * Extend this class to add new instances of routes.
   */
  abstract private class RouteImpl extends TRoute {
    /**
     * Gets the name of a primary CodeQL class to which this route belongs.
     */
    string getAPrimaryQlClass() { result = "RouteImpl" }

    MethodCall methodCall;

    /** Gets a string representation of this route. */
    string toString() { result = methodCall.toString() }

    /**
     * Gets the location of the method call that defines this route.
     */
    Location getLocation() { result = methodCall.getLocation() }

    /**
     * Gets the method call that defines this route.
     */
    MethodCall getDefiningMethodCall() { result = methodCall }

    /**
     * Get the last component of the path. For example, in
     * ```rb
     * get "/photos", to: "photos#index"
     * ```
     * this is `/photos`.
     * If the string has any interpolations, this predicate will have no result.
     */
    abstract string getLastPathComponent();

    /**
     * Gets the HTTP method of this route.
     * The result is one of [get, post, put, patch, delete].
     */
    abstract string getHttpMethod();

    /**
     * Gets the last controller component.
     * This is the controller specified in the route itself.
     */
    abstract string getLastControllerComponent();

    /**
     * Gets a component of the controller.
     * This behaves identically to `getPathComponent`, but for controller information.
     */
    string getControllerComponent(int n) {
      if n = 0
      then result = this.getLastControllerComponent()
      else result = this.getParentBlock().getParent(n - 1).getControllerComponent()
    }

    /**
     * Gets the full controller targeted by this route.
     */
    string getController() {
      result =
        concat(int n |
          this.getControllerComponent(n) != ""
        |
          this.getControllerComponent(n), "/" order by n desc
        )
    }

    /**
     * Gets the action targeted by this route.
     */
    abstract string getAction();

    /**
     * Gets the parent `RouteBlock` of this route.
     */
    abstract RouteBlock getParentBlock();

    /**
     * Gets a component of the path. Components are numbered from 0 up, where 0
     * is the last component, 1 is the second-last, etc.
     * For example, in the following route:
     *
     * ```rb
     * namespace path: "foo" do
     *   namespace path: "bar" do
     *     get "baz", to: "foo#bar
     *   end
     * end
     * ```
     *
     * the components are:
     *
     * | n | component
     * |---|----------
     * | 0 | baz
     * | 1 | bar
     * | 2 | foo
     */
    string getPathComponent(int n) {
      if n = 0
      then result = this.getLastPathComponent()
      else result = this.getParentBlock().getParent(n - 1).getPathComponent()
    }

    /**
     * Gets the full path of the route.
     */
    string getPath() {
      result =
        concat(int n |
          this.getPathComponent(n) != ""
        |
          // Strip leading and trailing slashes from each path component before combining
          stripSlashes(this.getPathComponent(n)), "/" order by n desc
        )
    }

    /**
     * Get a URL capture. This is a wildcard URL segment whose value is placed in `params`.
     * For example, in
     * ```ruby
     * get "/foo/:bar/baz", to: "users#index"
     * ```
     * the capture is `:bar`.
     * We don't currently make use of this, but it may be useful in future to more accurately
     * model the contents of the `params` hash.
     */
    string getACapture() { result = this.getPathComponent(_).regexpFind(":[^:/]+", _, _) }
  }

  /**
   * A route generated by an explicit call to `get`, `post`, etc.
   *
   * ```ruby
   * get "/photos", to: "photos#index"
   * put "/photos/:id", to: "photos#update"
   * ```
   */
  private class ExplicitRoute extends RouteImpl, TExplicitRoute {
    RouteBlock parentBlock;

    ExplicitRoute() { this = TExplicitRoute(parentBlock, methodCall) }

    override string getAPrimaryQlClass() { result = "ExplicitRoute" }

    override RouteBlock getParentBlock() { result = parentBlock }

    override string getLastPathComponent() {
      methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
    }

    override string getLastControllerComponent() {
      methodCall.getKeywordArgument("controller").getConstantValue().isStringlikeValue(result)
      or
      not exists(methodCall.getKeywordArgument("controller")) and
      (
        result = extractController(this.getActionString())
        or
        // If controller is not specified, and we're in a `resources` route block, use the controller of that route.
        // For example, in
        //
        // resources :posts do
        //   get "timestamp", to: :timestamp
        // end
        //
        // The route is GET /posts/:post_id/timestamp => posts/timestamp
        not exists(extractController(this.getActionString())) and
        exists(ResourcesRoute r |
          r.getDefiningMethodCall() = parentBlock.(ResourcesRouteBlock).getDefiningMethodCall()
        |
          result = r.getLastControllerComponent()
        )
      )
    }

    private string getActionString() { result = getActionStringFromMethodCall(methodCall) }

    override string getAction() {
      // get "/photos", action: "index"
      methodCall.getKeywordArgument("action").getConstantValue().isStringlikeValue(result)
      or
      not exists(methodCall.getKeywordArgument("action")) and
      (
        // get "/photos", to: "photos#index"
        // get "/photos", to: redirect("some_url")
        result = extractAction(this.getActionString())
        or
        // resources :photos, only: [] do
        //   get "/", to: "index"
        // end
        not exists(extractAction(this.getActionString())) and result = this.getActionString()
        or
        // get :some_action
        not exists(this.getActionString()) and
        methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
      )
    }

    override string getHttpMethod() { result = methodCall.getMethodName().toString() }
  }

  /**
   * A route generated by a call to `resources`.
   *
   * ```ruby
   * resources :photos
   * ```
   * This creates eight routes, equivalent to the following code:
   * ```ruby
   * get "/photos", to: "photos#index"
   * get "/photos/new", to: "photos#new"
   * post "/photos", to: "photos#create"
   * get "/photos/:id", to: "photos#show"
   * get "/photos/:id/edit", to: "photos#edit"
   * patch "/photos/:id", to: "photos#update"
   * put "/photos/:id", to: "photos#update"
   * delete "/photos/:id", to: "photos#delete"
   * ```
   *
   * `resources` can take a block. Any routes defined inside the block will inherit a path component of
   * `/<resource>/:<resource>_id`. For example:
   *
   * ```ruby
   * resources :photos do
   *   get "/foo", to: "photos#foo"
   * end
   * ```
   * This creates the eight default routes, plus one more, which is nested under "/photos/:photo_id", equivalent to:
   * ```ruby
   * get "/photos/:photo_id/foo", to: "photos#foo"
   * ```
   */
  private class ResourcesRoute extends RouteImpl, TResourcesRoute {
    RouteBlock parent;
    string action;
    string httpMethod;
    string pathComponent;

    ResourcesRoute() {
      exists(string resource |
        this = TResourcesRoute(parent, methodCall, action) and
        methodCall.getArgument(0).getConstantValue().isStringlikeValue(resource) and
        isDefaultResourceRoute(resource, httpMethod, pathComponent, action)
      )
    }

    override string getAPrimaryQlClass() { result = "ResourcesRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() { result = pathComponent }

    override string getLastControllerComponent() {
      methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
    }

    override string getAction() { result = action }

    override string getHttpMethod() { result = httpMethod }
  }

  /**
   * A route generated by a call to `resource`.
   * This is like a `resources` route, but creates routes for a singular resource.
   * This means there's no index route, no id parameter, and the resource name is expected to be singular.
   * It will still be routed to a pluralised controller name.
   * ```ruby
   * resource :account
   * ```
   */
  private class SingularResourceRoute extends RouteImpl, TResourceRoute {
    RouteBlock parent;
    string action;
    string httpMethod;
    string pathComponent;

    SingularResourceRoute() {
      exists(string resource |
        this = TResourceRoute(parent, methodCall, action) and
        methodCall.getArgument(0).getConstantValue().isStringlikeValue(resource) and
        isDefaultSingularResourceRoute(resource, httpMethod, pathComponent, action)
      )
    }

    override string getAPrimaryQlClass() { result = "SingularResourceRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() { result = pathComponent }

    override string getLastControllerComponent() {
      methodCall.getArgument(0).getConstantValue().isStringlikeValue(result)
    }

    override string getAction() { result = action }

    override string getHttpMethod() { result = httpMethod }
  }

  /**
   * A route generated by a call to `match`.
   * This is a lower level primitive that powers `get`, `post` etc.
   * The first argument can be a path or a (path, controller-action) pair.
   * The controller, action and HTTP method can be specified with the
   * `controller:`, `action:` and `via:` keyword arguments, respectively.
   * ```ruby
   * match 'photos/:id' => 'photos#show', via: :get
   * match 'photos/:id', to: 'photos#show', via: :get
   * match 'photos/:id', to 'photos#show', via: [:get, :post]
   * match 'photos/:id', controller: 'photos', action: 'show', via: :get
   * ```
   */
  private class MatchRoute extends RouteImpl, TMatchRoute {
    private RouteBlock parent;

    MatchRoute() { this = TMatchRoute(parent, methodCall) }

    override string getAPrimaryQlClass() { result = "MatchRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() {
      [methodCall.getArgument(0), methodCall.getArgument(0).(Pair).getKey()]
          .getConstantValue()
          .isStringlikeValue(result)
    }

    override string getLastControllerComponent() {
      result = extractController(getActionStringFromMethodCall(methodCall)) or
      methodCall.getKeywordArgument("controller").getConstantValue().isStringlikeValue(result) or
      result =
        extractController(methodCall
              .getArgument(0)
              .(Pair)
              .getValue()
              .getConstantValue()
              .getStringlikeValue())
    }

    override string getHttpMethod() {
      exists(string via |
        methodCall.getKeywordArgument("via").getConstantValue().isStringlikeValue(via)
      |
        via = "all" and result = anyHttpMethod()
        or
        via != "all" and result = via
      )
      or
      result =
        methodCall
            .getKeywordArgument("via")
            .(ArrayLiteral)
            .getElement(_)
            .getConstantValue()
            .getStringlikeValue()
    }

    override string getAction() {
      result = extractAction(getActionStringFromMethodCall(methodCall)) or
      methodCall.getKeywordArgument("action").getConstantValue().isStringlikeValue(result) or
      result =
        extractAction(methodCall
              .getArgument(0)
              .(Pair)
              .getValue()
              .getConstantValue()
              .getStringlikeValue())
    }
  }

  private import Cached

  /**
   * This module contains the IPA types backing `RouteBlock` and `Route`, cached for performance.
   */
  cached
  private module Cached {
    cached
    newtype TRouteBlock =
      TTopLevelRouteBlock(MethodCall routes, MethodCall draw, Block b) {
        routes.getMethodName() = "routes" and
        draw.getMethodName() = "draw" and
        draw.getReceiver() = routes and
        draw.getBlock() = b
      } or
      // constraints(foo: /some_regex/) do
      //   get "/posts/:foo", to "posts#something"
      // end
      TConstraintsRouteBlock(RouteBlock parent, MethodCall constraints, Block b) {
        parent.getAStmt() = constraints and
        constraints.getMethodName() = "constraints" and
        constraints.getBlock() = b
      } or
      // scope(path: "/some_path", module: "some_module") do
      //   get "/posts/:foo", to "posts#something"
      // end
      TScopeRouteBlock(RouteBlock parent, MethodCall scope, Block b) {
        parent.getAStmt() = scope and scope.getMethodName() = "scope" and scope.getBlock() = b
      } or
      // resources :articles do
      //   get "/comments", to "comments#index"
      // end
      TResourcesRouteBlock(RouteBlock parent, MethodCall resources, Block b) {
        parent.getAStmt() = resources and
        resources.getMethodName() = "resources" and
        resources.getBlock() = b
      } or
      // A conditional statement guarding some routes.
      // We ignore the condition and analyze both branches to obtain as
      // much routing information as possible.
      TConditionalRouteBlock(RouteBlock parent, ConditionalExpr e) { parent.getAStmt() = e } or
      // namespace :admin do
      //   resources :posts
      // end
      TNamespaceRouteBlock(RouteBlock parent, MethodCall namespace, Block b) {
        parent.getAStmt() = namespace and
        namespace.getMethodName() = "namespace" and
        namespace.getBlock() = b
      }

    /**
     * A route configuration. See `Route` for more info
     */
    cached
    newtype TRoute =
      /**
       * See `ExplicitRoute`
       */
      TExplicitRoute(RouteBlock b, MethodCall m) {
        b.getAStmt() = m and m.getMethodName() = anyHttpMethod()
      } or
      /**
       * See `ResourcesRoute`
       */
      TResourcesRoute(RouteBlock b, MethodCall m, string action) {
        b.getAStmt() = m and
        m.getMethodName() = "resources" and
        action in ["show", "index", "new", "edit", "create", "update", "destroy"] and
        applyActionFilters(m, action)
      } or
      /**
       * See `SingularResourceRoute`
       */
      TResourceRoute(RouteBlock b, MethodCall m, string action) {
        b.getAStmt() = m and
        m.getMethodName() = "resource" and
        action in ["show", "new", "edit", "create", "update", "destroy"] and
        applyActionFilters(m, action)
      } or
      /**
       * See `MatchRoute`
       */
      TMatchRoute(RouteBlock b, MethodCall m) { b.getAStmt() = m and m.getMethodName() = "match" }
  }

  /**
   * Several routing methods support the keyword arguments `only:` and `except:`.
   * - `only:` restricts the set of actions to just those in the argument.
   * - `except:` removes the given actions from the set.
   */
  bindingset[action]
  private predicate applyActionFilters(MethodCall m, string action) {
    // Respect the `only` keyword argument, which restricts the set of actions.
    (
      not exists(m.getKeywordArgument("only"))
      or
      exists(Expr only | only = m.getKeywordArgument("only") |
        [only.(ArrayLiteral).getElement(_), only].getConstantValue().isStringlikeValue(action)
      )
    ) and
    // Respect the `except` keyword argument, which removes actions from the default set.
    (
      not exists(m.getKeywordArgument("except"))
      or
      exists(Expr except | except = m.getKeywordArgument("except") |
        [except.(ArrayLiteral).getElement(_), except].getConstantValue().getStringlikeValue() !=
          action
      )
    )
  }

  /**
   * Holds if the (resource, httpMethod, path, action) combination would be generated by a call to `resources :<resource>`.
   */
  bindingset[resource]
  private predicate isDefaultResourceRoute(
    string resource, string httpMethod, string path, string action
  ) {
    action = "create" and
    (httpMethod = "post" and path = "/" + resource)
    or
    action = "index" and
    (httpMethod = "get" and path = "/" + resource)
    or
    action = "new" and
    (httpMethod = "get" and path = "/" + resource + "/new")
    or
    action = "edit" and
    (httpMethod = "get" and path = "/" + resource + ":id/edit")
    or
    action = "show" and
    (httpMethod = "get" and path = "/" + resource + "/:id")
    or
    action = "update" and
    (httpMethod in ["put", "patch"] and path = "/" + resource + "/:id")
    or
    action = "destroy" and
    (httpMethod = "delete" and path = "/" + resource + "/:id")
  }

  /**
   * Holds if the (resource, httpMethod, path, action) combination would be generated by a call to `resource :<resource>`.
   */
  bindingset[resource]
  private predicate isDefaultSingularResourceRoute(
    string resource, string httpMethod, string path, string action
  ) {
    action = "create" and
    (httpMethod = "post" and path = "/" + resource)
    or
    action = "new" and
    (httpMethod = "get" and path = "/" + resource + "/new")
    or
    action = "edit" and
    (httpMethod = "get" and path = "/" + resource + "/edit")
    or
    action = "show" and
    (httpMethod = "get" and path = "/" + resource)
    or
    action = "update" and
    (httpMethod in ["put", "patch"] and path = "/" + resource)
    or
    action = "destroy" and
    (httpMethod = "delete" and path = "/" + resource)
  }

  /**
   * Extract the controller from a Rails routing string
   * ```
   * extractController("posts#show") = "posts"
   * ```
   */
  bindingset[input]
  private string extractController(string input) { result = input.regexpCapture("([^#]+)#.+", 1) }

  /**
   * Extract the action from a Rails routing string
   * ```
   * extractAction("posts#show") = "show"
   */
  bindingset[input]
  private string extractAction(string input) { result = input.regexpCapture("[^#]+#(.+)", 1) }

  /**
   * Returns the lowercase name of every HTTP method we support.
   */
  private string anyHttpMethod() { result = ["get", "post", "put", "patch", "delete"] }

  /**
   * The inverse of `pluralize`. If `input` is a plural word, it returns the
   * singular version.
   *
   * Examples:
   *
   * - photos -> photo
   * - stories -> story
   * - not_plural -> not_plural
   */
  bindingset[input]
  private string singularize(string input) {
    exists(string prefix | prefix = input.regexpCapture("(.*)ies", 1) | result = prefix + "y")
    or
    not input.matches("%ies") and
    exists(string prefix | prefix = input.regexpCapture("(.*)s", 1) | result = prefix)
    or
    not input.regexpMatch(".*(ies|s)") and result = input
  }

  /**
   * Convert a camel-case string to underscore case. Converts `::` to `/`.
   * This can be used to convert ActiveRecord controller names to a canonical form that matches the routes they handle.
   * Note: All-uppercase words like `CONSTANT` are not handled correctly.
   */
  bindingset[base]
  string underscore(string base) {
    base = "" and result = ""
    or
    result =
      base.charAt(0).toLowerCase() +
        // Walk along the string, keeping track of the previous character
        // in order to determine if we've crossed a boundary.
        // Boundaries are:
        // - lower case to upper case: B in FooBar
        // - entering a namespace: B in Foo::Bar
        concat(int i, string prev, string char |
          prev = base.charAt(i) and
          char = base.charAt(i + 1)
        |
          any(string s |
              char.regexpMatch("[A-Za-z0-9]") and
              if prev = ":"
              then s = "/" + char.toLowerCase()
              else
                if prev.isLowercase() and char.isUppercase()
                then s = "_" + char.toLowerCase()
                else s = char.toLowerCase()
            )
          order by
            i
        )
  }

  /**
   * Strip leading and trailing forward slashes from the string.
   */
  bindingset[input]
  private string stripSlashes(string input) {
    result = input.regexpReplaceAll("^/+(.+)$", "$1").regexpReplaceAll("^(.*[^/])/+$", "$1")
  }
}
