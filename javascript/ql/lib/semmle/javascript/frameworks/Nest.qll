/**
 * Provides classes and predicates for reasoning about [Nest](https://nestjs.com/).
 */

import javascript
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations

/**
 * Provides classes and predicates for reasoning about [Nest](https://nestjs.com/).
 */
module NestJS {
  /** Gets an API node referring to the `@nestjs/common` module. */
  private API::Node nestjs() { result = API::moduleImport("@nestjs/common") }

  /**
   * Gets a data flow node that is applied as a decorator on the given function.
   *
   * Note that only methods in a class can have decorators.
   */
  private DataFlow::Node getAFunctionDecorator(DataFlow::FunctionNode fun) {
    exists(MethodDefinition method |
      fun = method.getInit().flow() and
      result = method.getADecorator().getExpression().flow()
    )
  }

  /**
   * A method that is declared as a route handler using a decorator, for example:
   *
   * ```js
   * class C {
   *   @Get('posts')
   *   getPosts() { .. }
   * }
   * ```
   */
  private class NestJSRouteHandler extends HTTP::RouteHandler, DataFlow::FunctionNode {
    NestJSRouteHandler() {
      getAFunctionDecorator(this) =
        nestjs()
            .getMember(["Get", "Post", "Put", "Delete", "Patch", "Options", "Head", "All"])
            .getACall()
    }

    override HTTP::HeaderDefinition getAResponseHeader(string name) { none() }

    /**
     * Holds if this has the `@Redirect()` decorator.
     */
    predicate hasRedirectDecorator() {
      getAFunctionDecorator(this) = nestjs().getMember("Redirect").getACall()
    }

    /**
     * Holds if the return value is sent back in the response.
     */
    predicate isReturnValueReflected() {
      getAFunctionDecorator(this) = nestjs().getMember(["Get", "Post"]).getACall() and
      not hasRedirectDecorator() and
      not getAFunctionDecorator(this) = nestjs().getMember("Render").getACall()
    }

    /** Gets a pipe applied to the inputs of this route handler, not including global pipes. */
    DataFlow::Node getAPipe() {
      exists(DataFlow::CallNode decorator |
        decorator = nestjs().getMember("UsePipes").getACall() and
        result = decorator.getAnArgument()
      |
        decorator = getAFunctionDecorator(this)
        or
        exists(DataFlow::ClassNode cls |
          this = cls.getAnInstanceMember() and
          decorator = cls.getADecorator()
        )
      )
    }
  }

  /**
   * A parameter with a decorator that makes it receive a value derived from the incoming request.
   *
   * For example, in the following,
   * ```js
   * @Get(':foo')
   * foo(@Param('foo') foo, @Query() query) { ... }
   * ```
   * the `foo` and `query` parameters receive (part of) the path and query string, respectively.
   */
  private class NestJSRequestInput extends DataFlow::ParameterNode {
    DataFlow::CallNode decorator;
    string decoratorName;

    NestJSRequestInput() {
      decoratorName =
        ["Query", "Param", "Headers", "Body", "HostParam", "UploadedFile", "UploadedFiles"] and
      decorator = getADecorator() and
      decorator = nestjs().getMember(decoratorName).getACall()
    }

    /** Gets the decorator marking this as a request input. */
    DataFlow::CallNode getDecorator() { result = decorator }

    /** Gets the route handler on which this parameter appears. */
    NestJSRouteHandler getNestRouteHandler() { result.getAParameter() = this }

    /** Gets a pipe applied to this parameter, not including global pipes. */
    DataFlow::Node getAPipe() {
      result = getNestRouteHandler().getAPipe()
      or
      result = decorator.getArgument(1)
      or
      decorator.getNumArgument() = 1 and
      not decorator.getArgument(0).mayHaveStringValue(_) and
      result = decorator.getArgument(0) // One-argument version can either take a pipe or a property name
    }

    /** Gets the kind of parameter, for use in `HTTP::RequestInputAccess`. */
    string getInputKind() {
      decoratorName = ["Param", "Query"] and result = "parameter"
      or
      decoratorName = ["Headers", "HostParam"] and result = "header"
      or
      decoratorName = ["Body", "UploadedFile", "UploadedFiles"] and result = "body"
    }

    /**
     * Holds if this is sanitized by a sanitizing pipe, for example, a parameter
     * with the decorator `@Param('x', ParseIntPipe)` is parsed as an integer, and
     * is thus considered to be sanitized.
     */
    predicate isSanitizedByPipe() {
      hasSanitizingPipe(this, false)
      or
      hasSanitizingPipe(this, true) and
      isSanitizingType(getParameter().getType().unfold())
    }
  }

  /** API node entry point for custom implementations of `ValidationPipe` (a common pattern). */
  private class ValidationNodeEntry extends API::EntryPoint {
    ValidationNodeEntry() { this = "ValidationNodeEntry" }

    override DataFlow::SourceNode getAUse() {
      result.(DataFlow::ClassNode).getName() = "ValidationPipe"
    }

