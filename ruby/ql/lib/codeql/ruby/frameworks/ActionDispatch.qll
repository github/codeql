private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

module ActionDispatch {
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
    TNamespaceRouteBlock(RouteBlock parent, MethodCall namespace, Block b) {
      parent.getAStmt() = namespace and
      namespace.getMethodName() = "namespace" and
      namespace.getBlock() = b
    }

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
  abstract class RouteBlock extends TRouteBlock {
    string getAPrimaryQlClass() { result = "RouteBlock" }

    string toString() { none() }

    abstract Stmt getAStmt();

    abstract RouteBlock getParent();

    RouteBlock getParent(int n) {
      if n = 0 then result = this else result = getParent().getParent(n - 1)
    }

    abstract string getPathComponent();

    abstract string getControllerComponent();

    abstract Location getLocation();
  }

  abstract class NestedRouteBlock extends RouteBlock {
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
  class TopLevelRouteBlock extends RouteBlock, TTopLevelRouteBlock {
    MethodCall call;
    // Routing blocks create scopes which define the namespace for controllers and paths,
    // though they can be overridden in various ways.
    // The namespaces can differ, so we track them separately.
    Block block;

    TopLevelRouteBlock() { this = TTopLevelRouteBlock(_, call, block) }

    override string getAPrimaryQlClass() { result = "TopLevelRouteBlock" }

    Block getBlock() { result = block }

    override Stmt getAStmt() { result = block.getAStmt() }

    override RouteBlock getParent() { none() }

    override string toString() { result = call.toString() }

    override Location getLocation() { result = call.getLocation() }

    override string getPathComponent() { none() }

    override string getControllerComponent() { none() }
  }

  class ConstraintsRouteBlock extends NestedRouteBlock, TConstraintsRouteBlock {
    private Block block;
    private MethodCall call;

    ConstraintsRouteBlock() { this = TConstraintsRouteBlock(parent, call, block) }

    override string getAPrimaryQlClass() { result = "ConstraintsRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string getPathComponent() { result = "" }

    override string getControllerComponent() { result = "" }

    override string toString() { result = call.toString() }

    override Location getLocation() { result = call.getLocation() }
  }

  class ScopeRouteBlock extends NestedRouteBlock, TScopeRouteBlock {
    private MethodCall call;
    private Block block;

    ScopeRouteBlock() { this = TScopeRouteBlock(parent, call, block) }

    override string getAPrimaryQlClass() { result = "ScopeRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string toString() { result = call.toString() }

    override Location getLocation() { result = call.getLocation() }

    override string getPathComponent() {
      result = call.getKeywordArgument("path").(StringlikeLiteral).getValueText()
      or
      not exists(call.getKeywordArgument("path")) and
      result = call.getArgument(0).(StringlikeLiteral).getValueText()
    }

    override string getControllerComponent() {
      result = call.getKeywordArgument("controller").getValueText() or
      result = call.getKeywordArgument("module").getValueText()
    }

    string getACapture() { result = getPathComponent().regexpFind(":[^:/]+", _, _) }
  }

  class ResourcesRouteBlock extends NestedRouteBlock, TResourcesRouteBlock {
    private MethodCall call;
    private Block block;

    ResourcesRouteBlock() { this = TResourcesRouteBlock(parent, call, block) }

    override string getAPrimaryQlClass() { result = "ResourcesRouteBlock" }

    override Stmt getAStmt() { result = block.getAStmt() }

    MethodCall getDefiningMethodCall() { result = call }

    override string getPathComponent() {
      exists(string resource | resource = call.getArgument(0).getValueText() |
        result = resource + "/:" + singularize(resource) + "_id"
      )
    }

    override string getControllerComponent() { result = "" }

    override string toString() { result = call.toString() }

    override Location getLocation() { result = call.getLocation() }
  }

  class ConditionalRouteBlock extends NestedRouteBlock, TConditionalRouteBlock {
    private ConditionalExpr e;

    ConditionalRouteBlock() { this = TConditionalRouteBlock(parent, e) }

