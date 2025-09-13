/**
 * Provides modeling for the `Grape` API framework.
 */

private import codeql.ruby.AST
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
  class RootAPI extends GrapeAPIClass {
    RootAPI() {
      not exists(GrapeAPIClass parent | this != parent and this = parent.getADescendent())
    }
  }
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
class GrapeAPIClass extends DataFlow::ClassNode {
  GrapeAPIClass() {
    this = grapeAPIBaseClass().getADescendentModule() and
    not exists(DataFlow::ModuleNode m | m = grapeAPIBaseClass().asModule() | this = m)
  }

  /**
   * Gets a `GrapeEndpoint` defined in this class.
   */
  GrapeEndpoint getAnEndpoint() {
    result.getAPIClass() = this
  }

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
}

private DataFlow::ConstRef grapeAPIBaseClass() {
  result = DataFlow::getConstant("Grape").getConstant("API")
}

private API::Node grapeAPIInstance() {
  result = any(GrapeAPIClass cls).getSelf().track()
}

/**
 * A Grape API endpoint (get, post, put, delete, etc.) call within a `Grape::API` class.
 */
class GrapeEndpoint extends DataFlow::CallNode {
  private GrapeAPIClass apiClass;

  GrapeEndpoint() {
    this = apiClass.getAModuleLevelCall(["get", "post", "put", "delete", "patch", "head", "options"])
  }

  /**
   * Gets the HTTP method for this endpoint (e.g., "GET", "POST", etc.)
   */
  string getHttpMethod() {
    result = this.getMethodName().toUpperCase()
  }

  /**
   * Gets the API class containing this endpoint.
   */
  GrapeAPIClass getAPIClass() { result = apiClass }

  /**
   * Gets the block containing the endpoint logic.
   */
  DataFlow::BlockNode getBody() { result = this.getBlock() }

  /**
   * Gets the path pattern for this endpoint, if specified.
   */
  string getPath() {
    result = this.getArgument(0).getConstantValue().getString()
  }
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the
 * Grape parameters available via the `params` method within an endpoint.
 */
class GrapeParamsSource extends Http::Server::RequestInputAccess::Range {
  GrapeParamsSource() {
    this.asExpr().getExpr() instanceof GrapeParamsCall
  }

  override string getSourceType() { result = "Grape::API#params" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::parameterInputKind() }
}

/**
 * A call to `params` from within a Grape API endpoint or helper method.
 */
private class GrapeParamsCall extends ParamsCallImpl {
  GrapeParamsCall() {
    // Simplified approach: find params calls that are descendants of Grape API class methods
    exists(GrapeAPIClass api |
      this.getMethodName() = "params" and
      this.getParent+() = api.getADeclaration()
    )
  }
}/**
 * A call to `headers` from within a Grape API endpoint.
 * Headers can also be a source of user input.
 */
class GrapeHeadersSource extends Http::Server::RequestInputAccess::Range {
  GrapeHeadersSource() {
    this.asExpr().getExpr() instanceof GrapeHeadersCall
  }

  override string getSourceType() { result = "Grape::API#headers" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::headerInputKind() }
}

/**
 * A call to `headers` from within a Grape API endpoint.
 */
private class GrapeHeadersCall extends MethodCall {
  GrapeHeadersCall() {
    exists(GrapeEndpoint endpoint |
      this.getParent+() = endpoint.getBody().asCallableAstNode() and
      this.getMethodName() = "headers"
    )
    or
    // Also handle cases where headers is called on an instance of a Grape API class
    this = grapeAPIInstance().getAMethodCall("headers").asExpr().getExpr()
  }
}

/**
 * A call to `request` from within a Grape API endpoint.
 * The request object can contain user input.
 */
class GrapeRequestSource extends Http::Server::RequestInputAccess::Range {
  GrapeRequestSource() {
    this.asExpr().getExpr() instanceof GrapeRequestCall
  }

  override string getSourceType() { result = "Grape::API#request" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::parameterInputKind() }
}

/**
 * A call to `request` from within a Grape API endpoint.
 */
private class GrapeRequestCall extends MethodCall {
  GrapeRequestCall() {
    exists(GrapeEndpoint endpoint |
      this.getParent+() = endpoint.getBody().asCallableAstNode() and
      this.getMethodName() = "request"
    )
    or
    // Also handle cases where request is called on an instance of a Grape API class
    this = grapeAPIInstance().getAMethodCall("request").asExpr().getExpr()
  }
}

/**
 * A method defined within a `helpers` block in a Grape API class.
 * These methods become available in endpoint contexts through Grape's DSL.
 */
private class GrapeHelperMethod extends Method {
  private GrapeAPIClass apiClass;

  GrapeHelperMethod() {
    exists(DataFlow::CallNode helpersCall |
      helpersCall = apiClass.getAModuleLevelCall("helpers") and
      this.getParent+() = helpersCall.getBlock().asExpr().getExpr()
    )
  }

  /**
   * Gets the API class that contains this helper method.
   */
  GrapeAPIClass getAPIClass() { result = apiClass }
}

/**
 * Additional taint step to model dataflow from method arguments to parameters
 * for Grape helper methods defined in `helpers` blocks.
 * This bridges the gap where standard dataflow doesn't recognize the Grape DSL semantics.
 */
private class GrapeHelperMethodTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(GrapeHelperMethod helperMethod, MethodCall call, int i |
      // Find calls to helper methods from within Grape endpoints
      call.getMethodName() = helperMethod.getName() and
      exists(GrapeEndpoint endpoint |
        call.getParent+() = endpoint.getBody().asExpr().getExpr()
      ) and
      // Map argument to parameter
      nodeFrom.asExpr().getExpr() = call.getArgument(i) and
      nodeTo.asParameter() = helperMethod.getParameter(i)
    )
  }
}