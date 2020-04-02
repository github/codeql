/**
 * Provides classes for modelling the Node.js standard library.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.SensitiveActions

module NodeJSLib {
  /**
   * An access to the global `process` variable in a Node.js module, interpreted as
   * an import of the `process` module.
   */
  private class ImplicitProcessImport extends DataFlow::ModuleImportNode::Range {
    ImplicitProcessImport() {
      exists(GlobalVariable process |
        process.getName() = "process" and
        this = DataFlow::exprNode(process.getAnAccess())
      ) and
      getTopLevel() instanceof NodeModule
    }

    override string getPath() { result = "process" }
  }

  /**
   * Gets a reference to the 'process' object.
   */
  DataFlow::SourceNode process() {
    result = DataFlow::globalVarRef("process") or
    result = DataFlow::moduleImport("process")
  }

  /**
   * Gets a reference to a member of the 'process' object.
   */
  private DataFlow::SourceNode processMember(string member) {
    result = process().getAPropertyRead(member)
  }

  /**
   * Holds if `call` is an invocation of `http.createServer` or `https.createServer`.
   */
  predicate isCreateServer(CallExpr call) {
    exists(string pkg, string fn |
      pkg = "http" and fn = "createServer"
      or
      pkg = "https" and fn = "createServer"
      or
      // http2 compatibility API
      pkg = "http2" and fn = "createServer"
      or
      pkg = "http2" and fn = "createSecureServer"
    |
      call = DataFlow::moduleMember(pkg, fn).getAnInvocation().asExpr()
    )
  }

  /**
   * A Node.js HTTP response.
   *
   * A server library that provides an (enhanced) NodesJS HTTP response
   * object should implement a library specific subclass of this class.
   */
  abstract class ResponseExpr extends HTTP::Servers::StandardResponseExpr { }

  /**
   * A Node.js HTTP request.
   *
   * A server library that provides an (enhanced) NodesJS HTTP request
   * object should implement a library specific subclass of this class.
   */
  abstract class RequestExpr extends HTTP::Servers::StandardRequestExpr { }

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
    SimpleParameter getRequestParameter() { result = getFunction().getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    SimpleParameter getResponseParameter() { result = getFunction().getParameter(1) }
  }

  /**
   * A route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler {
    StandardRouteHandler() { this = any(RouteSetup setup).getARouteHandler() }
  }

  /**
   * A Node.js response source, that is, the response parameter of a
   * route handler.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() { this = DataFlow::parameterNode(rh.getResponseParameter()) }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Node.js request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends HTTP::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = DataFlow::parameterNode(rh.getRequestParameter()) }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
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
      exists(PropAccess headers |
        // `req.headers.cookie`
        kind = "cookie" and
        headers.accesses(request, "headers") and
        this.asExpr().(PropAccess).accesses(headers, "cookie")
      )
      or
      exists(RequestHeaderAccess access | this = access |
        request = access.getRequest() and
        kind = "header"
      )
    }

    override HTTP::RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * An access to an HTTP header (other than "Cookie") on an incoming Node.js request object.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RequestExpr request;

    RequestHeaderAccess() {
      exists(PropAccess headers, string name |
        // `req.headers.<name>`
        name != "cookie" and
        headers.accesses(request, "headers") and
        this.asExpr().(PropAccess).accesses(headers, name)
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override HTTP::RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = "header" }

    RequestExpr getRequest() { result = request }
  }

  class RouteSetup extends CallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    Expr handler;

    RouteSetup() {
      server.flowsTo(this) and
      handler = getLastArgument()
      or
      server.flowsTo(getReceiver()) and
      this.(MethodCallExpr).getMethodName().regexpMatch("on(ce)?") and
      getArgument(0).getStringValue() = "request" and
      handler = getArgument(1)
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = handler.flow().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = getARouteHandler(t2).backtrack(t2, t))
    }

    override Expr getServer() { result = server }

    /**
     * Gets the expression for the handler registered by this setup.
     */
    Expr getRouteHandlerExpr() { result = handler }
  }

  abstract private class HeaderDefinition extends HTTP::Servers::StandardHeaderDefinition {
    ResponseExpr r;

    HeaderDefinition() { astNode.getReceiver() = r }

    override HTTP::RouteHandler getRouteHandler() { result = r.getRouteHandler() }
  }

  /**
   * A call to the `setHeader` method of an HTTP response.
   */
  private class SetHeader extends HeaderDefinition {
    SetHeader() { astNode.getMethodName() = "setHeader" }
  }

  /**
   * A call to the `writeHead` method of an HTTP response.
   */
  private class WriteHead extends HeaderDefinition {
    WriteHead() {
      astNode.getMethodName() = "writeHead" and
      astNode.getNumArgument() >= 1
    }

    override predicate definesExplicitly(string headerName, Expr headerValue) {
      astNode.getNumArgument() > 1 and
      exists(DataFlow::SourceNode headers, string header |
        headers.flowsToExpr(astNode.getLastArgument()) and
        headers.hasPropertyWrite(header, DataFlow::valueNode(headerValue)) and
        headerName = header.toLowerCase()
      )
    }
  }

  /**
   * A call to a path-module method that preserves taint.
   */
  private class PathFlowTarget extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
    DataFlow::Node tainted;

    PathFlowTarget() {
      exists(string methodName | this = DataFlow::moduleMember("path", methodName).getACall() |
        // getters
        methodName = "basename" and tainted = getArgument(0)
        or
        methodName = "dirname" and tainted = getArgument(0)
        or
        methodName = "extname" and tainted = getArgument(0)
        or
        // transformers
        methodName = "join" and tainted = getAnArgument()
        or
        methodName = "normalize" and tainted = getArgument(0)
        or
        methodName = "relative" and tainted = getArgument([0 .. 1])
        or
        methodName = "resolve" and tainted = getAnArgument()
        or
        methodName = "toNamespacedPath" and tainted = getArgument(0)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = tainted and succ = this
    }
  }

  /**
   * A call to a fs-module method that preserves taint.
   */
  private class FsFlowTarget extends TaintTracking::AdditionalTaintStep {
    DataFlow::Node tainted;

    FsFlowTarget() {
      exists(DataFlow::CallNode call, string methodName |
        call = DataFlow::moduleMember("fs", methodName).getACall()
      |
        methodName = "realpathSync" and
        tainted = call.getArgument(0) and
        this = call
        or
        methodName = "realpath" and
        tainted = call.getArgument(0) and
        this = call.getCallback(1).getParameter(1)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = tainted and succ = this
    }
  }

  /**
   * A model of taint propagation through `new Buffer` and `Buffer.from`.
   */
  private class BufferTaintStep extends TaintTracking::AdditionalTaintStep, DataFlow::InvokeNode {
    BufferTaintStep() {
      this = DataFlow::globalVarRef("Buffer").getAnInstantiation()
      or
      this = DataFlow::globalVarRef("Buffer").getAMemberInvocation("from")
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(0) and
      succ = this
    }
  }

  /**
   * An expression passed as the first argument to the `write` or `end` method
   * of an HTTP response.
   */
  private class ResponseSendArgument extends HTTP::ResponseSendArgument {
    HTTP::RouteHandler rh;

    ResponseSendArgument() {
      exists(MethodCallExpr mce, string m | m = "write" or m = "end" |
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
    ServerDefinition() { isCreateServer(this) }
  }

  /** An expression that is passed as `http.request({ auth: <expr> }, ...)`. */
  class Credentials extends CredentialsExpr {
    Credentials() {
      exists(string http | http = "http" or http = "https" |
        this =
          DataFlow::moduleMember(http, "request").getACall().getOptionArgument(0, "auth").asExpr()
      )
    }

    override string getCredentialsKind() { result = "credentials" }
  }

  /**
   * A call a process-terminating function, such as `process.exit`.
   */
  class ProcessTermination extends SensitiveAction, DataFlow::ValueNode {
    override CallExpr astNode;

    ProcessTermination() {
      this = DataFlow::moduleImport("exit").getAnInvocation()
      or
      this = processMember("exit").getACall()
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
    exists(ExternalMemberDecl decl, Function f, JSDocParamTag p, string n |
      decl.hasQualifiedName("fs", methodName) and
      f = decl.getInit() and
      p.getDocumentedParameter() = f.getParameter(i).getAVariable() and
      n = p.getName().toLowerCase()
    |
      n = "filename" or n.regexpMatch("(old|new|src|dst|)path")
    )
  }

  /**
   * Holds if the `i`th parameter of method `methodName` of the Node.js
   * `fs` module might represent a data parameter or buffer or a callback
   * that receives the data.
   *
   * We determine this by looking for an externs declaration for
   * `fs.methodName` where the `i`th parameter's name is `data` or
   * `buffer` or a `callback`.
   */
  private predicate fsDataParam(string methodName, int i, string n) {
    exists(ExternalMemberDecl decl, Function f, JSDocParamTag p |
      decl.hasQualifiedName("fs", methodName) and
      f = decl.getInit() and
      p.getDocumentedParameter() = f.getParameter(i).getAVariable() and
      n = p.getName().toLowerCase()
    |
      n = "data" or n = "buffer" or n = "callback"
    )
  }

  /**
   * A member `member` from module `fs` or its drop-in replacements `graceful-fs`, `fs-extra`, `original-fs`.
   */
  private DataFlow::SourceNode fsModuleMember(string member) {
    result = fsModule(DataFlow::TypeTracker::end()).getAPropertyRead(member)
  }

  private DataFlow::SourceNode fsModule(DataFlow::TypeTracker t) {
    exists(string moduleName |
      moduleName = "fs" or
      moduleName = "graceful-fs" or
      moduleName = "fs-extra" or
      moduleName = "original-fs"
    |
      result = DataFlow::moduleImport(moduleName)
      or
      // extra support for flexible names
      result.asExpr().(Require).getArgument(0).mayHaveStringValue(moduleName)
    ) and
    t.start()
    or
    exists(DataFlow::TypeTracker t2 | result = fsModule(t2).track(t2, t))
  }

  /**
   * A call to a method from module `fs`, `graceful-fs` or `fs-extra`.
   */
  private class NodeJSFileSystemAccess extends FileSystemAccess, DataFlow::CallNode {
    string methodName;

    NodeJSFileSystemAccess() { this = fsModuleMember(methodName).getACall() }

    /**
     * Gets the name of the called method.
     */
    string getMethodName() { result = methodName }

    override DataFlow::Node getAPathArgument() {
      exists(int i | fsFileParam(methodName, i) | result = getArgument(i))
    }
  }

  /** A write to the file system. */
  private class NodeJSFileSystemAccessWrite extends FileSystemWriteAccess, NodeJSFileSystemAccess {
    NodeJSFileSystemAccessWrite() {
      methodName = "appendFile" or
      methodName = "appendFileSync" or
      methodName = "write" or
      methodName = "writeFile" or
      methodName = "writeFileSync" or
      methodName = "writeSync"
    }

    override DataFlow::Node getADataNode() {
      exists(int i, string paramName | fsDataParam(methodName, i, paramName) |
        if paramName = "callback"
        then
          exists(DataFlow::ParameterNode p |
            p = getCallback(i).getAParameter() and
            p.getName().regexpMatch("(?i)data|buffer|string") and
            result = p
          )
        else result = getArgument(i)
      )
    }
  }

  /** A file system read. */
  private class NodeJSFileSystemAccessRead extends FileSystemReadAccess, NodeJSFileSystemAccess {
    NodeJSFileSystemAccessRead() {
      methodName = "read" or
      methodName = "readSync" or
      methodName = "readFile" or
      methodName = "readFileSync"
    }

    override DataFlow::Node getADataNode() {
      if methodName.regexpMatch(".*Sync")
      then result = this
      else
        exists(int i, string paramName | fsDataParam(methodName, i, paramName) |
          if paramName = "callback"
          then
            exists(DataFlow::ParameterNode p |
              p = getCallback(i).getAParameter() and
              p.getName().regexpMatch("(?i)data|buffer|string") and
              result = p
            )
          else result = getArgument(i)
        )
    }
  }

  /**
   * A write to the file system, using a stream.
   */
  private class FileStreamWrite extends FileSystemWriteAccess, DataFlow::CallNode {
    NodeJSFileSystemAccess stream;

    FileStreamWrite() {
      stream.getMethodName() = "createWriteStream" and
      exists(string method |
        method = "write" or
        method = "end"
      |
        this = stream.getAMemberCall(method)
      )
    }

    override DataFlow::Node getADataNode() { result = getArgument(0) }

    override DataFlow::Node getAPathArgument() { result = stream.getAPathArgument() }
  }

  /**
   * A read from the file system using a stream.
   */
  private class FileStreamRead extends FileSystemReadAccess, DataFlow::CallNode {
    NodeJSFileSystemAccess stream;
    string method;

    FileStreamRead() {
      stream.getMethodName() = "createReadStream" and
      this = stream.getAMemberCall(method) and
      (method = "read" or method = "pipe" or method = EventEmitter::on())
    }

    override DataFlow::Node getADataNode() {
      method = "read" and
      result = this
      or
      method = "pipe" and
      result = getArgument(0)
      or
      method = EventEmitter::on() and
      getArgument(0).mayHaveStringValue("data") and
      result = getCallback(1).getParameter(0)
    }

    override DataFlow::Node getAPathArgument() { result = stream.getAPathArgument() }
  }

  /**
   * A data flow node that contains a file name or an array of file names from the local file system.
   */
  private class NodeJSFileNameSource extends FileNameSource {
    NodeJSFileNameSource() {
      exists(string name |
        name = "readdir" or
        name = "realpath"
      |
        this = fsModuleMember(name).getACall().getCallback([1 .. 2]).getParameter(1) or
        this = fsModuleMember(name + "Sync").getACall()
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

    private DataFlow::Node getACommandArgument(boolean shell) {
      // check whether this is an invocation of an exec/spawn/fork method
      (
        shell = true and
        (
          methodName = "exec" or
          methodName = "execSync"
        )
        or
        shell = false and
        (
          methodName = "execFile" or
          methodName = "execFileSync" or
          methodName = "spawn" or
          methodName = "spawnSync" or
          methodName = "fork"
        )
      ) and
      // all of the above methods take the command as their first argument
      result = getArgument(0)
    }

    override DataFlow::Node getACommandArgument() { result = getACommandArgument(_) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = getACommandArgument(true) }

    override DataFlow::Node getArgumentList() {
      (
        methodName = "execFile" or
        methodName = "execFileSync" or
        methodName = "fork" or
        methodName = "spawn" or
        methodName = "spawnSync"
      ) and
      // all of the above methods take the argument list as their second argument
      result = getArgument(1)
    }

    override predicate isSync() { "Sync" = methodName.suffix(methodName.length() - 4) }

    override DataFlow::Node getOptionsArg() {
      not result.getALocalSource() instanceof DataFlow::FunctionNode and // looks like callback
      not result.getALocalSource() instanceof DataFlow::ArrayCreationNode and // looks like argumentlist
      not result = getArgument(0) and
      // fork/spawn and all sync methos always has options as the last argument
      if
        methodName.regexpMatch("fork.*") or
        methodName.regexpMatch("spawn.*") or
        methodName.regexpMatch(".*Sync")
      then result = getLastArgument()
      else
        // the rest (exec/execFile) has the options argument as their second last.
        result = getArgument(this.getNumArgument() - 2)
    }
  }

  /**
   * A function that looks like a Node.js route handler.
   *
   * For example, this could be the function `function(req, res){...}`.
   */
  class RouteHandlerCandidate extends HTTP::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      exists(string request, string response |
        (request = "request" or request = "req") and
        (response = "response" or response = "res") and
        // heuristic: parameter names match the Node.js documentation
        astNode.getNumParameter() = 2 and
        astNode.getParameter(0).getName() = request and
        astNode.getParameter(1).getName() = response
      |
        not (
          // heuristic: not a class method (Node.js invokes this with a function call)
          astNode = any(MethodDefinition def).getBody()
          or
          // heuristic: does not return anything (Node.js will not use the return value)
          exists(astNode.getAReturnStmt().getExpr())
          or
          // heuristic: is not invoked (Node.js invokes this at a call site we cannot reason precisely about)
          exists(DataFlow::InvokeNode cs | cs.getACallee() = astNode)
        )
      )
    }
  }

  /**
   * A function that flows to a route setup.
   */
  private class TrackedRouteHandlerCandidateWithSetup extends RouteHandler,
    HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    TrackedRouteHandlerCandidateWithSetup() { this = any(RouteSetup s).getARouteHandler() }
  }

  /**
   * A call to a method from module `vm`
   */
  class VmModuleMethodCall extends DataFlow::CallNode {
    string methodName;

    VmModuleMethodCall() { this = DataFlow::moduleMember("vm", methodName).getACall() }

    /**
     * Gets the code to be executed as part of this call.
     */
    DataFlow::Node getACodeArgument() {
      (
        methodName = "runInContext" or
        methodName = "runInNewContext" or
        methodName = "runInThisContext"
      ) and
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
      arg = getLastArgument()
      or
      getMethodName().regexpMatch("on(ce)?") and
      getArgument(0).mayHaveStringValue("request") and
      arg = getArgument(1)
    }

    override DataFlow::ValueNode getARouteHandlerArg() { result = arg }
  }

  /**
   * A data flow node that is an HTTP or HTTPS client request made by a Node.js application,
   * for example `http.request(url)`.
   */
  class NodeJSClientRequest extends ClientRequest {
    override NodeJSClientRequest::Range self;
  }

  module NodeJSClientRequest {
    /**
     * A data flow node that is an HTTP or HTTPS client request made by a Node.js application,
     * for example `http.request(url)`.
     *
     * Extend this class to add support for new Node.js client request APIs.
     */
    abstract class Range extends ClientRequest::Range { }
  }

  deprecated class CustomNodeJSClientRequest = NodeJSClientRequest::Range;

  /**
   * A model of a URL request in the Node.js `http` library.
   */
  private class NodeHttpUrlRequest extends NodeJSClientRequest::Range {
    DataFlow::Node url;

    NodeHttpUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        (moduleName = "http" or moduleName = "https") and
        (
          callee = DataFlow::moduleMember(moduleName, any(HTTP::RequestMethodName m).toLowerCase())
          or
          callee = DataFlow::moduleMember(moduleName, "request")
        ) and
        url = getArgument(0)
      )
    }

    override DataFlow::Node getUrl() { result = url }

    override DataFlow::Node getHost() {
      exists(string name |
        name = "host" or
        name = "hostname"
      |
        result = getOptionArgument(1, name)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "write" or name = "end" |
        result = this.(DataFlow::SourceNode).getAMethodCall(name).getArgument(0)
      )
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      promise = false and
      exists(DataFlow::ParameterNode res, DataFlow::CallNode onData |
        res = getCallback(1).getParameter(0) and
        onData = res.getAMethodCall(EventEmitter::on()) and
        onData.getArgument(0).mayHaveStringValue("data") and
        result = onData.getCallback(1).getParameter(0) and
        responseType = "arraybuffer"
      )
    }
  }

  /**
   * A data flow node that is registered as a callback for an HTTP or HTTPS request made by a Node.js process, for example the function `handler` in `http.request(url).on(message, handler)`.
   */
  class ClientRequestHandler extends DataFlow::FunctionNode {
    string handledEvent;
    NodeJSClientRequest clientRequest;

    ClientRequestHandler() {
      exists(DataFlow::MethodCallNode mcn |
        clientRequest.getAMethodCall(EventEmitter::on()) = mcn and
        mcn.getArgument(0).mayHaveStringValue(handledEvent) and
        flowsTo(mcn.getArgument(1))
      )
    }

    /**
     * Gets the name of an event this callback is registered for.
     */
    string getAHandledEvent() { result = handledEvent }

    /**
     * Gets a request this callback is registered for.
     */
    NodeJSClientRequest getClientRequest() { result = clientRequest }
  }

  /**
   * A data flow node that is the parameter of a response callback for an HTTP or HTTPS request made by a Node.js process, for example `res` in `http.request(url).on('response', (res) => {})`.
   */
  private class ClientRequestResponseEvent extends RemoteFlowSource, DataFlow::ParameterNode {
    ClientRequestResponseEvent() {
      exists(ClientRequestHandler handler |
        this = handler.getParameter(0) and
        handler.getAHandledEvent() = "response"
      )
    }

    override string getSourceType() { result = "NodeJSClientRequest response event" }
  }

  /**
   * A data flow node that is the parameter of a data callback for an HTTP or HTTPS request made by a Node.js process, for example `chunk` in `http.request(url).on('response', (res) => {res.on('data', (chunk) => {})})`.
   */
  private class ClientRequestDataEvent extends RemoteFlowSource {
    ClientRequestDataEvent() {
      exists(DataFlow::MethodCallNode mcn, ClientRequestResponseEvent cr |
        cr.getAMethodCall(EventEmitter::on()) = mcn and
        mcn.getArgument(0).mayHaveStringValue("data") and
        this = mcn.getCallback(1).getParameter(0)
      )
    }

    override string getSourceType() { result = "NodeJSClientRequest data event" }
  }

  /**
   * A data flow node that is a login callback for an HTTP or HTTPS request made by a Node.js process.
   */
  private class ClientRequestLoginHandler extends ClientRequestHandler {
    ClientRequestLoginHandler() { getAHandledEvent() = "login" }
  }

  /**
   * A data flow node that is a parameter of a login callback for an HTTP or HTTPS request made by a Node.js process, for example `res` in `http.request(url).on('login', (res, callback) => {})`.
   */
  private class ClientRequestLoginEvent extends RemoteFlowSource {
    ClientRequestLoginEvent() {
      exists(ClientRequestLoginHandler handler | this = handler.getParameter(0))
    }

    override string getSourceType() { result = "NodeJSClientRequest login event" }
  }

  /**
   * A data flow node that is the login callback provided by an HTTP or HTTPS request made by a Node.js process, for example `callback` in `http.request(url).on('login', (res, callback) => {})`.
   */
  class ClientRequestLoginCallback extends DataFlow::ParameterNode {
    ClientRequestLoginCallback() {
      exists(ClientRequestLoginHandler handler | this = handler.getParameter(1))
    }
  }

  /**
   * A data flow node that is the username passed to the login callback provided by an HTTP or HTTPS request made by a Node.js process, for example `username` in `http.request(url).on('login', (res, cb) => {cb(username, password)})`.
   */
  private class ClientRequestLoginUsername extends CredentialsExpr {
    ClientRequestLoginUsername() {
      exists(ClientRequestLoginCallback callback |
        this = callback.getACall().getArgument(0).asExpr()
      )
    }

    override string getCredentialsKind() { result = "Node.js http(s) client login username" }
  }

  /**
   * A data flow node that is the password passed to the login callback provided by an HTTP or HTTPS request made by a Node.js process, for example `password` in `http.request(url).on('login', (res, cb) => {cb(username, password)})`.
   */
  private class ClientRequestLoginPassword extends CredentialsExpr {
    ClientRequestLoginPassword() {
      exists(ClientRequestLoginCallback callback |
        this = callback.getACall().getArgument(1).asExpr()
      )
    }

    override string getCredentialsKind() { result = "Node.js http(s) client login password" }
  }

  /**
   * A data flow node that is the parameter of an error callback for an HTTP or HTTPS request made by a Node.js process, for example `err` in `http.request(url).on('error', (err) => {})`.
   */
  private class ClientRequestErrorEvent extends RemoteFlowSource {
    ClientRequestErrorEvent() {
      exists(ClientRequestHandler handler |
        this = handler.getParameter(0) and
        handler.getAHandledEvent() = "error"
      )
    }

    override string getSourceType() { result = "NodeJSClientRequest error event" }
  }

  /**
   * An NodeJS EventEmitter instance.
   * Events dispatched on this EventEmitter will be handled by event handlers registered on this EventEmitter.
   * (That is opposed to e.g. SocketIO, which implements the same interface, but where events cross object boundaries).
   */
  abstract class NodeJSEventEmitter extends EventEmitter::Range {
    /**
     * Get a Node that refers to a NodeJS EventEmitter instance.
     */
    DataFlow::SourceNode ref() { result = EventEmitter::trackEventEmitter(this) }
  }

  /**
   * Gets an import of the NodeJS EventEmitter.
   */
  private DataFlow::SourceNode getAnEventEmitterImport() {
    result = DataFlow::moduleImport("events") or
    result = DataFlow::moduleMember("events", "EventEmitter")
  }

  /**
   * An instance of an EventEmitter that is imported through the 'events' module.
   */
  private class ImportedNodeJSEventEmitter extends NodeJSEventEmitter {
    ImportedNodeJSEventEmitter() { this = getAnEventEmitterImport().getAnInstantiation() }
  }

  /**
   * The NodeJS `process` object as an EventEmitter subclass.
   */
  private class ProcessAsNodeJSEventEmitter extends NodeJSEventEmitter {
    ProcessAsNodeJSEventEmitter() { this = process() }
  }

  /**
   * A class that extends EventEmitter.
   */
  private class EventEmitterSubClass extends DataFlow::ClassNode {
    EventEmitterSubClass() {
      this.getASuperClassNode().getALocalSource() = getAnEventEmitterImport() or
      this.getADirectSuperClass() instanceof EventEmitterSubClass
    }
  }

  /**
   * An instantiation of a class that extends EventEmitter.
   *
   * By extending `NodeJSEventEmitter' we get data-flow on the events passing through this EventEmitter.
   */
  class CustomEventEmitter extends NodeJSEventEmitter {
    EventEmitterSubClass clazz;

    CustomEventEmitter() {
      if exists(clazz.getAClassReference().getAnInstantiation())
      then this = clazz.getAClassReference().getAnInstantiation()
      else
        // In case there are no explicit instantiations of the clazz, then we still want to track data flow between `this` nodes.
        // This cannot produce false flow as the `.ref()` method below is always used when creating event-registrations/event-dispatches.
        this = clazz
    }

    override DataFlow::SourceNode ref() {
      result = NodeJSEventEmitter.super.ref() and not this = clazz
      or
      result = clazz.getAReceiverNode()
    }
  }

  /**
   * A registration of an event handler on a NodeJS EventEmitter instance.
   */
  private class NodeJSEventRegistration extends EventRegistration::DefaultEventRegistration,
    DataFlow::MethodCallNode {
    override NodeJSEventEmitter emitter;

    NodeJSEventRegistration() { this = emitter.ref().getAMethodCall(EventEmitter::on()) }
  }

  /**
   * A dispatch of an event on a NodeJS EventEmitter instance.
   */
  private class NodeJSEventDispatch extends EventDispatch::DefaultEventDispatch,
    DataFlow::MethodCallNode {
    override NodeJSEventEmitter emitter;

    NodeJSEventDispatch() { this = emitter.ref().getAMethodCall("emit") }
  }

  /**
   * An instance of net.createServer(), which creates a new TCP/IPC server.
   */
  private class NodeJSNetServer extends DataFlow::SourceNode {
    NodeJSNetServer() { this = DataFlow::moduleMember("net", "createServer").getAnInvocation() }

    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and result = this
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    /**
     * Gets a reference to this server.
     */
    DataFlow::SourceNode ref() { result = ref(DataFlow::TypeTracker::end()) }
  }

  /**
   * A connection opened on a NodeJS net server.
   */
  private class NodeJSNetServerConnection extends EventEmitter::Range {
    NodeJSNetServer server;

    NodeJSNetServerConnection() {
      exists(DataFlow::MethodCallNode call |
        call = server.ref().getAMethodCall("on") and
        call.getArgument(0).mayHaveStringValue("connection")
      |
        this = call.getCallback(1).getParameter(0)
      )
    }

    DataFlow::SourceNode ref() { result = EventEmitter::trackEventEmitter(this) }
  }

  /**
   * A registration of an event handler on a NodeJS net server instance.
   */
  private class NodeJSNetServerRegistration extends EventRegistration::DefaultEventRegistration,
    DataFlow::MethodCallNode {
    override NodeJSNetServerConnection emitter;

    NodeJSNetServerRegistration() { this = emitter.ref().getAMethodCall(EventEmitter::on()) }
  }

  /**
   * A data flow node representing data received from a client to a NodeJS net server, viewed as remote user input.
   */
  private class NodeJSNetServerItemAsRemoteFlow extends RemoteFlowSource {
    NodeJSNetServerRegistration reg;

    NodeJSNetServerItemAsRemoteFlow() { this = reg.getReceivedItem(_) }

    override string getSourceType() { result = "NodeJS server" }
  }

  /**
   * An instantiation of the `respjs` library, which is an EventEmitter.
   */
  private class RespJS extends NodeJSEventEmitter {
    RespJS() { this = DataFlow::moduleImport("respjs").getAnInstantiation() }
  }

  /**
   * A event dispatch that serializes the input data and emits the result on the "data" channel.
   */
  private class RespWrite extends EventDispatch::DefaultEventDispatch, DataFlow::MethodCallNode {
    override RespJS emitter;

    RespWrite() { this = emitter.ref().getAMethodCall("write") }

    override string getChannel() { result = "data" }

    override DataFlow::Node getSentItem(int i) { i = 0 and result = this.getArgument(i) }
  }

  /**
   * Provides predicates for working with the "path" module and its platform-specific instances as a single module.
   */
  module Path {
    /**
     * Gets a node that imports the "path" module, or one of its platform-specific instances.
     */
    DataFlow::SourceNode moduleImport() {
      result = DataFlow::moduleImport("path") or
      result = DataFlow::moduleMember("path", "posix") or
      result = DataFlow::moduleMember("path", "win32")
    }

    /**
     * Gets an access to member `member` of the "path" module, or one of its platform-specific instances.
     */
    DataFlow::SourceNode moduleMember(string member) {
      result = moduleImport().getAPropertyRead(member)
    }
  }
}