    override string getAPrimaryQlClass() { result = "ConditionalRouteBlock" }

    override Stmt getAStmt() { result = e.getBranch(_).(StmtSequence).getAStmt() }

    override string getPathComponent() { none() }

    override string getControllerComponent() { none() }

    override string toString() { result = e.toString() }

    override Location getLocation() { result = e.getLocation() }
  }

  class NamespaceRouteBlock extends NestedRouteBlock, TNamespaceRouteBlock {
    private MethodCall call;
    private Block block;

    NamespaceRouteBlock() { this = TNamespaceRouteBlock(parent, call, block) }

    override Stmt getAStmt() { result = block.getAStmt() }

    override string getPathComponent() { result = getNamespace() }

    override string getControllerComponent() { result = getNamespace() }

    string getNamespace() { result = call.getArgument(0).getValueText() }

    override string toString() { result = call.toString() }

    override Location getLocation() { result = call.getLocation() }
  }

  newtype TRoute =
    TExplicitRoute(RouteBlock b, MethodCall m) {
      b.getAStmt() = m and m.getMethodName() in ["get", "post", "put", "patch", "delete"]
    } or
    TResourcesRoute(RouteBlock b, MethodCall m, string action) {
      b.getAStmt() = m and
      m.getMethodName() = "resources" and
      action in ["show", "index", "new", "edit", "create", "update", "destroy"] and
      applyActionFilters(m, action)
    } or
    TResourceRoute(RouteBlock b, MethodCall m, string action) {
      b.getAStmt() = m and
      m.getMethodName() = "resource" and
      action in ["show", "new", "edit", "create", "update", "destroy"] and
      applyActionFilters(m, action)
    } or
    TMatchRoute(RouteBlock b, MethodCall m) { b.getAStmt() = m and m.getMethodName() = "match" }

  /**
   * Several routing methods support the keyword arguments `only:` and `except:`.
   * - `only:` restricts the set of actions to just those in the argument.
   * - `except:` removes the given actions from the set.
   */
  bindingset[action]
  predicate applyActionFilters(MethodCall m, string action) {
    // Respect the `only` keyword argument, which restricts the set of actions.
    (
      not exists(m.getKeywordArgument("only"))
      or
      exists(Expr only | only = m.getKeywordArgument("only") |
        [only.(ArrayLiteral).getElement(_), only.(StringlikeLiteral)].getValueText() = action
      )
    ) and
    // Respect the `except` keyword argument, which removes actions from the default set.
    (
      not exists(m.getKeywordArgument("except"))
      or
      exists(Expr except | except = m.getKeywordArgument("except") |
        [except.(ArrayLiteral).getElement(_), except.(StringlikeLiteral)].getValueText() != action
      )
    )
  }

  abstract class Route extends TRoute {
    string getAPrimaryQlClass() { result = "Route" }

    MethodCall method;

    string toString() { result = method.toString() }

    Location getLocation() { result = method.getLocation() }

    MethodCall getDefiningMethodCall() { result = method }

    /**
     * Get the last component of the path. For example, in
     * ```rb
     * get "/photos", to: "photos#index"
     * ```
     * this is `/photos`.
     * If the string has any interpolations, this predicate will have no result.
     */
    abstract string getLastPathComponent();

    abstract string getHTTPMethod();

    abstract string getLastControllerComponent();

    string getControllerComponent(int n) {
      if n = 0
      then result = getLastControllerComponent()
      else result = getParentBlock().getParent(n - 1).getControllerComponent()
    }

    string getController() {
      result =
        concat(int n |
          getControllerComponent(n) != ""
        |
          getControllerComponent(n), "/" order by n desc
        )
    }

    abstract string getAction();

    abstract RouteBlock getParentBlock();

    string getPathComponent(int n) {
      if n = 0
      then result = getLastPathComponent()
      else result = getParentBlock().getParent(n - 1).getPathComponent()
    }

    string getPath() {
      result =
        concat(int n |
          getPathComponent(n) != ""
        |
          // Strip leading and trailing slashes from each path component before combining
          stripSlashes(getPathComponent(n)), "/" order by n desc
        )
    }
  }

