/**
 * Provides modeling for the `Grape` API framework.
 */

private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.typetracking.TypeTracking
private import codeql.ruby.frameworks.Rails
private import codeql.ruby.frameworks.internal.Rails
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.dataflow.FlowSteps

/**
 * Provides modeling for Grape, a REST-like API framework for Ruby.
 * Grape allows you to build RESTful APIs in Ruby with minimal effort.
 */
module Grape {
  /**
   * A Grape API class which sits at the top of the class hierarchy.
   * In other words, it does not subclass any other Grape API class in source code.
   */
  class RootApi extends GrapeApiClass {
    RootApi() { not this = any(GrapeApiClass parent).getAnImmediateDescendent() }
  }

  /**
   * A class that extends `Grape::API`.
   * For example,
   *
   * ```rb
   * class FooAPI < Grape::API
   *   get '/users' do
   *     name = params[:name]
   *     User.where("name = #{name}")
   *   end
   * end
   * ```
   */
  class GrapeApiClass extends DataFlow::ClassNode {
    GrapeApiClass() { this = grapeApiBaseClass().getADescendentModule() }

    /**
     * Gets a `GrapeEndpoint` defined in this class.
     */
    GrapeEndpoint getAnEndpoint() { result.getApiClass() = this }

    /**
     * Gets a `self` that possibly refers to an instance of this class.
     */
    DataFlow::LocalSourceNode getSelf() {
      result = this.getAnInstanceSelf()
      or
      // Include the module-level `self` to recover some cases where a block at the module level
      // is invoked with an instance as the `self`.
      result = this.getModuleLevelSelf()
    }

    /**
     * Gets the `self` parameter belonging to a method defined within a
     * `helpers` block in this API class.
     *
     * These methods become available in endpoint contexts through Grape's DSL.
     */
    DataFlow::SelfParameterNode getHelperSelf() {
      exists(DataFlow::CallNode helpersCall |
        helpersCall = this.getAModuleLevelCall("helpers") and
        result.getSelfVariable().getDeclaringScope().getOuterScope+() =
          helpersCall.getBlock().asExpr().getExpr()
      )
    }
  }

  private DataFlow::ConstRef grapeApiBaseClass() {
    result = DataFlow::getConstant("Grape").getConstant("API")
  }

  private API::Node grapeApiInstance() { result = any(GrapeApiClass cls).getSelf().track() }

  /**
   * A Grape API endpoint (get, post, put, delete, etc.) call within a `Grape::API` class.
   */
  class GrapeEndpoint extends DataFlow::CallNode {
    private GrapeApiClass apiClass;

    GrapeEndpoint() {
      this =
        apiClass.getAModuleLevelCall(["get", "post", "put", "delete", "patch", "head", "options"])
    }

    /**
     * Gets the HTTP method for this endpoint (e.g., "GET", "POST", etc.)
     */
    string getHttpMethod() { result = this.getMethodName().toUpperCase() }

    /**
     * Gets the API class containing this endpoint.
     */
    GrapeApiClass getApiClass() { result = apiClass }

    /**
     * Gets the block containing the endpoint logic.
     */
    DataFlow::BlockNode getBody() { result = this.getBlock() }

    /**
     * Gets the path pattern for this endpoint, if specified.
     */
    string getPath() { result = this.getArgument(0).getConstantValue().getString() }
  }

  /**
   * A `RemoteFlowSource::Range` to represent accessing the
   * Grape parameters available via the `params` method within an endpoint.
   */
  class GrapeParamsSource extends Http::Server::RequestInputAccess::Range {
    GrapeParamsSource() { this.asExpr().getExpr() instanceof GrapeParamsCall }

    override string getSourceType() { result = "Grape::API#params" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /**
   * A call to `params` from within a Grape API endpoint or helper method.
   */
  private class GrapeParamsCall extends ParamsCallImpl {
    GrapeParamsCall() {
      exists(API::Node n | this = n.getAMethodCall("params").asExpr().getExpr() |
        // Params calls within endpoint blocks
        n = grapeApiInstance()
        or
        // Params calls within helper methods (defined in helpers blocks)
        n = any(GrapeApiClass c).getHelperSelf().track()
      )
    }
  }

  /**
   * A call to `headers` from within a Grape API endpoint or headers block.
   * Headers can also be a source of user input.
   */
  class GrapeHeadersSource extends Http::Server::RequestInputAccess::Range {
    GrapeHeadersSource() {
      this.asExpr().getExpr() instanceof GrapeHeadersCall
      or
      this.asExpr().getExpr() instanceof GrapeHeadersBlockCall
    }

    override string getSourceType() { result = "Grape::API#headers" }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }
  }