    override DataFlow::Node getARhs() { none() }
  }

  /** Gets an API node referring to the constructor of `ValidationPipe` */
  private API::Node validationPipe() {
    result = nestjs().getMember("ValidationPipe")
    or
    result = any(ValidationNodeEntry e).getANode()
  }

  /**
   * Gets a pipe (instance or constructor) which causes its input to be sanitized, and thus not seen as a `RequestInputAccess`.
   *
   * If `dependsOnType` is `true`, then the validation depends on the declared type of the input,
   * and some types may not be enough to be considered sanitized.
   */
  private API::Node sanitizingPipe(boolean dependsOnType) {
    exists(API::Node ctor |
      dependsOnType = false and
      ctor = nestjs().getMember(["ParseIntPipe", "ParseBoolPipe", "ParseUUIDPipe"])
      or
      dependsOnType = true and
      ctor = validationPipe()
    |
      result = [ctor, ctor.getInstance()]
    )
  }

  /**
   * Holds if `ValidationPipe` is installed as a global pipe by a file in the given folder
   * or one of its enclosing folders.
   *
   * We use folder hierarchy to approximate the scope of globally-installed pipes.
   */
  predicate hasGlobalValidationPipe(Folder folder) {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = "useGlobalPipes" and
      call.getArgument(0) = validationPipe().getInstance().getAUse() and
      folder = call.getFile().getParentContainer()
    )
    or
    exists(API::CallNode decorator |
      decorator = nestjs().getMember("Module").getACall() and
      decorator
          .getParameter(0)
          .getMember("providers")
          .getAMember()
          .getMember("useFactory")
          .getReturn()
          .getARhs() = validationPipe().getInstance().getAUse() and
      folder = decorator.getFile().getParentContainer()
    )
    or
    hasGlobalValidationPipe(folder.getParentContainer())
  }

  /**
   * Holds if `param` is affected by a pipe that sanitizes inputs.
   */
  private predicate hasSanitizingPipe(NestJSRequestInput param, boolean dependsOnType) {
    param.getAPipe() = sanitizingPipe(dependsOnType).getAUse()
    or
    hasGlobalValidationPipe(param.getFile().getParentContainer()) and
    dependsOnType = true
  }

  /**
   * Holds if a parameter of type `t` is considered sanitized, provided it has been checked by `ValidationPipe`
   * (which relies on metadata emitted by the TypeScript compiler).
   */
  private predicate isSanitizingType(Type t) {
    t instanceof NumberType
    or
    t instanceof BooleanType
    //
    // Note: we could consider types with class-validator decorators to be sanitized here, but instead we consider the root
    // object to be tainted, but omit taint steps for the individual properties names that have sanitizing decorators. See ClassValidator.qll.
  }

  /**
   * A user-defined pipe class, for example:
   * ```js
   * class MyPipe implements PipeTransform {
   *   transform(value) { return value + '!' }
   * }
   * ```
   * This can be used as a pipe, for example, `@Param('x', MyPipe)` would pipe
   * the request parameter `x` through the `transform` function before flowing into
   * the route handler.
   */
  private class CustomPipeClass extends DataFlow::ClassNode {
    CustomPipeClass() {
      exists(ClassDefinition cls |
        this = cls.flow() and
        cls.getASuperInterface().hasQualifiedName("@nestjs/common", "PipeTransform")
      )
    }

    DataFlow::FunctionNode getTransformFunction() { result = getInstanceMethod("transform") }

    DataFlow::ParameterNode getInputData() { result = getTransformFunction().getParameter(0) }

    DataFlow::Node getOutputData() { result = getTransformFunction().getReturnNode() }

    NestJSRequestInput getAnAffectedParameter() {
      [getAnInstanceReference(), getAClassReference()].flowsTo(result.getAPipe())
    }
  }

  /**
   * The input to a custom pipe, seen as a remote flow source.
   *
   * The type of remote flow depends on which decorator is applied at the parameter, so
   * we just classify it as a `RemoteFlowSource`.
   */
  private class NestJSCustomPipeInput extends HTTP::RequestInputAccess {
    CustomPipeClass pipe;

    NestJSCustomPipeInput() {
      this = pipe.getInputData() and
      exists(NestJSRequestInput input |
        input = pipe.getAnAffectedParameter() and
        not input.isSanitizedByPipe()
      )
    }

    override string getKind() {
      // Use any input kind that the pipe is applied to.
      result = pipe.getAnAffectedParameter().getInputKind()
    }

    override HTTP::RouteHandler getRouteHandler() {
      result = pipe.getAnAffectedParameter().getNestRouteHandler()
    }
  }

  /**
   * A step from the result of a custom pipe, to an affected parameter.
   */
  private class CustomPipeStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(CustomPipeClass pipe |
        pred = pipe.getOutputData() and
        succ = pipe.getAnAffectedParameter()
      )
    }
  }

  /**
   * A request input parameter that is not sanitized by a pipe, and therefore treated
   * as a source of untrusted data.
   */
  private class NestJSRequestInputAsRequestInputAccess extends NestJSRequestInput,
    HTTP::RequestInputAccess {
    NestJSRequestInputAsRequestInputAccess() {
      not isSanitizedByPipe() and
      not this = any(CustomPipeClass cls).getAnAffectedParameter()
    }

    override HTTP::RouteHandler getRouteHandler() { result = getNestRouteHandler() }

    override string getKind() { result = getInputKind() }

    override predicate isUserControlledObject() {
      not exists(getAPipe()) and // value is not transformed by a pipe
      (
        decorator.getNumArgument() = 0
        or
        decoratorName = ["Query", "Body"]
      )
    }
  }

  private class NestJSHeaderAccess extends NestJSRequestInputAsRequestInputAccess,
    HTTP::RequestHeaderAccess {
    NestJSHeaderAccess() { decoratorName = "Headers" and decorator.getNumArgument() > 0 }

    override string getAHeaderName() {
      result = decorator.getArgument(0).getStringValue().toLowerCase()
    }
  }

  private predicate isStringType(Type type) {
    type instanceof StringType
    or
    type instanceof AnyType
    or
    isStringType(type.(PromiseType).getElementType().unfold())
  }

  /**
   * A return value from a route handler, seen as an argument to `res.send()`.
   *
   * For example,
   * ```js
   * @Get()
   * foo() {
   *   return '<b>Hello</b>';
   * }
   * ```
   * writes `<b>Hello</b>` to the response.
   */
  private class ReturnValueAsResponseSend extends HTTP::ResponseSendArgument {
    NestJSRouteHandler handler;

    ReturnValueAsResponseSend() {
      handler.isReturnValueReflected() and
      this = handler.getAReturn().asExpr() and
      // Only returned strings are sinks
      not exists(Type type |
        type = getType() and
        not isStringType(type.unfold())
      )
    }

    override HTTP::RouteHandler getRouteHandler() { result = handler }
  }

  /**
   * A return value from a redirecting route handler, seen as a sink for server-side redirect.
   *
   * For example,
   * ```js
   * @Get()
   * @Redirect
   * foo() {
   *   return { url: 'https://example.com' }
   * }
   * ```
   * redirects to `https://example.com`.
   */
  private class ReturnValueAsRedirection extends ServerSideUrlRedirect::Sink {
    ReturnValueAsRedirection() {
      exists(NestJSRouteHandler handler |
        handler.hasRedirectDecorator() and
        this = handler.getAReturn().getALocalSource().getAPropertyWrite("url").getRhs()
      )
    }
  }

  /**
   * A parameter decorator created using `createParamDecorator`.
   */
  private class CustomParameterDecorator extends API::CallNode {
    CustomParameterDecorator() { this = nestjs().getMember("createParamDecorator").getACall() }

    /** Gets the `context` parameter. */
    API::Node getExecutionContext() { result = getParameter(0).getParameter(1) }

    /** Gets a parameter with this decorator applied. */
    DataFlow::ParameterNode getADecoratedParameter() {
      result.getADecorator() = getReturn().getReturn().getAUse()
    }

    /** Gets a value returned by the decorator's callback, which becomes the value of the decorated parameter. */
    DataFlow::Node getResult() { result = getParameter(0).getReturn().getARhs() }
  }

  /**
   * A flow step from a custom parameter decorator to a decorated parameter.
   */
  private class CustomParameterFlowStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(CustomParameterDecorator dec |
        pred = dec.getResult() and
        succ = dec.getADecoratedParameter()
      )
    }
  }

  private API::Node executionContext() {
    result = API::Node::ofType("@nestjs/common", "ExecutionContext")
    or
    result = any(CustomParameterDecorator d).getExecutionContext()
  }

  /**
   * A source of `express` request objects, based on the `@Req()` decorator,
   * or the context object in a custom decorator.
   */
  private class ExpressRequestSource extends Express::RequestSource {
    ExpressRequestSource() {
      this.(DataFlow::ParameterNode).getADecorator() =
        nestjs().getMember(["Req", "Request"]).getReturn().getAnImmediateUse()
      or
      this =
        executionContext()
            .getMember("switchToHttp")
            .getReturn()
            .getMember("getRequest")
            .getReturn()
            .getAnImmediateUse()
    }

    /**
     * Gets the route handler that handles this request.
     */
    override HTTP::RouteHandler getRouteHandler() {
      result.(DataFlow::FunctionNode).getAParameter() = this
    }
  }

  /**
   * A source of `express` response objects, based on the `@Res()` decorator.
   */
  private class ExpressResponseSource extends Express::ResponseSource {
    ExpressResponseSource() {
      this.(DataFlow::ParameterNode).getADecorator() =
        nestjs().getMember(["Res", "Response"]).getReturn().getAnImmediateUse()
    }

    /**
     * Gets the route handler that handles this request.
     */
    override HTTP::RouteHandler getRouteHandler() {
      result.(DataFlow::FunctionNode).getAParameter() = this
    }
  }
}