  /**
   * A route generated by an explicit call to `get`, `post`, etc.
   *
   * ```ruby
   * get "/photos", to: "photos#index"
   * put "/photos/:id", to: "photos#update"
   * ```
   */
  class ExplicitRoute extends Route, TExplicitRoute {
    RouteBlock parentBlock;

    ExplicitRoute() { this = TExplicitRoute(parentBlock, method) }

    override string getAPrimaryQlClass() { result = "ExplicitRoute" }

    override RouteBlock getParentBlock() { result = parentBlock }

    override string getLastPathComponent() {
      result = method.getArgument(0).(StringlikeLiteral).getValueText()
    }

    override string getLastControllerComponent() {
      result = method.getKeywordArgument("controller").getValueText()
      or
      not exists(method.getKeywordArgument("controller")) and
      (
        result = extractController(this.getActionString())
        or
        // If not controller is specified, and we're in a `resources` route block, use the controller of that route.
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

    string getActionString() {
      result = method.getKeywordArgument("to").(StringlikeLiteral).getValueText()
      or
      method.getKeywordArgument("to").(MethodCall).getMethodName() = "redirect" and
      result = "<redirect>#<redirect>"
    }

    override string getAction() {
      // get "/photos", action: "index"
      result = method.getKeywordArgument("action").getValueText()
      or
      not exists(method.getKeywordArgument("action")) and
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
        result = method.getArgument(0).(StringlikeLiteral).getValueText()
      )
    }

    override string getHTTPMethod() { result = method.getMethodName().toString() }
  }

  /**
   * A route generated by a call to `resources`.
   *
   * ## Default behaviour
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
   * ## Nested routes
   *
   * ```ruby
   * resources :photos do
   *   get "/foo", to: "photos#foo"
   * end
   * ```
   * This creates the eight default routes, plus one more, which is nested under "/photos/:photo_id":
   * ```ruby
   * get "/photos/:photo_id/foo", to: "photos#foo"
   * ```
   */
  class ResourcesRoute extends Route, TResourcesRoute {
    RouteBlock parent;
    string resource;
    string action;
    string httpMethod;
    string pathComponent;

    ResourcesRoute() {
      this = TResourcesRoute(parent, method, action) and
      resource = method.getArgument(0).(StringlikeLiteral).getValueText() and
      isDefaultResourceRoute(resource, httpMethod, pathComponent, action)
    }

    override string getAPrimaryQlClass() { result = "ResourcesRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() { result = pathComponent }

    override string getLastControllerComponent() { result = method.getArgument(0).getValueText() }

    override string getAction() { result = action }

    override string getHTTPMethod() { result = httpMethod }

    string getResource() { result = resource }
  }

  /**
   * Like a `resources` route, but creates routes for a singular resource.
   * This means there's no index route, no id parameter, and the resource name is expected to be singular.
   * It will still be routed to a pluralised controller name.
   * ```ruby
   * resource :account
   * ```
   */
  class SingularResourceRoute extends Route, TResourceRoute {
    RouteBlock parent;
    string resource;
    string action;
    string httpMethod;
    string pathComponent;

    SingularResourceRoute() {
      this = TResourceRoute(parent, method, action) and
      resource = method.getArgument(0).(StringlikeLiteral).getValueText() and
      isDefaultSingularResourceRoute(resource, httpMethod, pathComponent, action)
    }

    override string getAPrimaryQlClass() { result = "SingularResourceRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() { result = pathComponent }

    override string getLastControllerComponent() { result = method.getArgument(0).getValueText() }

    override string getAction() { result = action }

    override string getHTTPMethod() { result = httpMethod }

    MethodCall getMethodCall() { result = method }
  }

  /**
   * ```ruby
   * match 'photos/:id' => 'photos#show', via: :get
   * match 'photos/:id', to: 'photos#show', via: :get
   * match 'photos/:id', controller: 'photos', action: 'show', via: :get
   * ```
   */
  class MatchRoute extends Route, TMatchRoute {
    private RouteBlock parent;