  /**
   * A call to `headers` from within a Grape API endpoint.
   */
  private class GrapeHeadersCall extends MethodCall {
    GrapeHeadersCall() {
      // Handle cases where headers is called on an instance of a Grape API class
      this = grapeApiInstance().getAMethodCall("headers").asExpr().getExpr()
    }
  }

  /**
   * A call to `request` from within a Grape API endpoint.
   * The request object can contain user input.
   */
  class GrapeRequestSource extends Http::Server::RequestInputAccess::Range {
    GrapeRequestSource() { this.asExpr().getExpr() instanceof GrapeRequestCall }

    override string getSourceType() { result = "Grape::API#request" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /**
   * A call to `route_param` from within a Grape API endpoint.
   * Route parameters are extracted from the URL path and can be a source of user input.
   */
  class GrapeRouteParamSource extends Http::Server::RequestInputAccess::Range {
    GrapeRouteParamSource() { this.asExpr().getExpr() instanceof GrapeRouteParamCall }

    override string getSourceType() { result = "Grape::API#route_param" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /**
   * A call to `request` from within a Grape API endpoint.
   */
  private class GrapeRequestCall extends MethodCall {
    GrapeRequestCall() {
      // Handle cases where request is called on an instance of a Grape API class
      this = grapeApiInstance().getAMethodCall("request").asExpr().getExpr()
    }
  }

  /**
   * A call to `route_param` from within a Grape API endpoint.
   */
  private class GrapeRouteParamCall extends MethodCall {
    GrapeRouteParamCall() {
      // Handle cases where route_param is called on an instance of a Grape API class
      this = grapeApiInstance().getAMethodCall("route_param").asExpr().getExpr()
    }
  }

  /**
   * A call to `headers` block within a Grape API class.
   * This is different from the headers() method call - this is the DSL block for defining header requirements.
   */
  private class GrapeHeadersBlockCall extends MethodCall {
    GrapeHeadersBlockCall() {
      this = grapeApiInstance().getAMethodCall("headers").asExpr().getExpr() and
      exists(this.getBlock())
    }
  }

  /**
   * A call to `cookies` block within a Grape API class.
   * This DSL block defines cookie requirements and those cookies are user-controlled.
   */
  private class GrapeCookiesBlockCall extends MethodCall {
    GrapeCookiesBlockCall() {
      this = grapeApiInstance().getAMethodCall("cookies").asExpr().getExpr() and
      exists(this.getBlock())
    }
  }

  /**
   * A call to `cookies` method from within a Grape API endpoint or cookies block.
   * Similar to headers, cookies can be accessed as a method and are user-controlled input.
   */
  class GrapeCookiesSource extends Http::Server::RequestInputAccess::Range {
    GrapeCookiesSource() {
      this.asExpr().getExpr() instanceof GrapeCookiesCall
      or
      this.asExpr().getExpr() instanceof GrapeCookiesBlockCall
    }

    override string getSourceType() { result = "Grape::API#cookies" }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::cookieInputKind() }
  }

  /**
   * A call to `cookies` method from within a Grape API endpoint.
   */
  private class GrapeCookiesCall extends MethodCall {
    GrapeCookiesCall() {
      // Handle cases where cookies is called on an instance of a Grape API class
      this = grapeApiInstance().getAMethodCall("cookies").asExpr().getExpr()
    }
  }

  /**
   * A method defined within a `helpers` block in a Grape API class.
   * These methods become available in endpoint contexts through Grape's DSL.
   */
  private class GrapeHelperMethod extends Method {
    private GrapeApiClass apiClass;

    GrapeHelperMethod() { this = apiClass.getHelperSelf().getSelfVariable().getDeclaringScope() }

    /**
     * Gets the API class that contains this helper method.
     */
    GrapeApiClass getApiClass() { result = apiClass }
  }

  /**
   * Additional call-target to resolve helper method calls defined in `helpers` blocks.
   *
   * This class is responsible for resolving calls to helper methods defined in
   * `helpers` blocks, allowing the dataflow framework to accurately track
   * the flow of information between these methods and their call sites.
   */
  private class GrapeHelperMethodTarget extends AdditionalCallTarget {
    override DataFlowCallable viableTarget(CfgNodes::ExprNodes::CallCfgNode call) {
      // Find calls to helper methods from within Grape endpoints or other helper methods
      exists(GrapeHelperMethod helperMethod, MethodCall mc |
        result.asCfgScope() = helperMethod and
        mc = call.getAstNode() and
        mc.getMethodName() = helperMethod.getName() and
        mc.getParent+() = helperMethod.getApiClass().getADeclaration()
      )
    }
  }
}
