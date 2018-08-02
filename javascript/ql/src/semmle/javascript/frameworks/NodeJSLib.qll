/**
 * Provides classes for modelling the Node.js standard library.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.SensitiveActions

module NodeJSLib {

  /**
   * Gets a reference to the 'process' object.
   */
  DataFlow::SourceNode process() {
    result = DataFlow::globalVarRef("process") or
    result = DataFlow::moduleImport("process")
  }

  /**
   * Holds if `call` is an invocation of `http.createServer` or `https.createServer`.
   */
  predicate isCreateServer(CallExpr call) {
    exists (string name |
      name = "http" or name = "https" |
      call = DataFlow::moduleMember(name, "createServer").getAnInvocation().asExpr()
    )
  }

  /**
   * A Node.js HTTP response.
   *
   * A server library that provides an (enhanced) NodesJS HTTP response
   * object should implement a library specific subclass of this class.
   */
  abstract class ResponseExpr extends HTTP::Servers::StandardResponseExpr {
  }

  /**
   * A Node.js HTTP request.
   *
   * A server library that provides an (enhanced) NodesJS HTTP request
   * object should implement a library specific subclass of this class.
   */
  abstract class RequestExpr extends HTTP::Servers::StandardRequestExpr {
  }

  /**
   * A function used as an Node.js server route handler.
   *
   * By default, only handlers installed by an Node.js server route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    SimpleParameter getRequestParameter() {
      result = getFunction().getParameter(0)
    }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    SimpleParameter getResponseParameter() {
      result = getFunction().getParameter(1)
    }
  }

  /**
   * A route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler {
    StandardRouteHandler() {
      this = any(RouteSetup setup).getARouteHandler()
    }
  }

  /**
   * A Node.js response source, that is, the response parameter of a
   * route handler.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() {
      this = DataFlow::parameterNode(rh.getResponseParameter())
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() {
      result = rh
    }
  }

  /**
   * A Node.js request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends HTTP::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() {
      this = DataFlow::parameterNode(rh.getRequestParameter())
    }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() {
      result = rh
    }
  }

  /**
   * A builtin Node.js HTTP response.
   */
  private class BuiltinRouteHandlerResponseExpr extends ResponseExpr {
    BuiltinRouteHandlerResponseExpr() { src instanceof ResponseSource }
  }

  /**
   * A builtin Node.js HTTP request.
   */
  private class BuiltinRouteHandlerRequestExpr extends RequestExpr {
    BuiltinRouteHandlerRequestExpr() { src instanceof RequestSource }
  }

  /**
   * An access to a user-controlled Node.js request input.
   */
  private class RequestInputAccess extends HTTP::RequestInputAccess {
    RequestExpr request;
    string kind;

    RequestInputAccess() {
      // `req.url`
      kind = "url" and
      this.asExpr().(PropAccess).accesses(request, "url")
      or
      exists (PropAccess headers, string name |
        // `req.headers.<name>`
        if name = "cookie" then kind = "cookie" else kind= "header" |
        headers.accesses(request, "headers") and
        this.asExpr().(PropAccess).accesses(headers, name)
      )
    }

    override RouteHandler getRouteHandler() {
      result = request.getRouteHandler()
    }

    override string getKind() {
      result = kind
    }
  }

  class RouteSetup extends CallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    Expr handler;

    RouteSetup() {
      server.flowsTo(this) and
      handler = getArgument(0)
      or
      server.flowsTo(getReceiver()) and
      this.(MethodCallExpr).getMethodName().regexpMatch("on(ce)?") and
      getArgument(0).getStringValue() = "request" and
      handler = getArgument(1)
    }

    override DataFlow::SourceNode getARouteHandler() {
      result.(DataFlow::SourceNode).flowsTo(handler.flow()) or
      result.(DataFlow::TrackedNode).flowsTo(handler.flow())
    }

    override Expr getServer() {
      result = server
    }

    /**
     * Gets the expression for the handler registered by this setup.
     */
    Expr getRouteHandlerExpr() {
      result = handler
    }

  }

  private abstract class HeaderDefinition extends HTTP::Servers::StandardHeaderDefinition {

    ResponseExpr r;

    HeaderDefinition(){
      astNode.getReceiver() = r
    }

    override HTTP::RouteHandler getRouteHandler(){
      result = r.getRouteHandler()
    }

  }

  /**
   * A call to the `setHeader` method of an HTTP response.
   */
  private class SetHeader extends HeaderDefinition {
    SetHeader() {
      astNode.getMethodName() = "setHeader"
    }
  }

  /**
   * A call to the `writeHead` method of an HTTP response.
   */
  private class WriteHead extends HeaderDefinition {
    WriteHead() {
      astNode.getMethodName() = "writeHead" and
      astNode.getNumArgument() > 1
    }

    override predicate definesExplicitly(string headerName, Expr headerValue) {
      exists (DataFlow::SourceNode headers, string header |
        headers.flowsToExpr(astNode.getLastArgument()) and
        headers.hasPropertyWrite(header, DataFlow::valueNode(headerValue)) and
        headerName = header.toLowerCase()
      )
    }
  }

  /**
   * A call to a path-module method that preserves taint.
   */
  private class PathFlowTarget extends TaintTracking::AdditionalTaintStep, DataFlow::ValueNode {
    override CallExpr astNode;
    Expr tainted;

    PathFlowTarget() {
      exists (DataFlow::ModuleImportNode pathModule, string methodName |
        pathModule.getPath() = "path" and
        this = pathModule.getAMemberCall(methodName) |
        // getters
        (methodName = "basename" and tainted = astNode.getArgument(0)) or
        (methodName = "dirname" and tainted = astNode.getArgument(0)) or
        (methodName = "extname" and tainted = astNode.getArgument(0)) or

        // transformers
        (methodName = "join" and tainted = astNode.getAnArgument()) or
        (methodName = "normalize" and tainted = astNode.getArgument(0)) or
        (methodName = "relative" and tainted = astNode.getArgument([0..1])) or
        (methodName = "resolve" and tainted = astNode.getAnArgument()) or
        (methodName = "toNamespacedPath" and tainted = astNode.getArgument(0))
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred.asExpr() = tainted and succ = this
    }

  }

  /**
   * An expression passed as the first argument to the `write` or `end` method
   * of an HTTP response.
   */
  private class ResponseSendArgument extends HTTP::ResponseSendArgument {
    HTTP::RouteHandler rh;

    ResponseSendArgument() {
      exists (MethodCallExpr mce, string m | m = "write" or m = "end" |
        mce.calls(any(ResponseExpr e | e.getRouteHandler() = rh), m) and
        this = mce.getArgument(0) and
        // don't mistake callback functions as data
        not this.analyze().getAValue() instanceof AbstractFunction
      )
    }

    override HTTP::RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An expression that creates a new Node.js server.
   */
  class ServerDefinition extends HTTP::Servers::StandardServerDefinition {
    ServerDefinition() {
      isCreateServer(this)
    }
  }

  /** An expression that is passed as `http.request({ auth: <expr> }, ...)`. */
  class Credentials extends CredentialsExpr {

    Credentials() {
      exists (CallExpr call |
        exists (DataFlow::ModuleImportNode http |
          http.getPath() = "http" or http.getPath() = "https" |
          call = http.getAMemberCall("request").asExpr()
        ) and
        call.hasOptionArgument(0, "auth", this)
      )
    }

    override string getCredentialsKind() {
      result = "credentials"
    }

  }

  /**
   * A call a process-terminating function, such as `process.exit`.
   */
  class ProcessTermination extends SensitiveAction, DataFlow::ValueNode {
    override CallExpr astNode;

    ProcessTermination() {
      this = DataFlow::moduleImport("exit").getAnInvocation()
      or
      this = process().getAMemberCall("exit")
    }

  }

  /**
   * Holds if the `i`th parameter of method `methodName` of the Node.js
   * `fs` module might represent a file path.
   *
   * We determine this by looking for an externs declaration for
   * `fs.methodName` where the `i`th parameter's name is `filename` or
   * `path` or a variation thereof.
   */
  private predicate fsFileParam(string methodName, int i) {
    exists (ExternalMemberDecl decl, Function f, JSDocParamTag p, string n |
      decl.hasQualifiedName("fs", methodName) and f = decl.getInit() and
      p.getDocumentedParameter() = f.getParameter(i).getAVariable() and
      n = p.getName().toLowerCase() |
      n = "filename" or n.regexpMatch("(old|new|src|dst|)path")
    )
  }


  /**
   * A call to a method from module `fs` or `graceful-fs`.
   */
  private class NodeJSFileSystemAccess extends FileSystemAccess, DataFlow::ValueNode {
    override MethodCallExpr astNode;

    NodeJSFileSystemAccess() {
      exists (DataFlow::ModuleImportNode fs |
        fs.getPath() = "fs" or fs.getPath() = "graceful-fs" |
        this = fs.getAMemberCall(_)
      )
    }

    override DataFlow::Node getAPathArgument() {
      exists (int i | fsFileParam(astNode.getMethodName(), i) |
        result = DataFlow::valueNode(astNode.getArgument(i))
      )
    }
  }

  /**
   * A call to a method from module `child_process`.
   */
  private class ChildProcessMethodCall extends SystemCommandExecution, DataFlow::CallNode {
    string methodName;

    ChildProcessMethodCall() {
      this = DataFlow::moduleMember("child_process", methodName).getACall()
    }

    override DataFlow::Node getACommandArgument() {
      // check whether this is an invocation of an exec/spawn/fork method
      (
        methodName = "exec" or
        methodName = "execSync" or
        methodName = "execFile" or
        methodName = "execFileSync" or
        methodName = "spawn" or
        methodName = "spawnSync" or
        methodName = "fork"
      )
      and
      // all of the above methods take the command as their first argument
      result = getArgument(0)
    }

    override DataFlow::Node getArgumentList() {
      (
       methodName = "execFile" or
       methodName = "execFileSync" or
       methodName = "fork" or
       methodName = "spawn" or
       methodName = "spawnSync"
      )
      and
      // all of the above methods take the argument list as their second argument
      result = getArgument(1)
    }
  }

  /**
   * A function that looks like a Node.js route handler.
   *
   * For example, this could be the function `function(req, res){...}`.
   */
  class RouteHandlerCandidate extends HTTP::RouteHandlerCandidate, DataFlow::FunctionNode {

    override Function astNode;

    RouteHandlerCandidate() {
      exists (string request, string response |
        (request = "request" or request = "req") and
        (response = "response" or response = "res") and
        // heuristic: parameter names match the Node.js documentation
        astNode.getNumParameter() = 2 and
        astNode.getParameter(0).getName() = request and
        astNode.getParameter(1).getName() = response |
        not (
          // heuristic: not a class method (Node.js invokes this with a function call)
          astNode = any(MethodDefinition def).getBody() or
          // heuristic: does not return anything (Node.js will not use the return value)
          exists(astNode.getAReturnStmt().getExpr()) or
          // heuristic: is not invoked (Node.js invokes this at a call site we cannot reason precisely about)
          exists(CallSite cs | cs.getACallee() = astNode)
        )
      )
    }
  }

  /**
   * Tracking for `RouteHandlerCandidate`.
   */
  private class TrackedRouteHandlerCandidate extends DataFlow::TrackedNode {

    TrackedRouteHandlerCandidate() {
      this instanceof RouteHandlerCandidate
    }

  }

  /**
   * A function that looks like a Node.js route handler and flows to a route setup.
   */
  private class TrackedRouteHandlerCandidateWithSetup extends RouteHandler, HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {

    override Function astNode;

    TrackedRouteHandlerCandidateWithSetup() {
      exists(TrackedRouteHandlerCandidate tracked |
        tracked.flowsTo(any(RouteSetup s).getRouteHandlerExpr().flow()) and
        this = tracked
      )
    }

  }
  
  /**
   * A call to a method from module `vm`
   */
  class VmModuleMethodCall extends DataFlow::CallNode {
    string methodName;
    
    VmModuleMethodCall() {
      this = DataFlow::moduleMember("vm", methodName).getACall()
    }
    
    /**
     * Gets the code to be executed as part of this call.
     */
    DataFlow::Node getACodeArgument() {      
      (
        methodName = "runInContext" or
        methodName = "runInNewContext" or
        methodName = "runInThisContext"
      )
      and
      // all of the above methods take the command as their first argument
      result = getArgument(0)
    }
  }

  /**
   * A call that looks like a route setup on a Node.js server.
   *
   * For example, this could be the call `server.on("request", handler)`
   * where it is unknown if `server` is a Node.js server.
   */
  class RouteSetupCandidate extends HTTP::RouteSetupCandidate, DataFlow::MethodCallNode {

    DataFlow::ValueNode arg;

    RouteSetupCandidate() {
      getMethodName() = "createServer" and
      arg = getArgument(0)
      or
      getMethodName().regexpMatch("on(ce)?") and
      getArgument(0).mayHaveStringValue("request") and
      arg = getArgument(1)
    }

    override DataFlow::ValueNode getARouteHandlerArg() {
      result = arg
    }
  }

}