    MatchRoute() { this = TMatchRoute(parent, method) }

    override string getAPrimaryQlClass() { result = "MatchRoute" }

    override RouteBlock getParentBlock() { result = parent }

    override string getLastPathComponent() {
      result = method.getArgument(0).(StringlikeLiteral).getValueText() or
      result = method.getArgument(0).(Pair).getKey().getValueText()
    }

    override string getLastControllerComponent() {
      result = extractController(method.getKeywordArgument("to").getValueText()) or
      result = method.getKeywordArgument("controller").getValueText() or
      result = extractController(method.getArgument(0).(Pair).getValue().getValueText())
    }

    override string getHTTPMethod() {
      result = method.getKeywordArgument("via").(StringlikeLiteral).getValueText() or
      result = method.getKeywordArgument("via").(ArrayLiteral).getElement(_).getValueText()
    }

    override string getAction() {
      result = extractAction(method.getKeywordArgument("to").getValueText()) or
      result = method.getKeywordArgument("action").getValueText() or
      result = extractAction(method.getArgument(0).(Pair).getValue().getValueText())
    }
  }

  /**
   * Holds if the (resource, method, path, action) combination would be generated by a call to `resources :<resource>`.
   */
  bindingset[resource]
  predicate isDefaultResourceRoute(string resource, string method, string path, string action) {
    action = "create" and
    (method = "post" and path = "/" + resource)
    or
    action = "index" and
    (method = "get" and path = "/" + resource)
    or
    action = "new" and
    (method = "get" and path = "/" + resource + "/new")
    or
    action = "edit" and
    (method = "get" and path = "/" + resource + ":id/edit")
    or
    action = "show" and
    (method = "get" and path = "/" + resource + "/:id")
    or
    action = "update" and
    (method in ["put", "patch"] and path = "/" + resource + "/:id")
    or
    action = "destroy" and
    (method = "delete" and path = "/" + resource + "/:id")
  }

  /**
   * Holds if the (resource, method, path, action) combination would be generated by a call to `resource :<resource>`.
   */
  bindingset[resource]
  predicate isDefaultSingularResourceRoute(
    string resource, string method, string path, string action
  ) {
    action = "create" and
    (method = "post" and path = "/" + resource)
    or
    action = "new" and
    (method = "get" and path = "/" + resource + "/new")
    or
    action = "edit" and
    (method = "get" and path = "/" + resource + "/edit")
    or
    action = "show" and
    (method = "get" and path = "/" + resource)
    or
    action = "update" and
    (method in ["put", "patch"] and path = "/" + resource)
    or
    action = "destroy" and
    (method = "delete" and path = "/" + resource)
  }

  /**
   * Extract the controller from a Rails routing string
   * ```
   * extractController("posts#show") = "posts"
   */
  bindingset[input]
  string extractController(string input) { result = input.regexpCapture("([^#]+)#.+", 1) }

  /**
   * Extract the action from a Rails routing string
   * ```
   * extractController("posts#show") = "show"
   */
  bindingset[input]
  string extractAction(string input) { result = input.regexpCapture("[^#]+#(.+)", 1) }

  /**
   * A basic pluralizer for English strings.
   * photo => photos
   * story => stories
   * TODO: remove?
   */
  bindingset[input]
  string pluralize(string input) {
    exists(string prefix | prefix = input.regexpCapture("(.*)y", 1) | result = prefix + "ies")
    or
    not input.regexpMatch(".*y") and
    result = input + "s"
  }

  /**
   * The inverse of `pluralize`
   * photos => photo
   * stories => story
   * not_plural => not_plural
   */
  bindingset[input]
  string singularize(string input) {
    exists(string prefix | prefix = input.regexpCapture("(.*)ies", 1) | result = prefix + "y")
    or
    not input.regexpMatch(".*ies") and
    exists(string prefix | prefix = input.regexpCapture("(.*)s", 1) | result = prefix)
    or
    not input.regexpMatch(".*(ies|s)") and result = input
  }

  /**
   * Convert a camel-case string to underscore case. Converts `::` to `/`.
   * This can be used to convert ActiveRecord controller names to a canonical form that matches the routes they handle.
   * Note: All-uppercase words like `CONSTANT` are not handled correctly.
   * TODO: is there a more concise way to write this?
   */
  bindingset[input]
  string underscore(string input) {
    result =
      decapitalize(input
            .regexpReplaceAll("([^:])A", "$1_a")
            .regexpReplaceAll("([^:])B", "$1_b")
            .regexpReplaceAll("([^:])C", "$1_c")
            .regexpReplaceAll("([^:])D", "$1_d")
            .regexpReplaceAll("([^:])E", "$1_e")
            .regexpReplaceAll("([^:])F", "$1_f")
            .regexpReplaceAll("([^:])G", "$1_g")
            .regexpReplaceAll("([^:])H", "$1_h")
            .regexpReplaceAll("([^:])I", "$1_i")
            .regexpReplaceAll("([^:])J", "$1_j")
            .regexpReplaceAll("([^:])K", "$1_k")
            .regexpReplaceAll("([^:])L", "$1_l")
            .regexpReplaceAll("([^:])M", "$1_m")
            .regexpReplaceAll("([^:])N", "$1_n")
            .regexpReplaceAll("([^:])O", "$1_o")
            .regexpReplaceAll("([^:])P", "$1_p")
            .regexpReplaceAll("([^:])Q", "$1_q")
            .regexpReplaceAll("([^:])R", "$1_r")
            .regexpReplaceAll("([^:])S", "$1_s")
            .regexpReplaceAll("([^:])T", "$1_t")
            .regexpReplaceAll("([^:])U", "$1_u")
            .regexpReplaceAll("([^:])V", "$1_v")
            .regexpReplaceAll("([^:])W", "$1_w")
            .regexpReplaceAll("([^:])X", "$1_x")
            .regexpReplaceAll("([^:])Y", "$1_y")
            .regexpReplaceAll("([^:])Z", "$1_z")
            .regexpReplaceAll("::A", "/a")
            .regexpReplaceAll("::B", "/b")
            .regexpReplaceAll("::C", "/c")
            .regexpReplaceAll("::D", "/d")
            .regexpReplaceAll("::E", "/e")
            .regexpReplaceAll("::F", "/f")
            .regexpReplaceAll("::G", "/g")
            .regexpReplaceAll("::H", "/h")
            .regexpReplaceAll("::I", "/i")
            .regexpReplaceAll("::J", "/j")
            .regexpReplaceAll("::K", "/k")
            .regexpReplaceAll("::L", "/l")
            .regexpReplaceAll("::M", "/m")
            .regexpReplaceAll("::N", "/n")
            .regexpReplaceAll("::O", "/o")
            .regexpReplaceAll("::P", "/p")
            .regexpReplaceAll("::Q", "/q")
            .regexpReplaceAll("::R", "/r")
            .regexpReplaceAll("::S", "/s")
            .regexpReplaceAll("::T", "/t")
            .regexpReplaceAll("::U", "/u")
            .regexpReplaceAll("::V", "/v")
            .regexpReplaceAll("::W", "/w")
            .regexpReplaceAll("::X", "/x")
            .regexpReplaceAll("::Y", "/y")
            .regexpReplaceAll("::Z", "/z"))
  }

  /**
   * Convert the first character of the string to uppercase.
   * TODO: remove?
   */
  bindingset[input]
  string capitalize(string input) { result = input.charAt(0).toUpperCase() + input.suffix(1) }

  /**
   * Convert the first character of the string to lowercase.
   */
  bindingset[input]
  string decapitalize(string input) { result = input.charAt(0).toLowerCase() + input.suffix(1) }

  /**
   * Strip leading and trailing forward slashes from the string.
   */
  bindingset[input]
  string stripSlashes(string input) {
    result = input.regexpReplaceAll("^/+(.+)$", "$1").regexpReplaceAll("^(.*[^/])/+$", "$1")
  }
}
