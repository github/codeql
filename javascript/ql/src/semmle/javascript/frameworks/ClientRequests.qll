/**
 * Provides classes for modelling the client-side of a URL request.
 *
 * Subclass `ClientRequest` to refine the behavior of the analysis on existing client requests.
 * Subclass `ClientRequest::Range` to introduce new kinds of client requests.
 */

import javascript

/**
 * A call that performs a request to a URL.
 *
 * Example: An HTTP POST request is client request that sends some
 * `data` to a `url`, where both the headers and the body of the request
 * contribute to the `data`.
 *
 * Extend this class to work with client request APIs for which there is already a model.
 * To model additional APIs, extend `ClientRequest::Range` and implement its abstract member
 * predicates.
 */
class ClientRequest extends DataFlow::InvokeNode {
  ClientRequest::Range self;

  ClientRequest() { this = self }

  /**
   * Gets the URL of the request.
   */
  DataFlow::Node getUrl() { result = self.getUrl() }

  /**
   * Gets the host of the request.
   */
  DataFlow::Node getHost() { result = self.getHost() }

  /**
   * Gets a node that contributes to the data-part this request.
   */
  DataFlow::Node getADataNode() { result = self.getADataNode() }

  /**
   * Gets a data flow node that refers to some representation of the response, possibly
   * wrapped in a promise object.
   *
   * The `responseType` describes how the response is represented as a JavaScript value
   * (after resolving promises), and may assume the following values:
   * - Any response type defined by [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/responseType):
   *    - `text`: The result is a string
   *    - `json`: The result is a deserialized JSON object
   *    - `arraybuffer`: The result is an `ArrayBuffer` object
   *    - `blob`: The result is a `Blob` object
   *    - `document`: The result is a deserialized HTML or XML document
   * - Any of the following additional response types defined by this library:
   *    - `fetch.response`: The result is a `Response` object from [fetch](https://developer.mozilla.org/en-US/docs/Web/API/Response).
   *    - `stream`: The result is a Node.js stream and `http.IncomingMessage` object
   *    - `header`: The result is the value of a header, as a string
   *    - `headers`: The result is a mapping from header names to their values.
   *    - `error`: The result is an error in an unspecified format, possibly containing information from the response
   *    - An empty string, indicating an unknown response type.
   * - Any value provided by custom implementations of `ClientRequest::Range`.
   */
  DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
    result = self.getAResponseDataNode(responseType, promise)
  }

  /**
   * Gets a node that refers to data from the response, possibly
   * wrapped in a promise object.
   */
  DataFlow::Node getAResponseDataNode() { result = getAResponseDataNode(_, _) }

  /**
   * Gets a data-flow node that determines where in the file-system the result of the request should be saved.
   */
  DataFlow::Node getASavePath() { result = self.getASavePath() }
}

deprecated class CustomClientRequest = ClientRequest::Range;

module ClientRequest {
  /**
   * A call that performs a request to a URL.
   *
   * Extend this class and implement its abstract member predicates to model additional
   * client request APIs. To work with APIs for which there is already a model, extend
   * `ClientRequest` instead.
   */
  abstract class Range extends DataFlow::InvokeNode {
    /**
     * Gets the URL of the request.
     */
    abstract DataFlow::Node getUrl();

    /**
     * Gets the host of the request.
     */
    abstract DataFlow::Node getHost();

    /**
     * Gets a node that contributes to the data-part this request.
     */
    abstract DataFlow::Node getADataNode();

    /**
     * Gets a data flow node that refers to some representation of the response, possibly
     * wrapped in a promise object.
     *
     * See the decription of `responseType` in `ClientRequest::getAResponseDataNode`.
     */
    DataFlow::Node getAResponseDataNode(string responseType, boolean promise) { none() }

    /**
     * Gets a data-flow node that determines where in the file-system the result of the request should be saved.
     */
    DataFlow::Node getASavePath() { none() }
  }

  /**
   * Gets the name of an HTTP request method, in all-lowercase.
   */
  private string httpMethodName() { result = any(HTTP::RequestMethodName m).toLowerCase() }

  /**
   * Gets a model of an instance of the `request` library, or one of
   * its wrappers, `promise` is true if the instance uses promises
   * rather than callbacks.
   */
  private DataFlow::SourceNode getRequestLibrary(boolean promise) {
    exists(string moduleName | result = DataFlow::moduleImport(moduleName) |
      promise = false and
      moduleName = "request"
      or
      promise = true and
      (
        moduleName = "request-promise" or
        moduleName = "request-promise-any" or
        moduleName = "request-promise-native"
      )
    )
    or
    result = getRequestLibrary(promise).getAMethodCall("defaults")
  }

  /**
   * A model of a URL request made using the `request` library.
   */
  class RequestUrlRequest extends ClientRequest::Range, DataFlow::CallNode {
    boolean promise;

    RequestUrlRequest() {
      exists(DataFlow::SourceNode callee | this = callee.getACall() |
        callee = getRequestLibrary(promise) or
        callee = getRequestLibrary(promise).getAPropertyRead(httpMethodName())
      )
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) or
      result = getOptionArgument(0, urlPropertyName())
    }

    override DataFlow::Node getHost() { none() }

    /** Gets the response type from the options passed in. */
    string getResponseType() {
      if getOptionArgument(1, "json").mayHaveBooleanValue(true)
      then result = "json"
      else result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean pr) {
      responseType = getResponseType() and
      promise = true and
      pr = true and
      result = this
      or
      responseType = getResponseType() and
      promise = false and
      pr = false and
      (
        result = getCallback([1 .. 2]).getParameter(2)
        or
        result = getCallback([1 .. 2]).getParameter(1).getAPropertyRead("body")
      )
      or
      responseType = "error" and
      promise = false and
      pr = false and
      result = getCallback([1 .. 2]).getParameter(0)
    }

    override DataFlow::Node getADataNode() { result = getArgument(1) }

    override DataFlow::Node getASavePath() {
      exists(DataFlow::CallNode write |
        write = DataFlow::moduleMember("fs", "createWriteStream").getACall() and
        write = this.getAMemberCall("pipe").getArgument(0).getALocalSource() and
        result = write.getArgument(0)
      )
    }
  }

  /** Gets the string `url` or `uri`. */
  private string urlPropertyName() { result = "url" or result = "uri" }

  /**
   * A model of a URL request made using the `axios` library.
   */
  class AxiosUrlRequest extends ClientRequest::Range {
    string method;

    AxiosUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        moduleName = "axios" and
        (
          callee = DataFlow::moduleImport(moduleName) and method = "request"
          or
          callee = DataFlow::moduleMember(moduleName, method) and
          (method = httpMethodName() or method = "request")
        )
      )
    }

    private int getOptionsArgIndex() {
      method = "request" and
      result = 0
      or
      (method = "get" or method = "delete" or method = "head") and
      result = 1
      or
      (method = "post" or method = "put" or method = "patch") and
      result = 2
    }

    private DataFlow::Node getOptionArgument(string name) {
      result = getOptionArgument(getOptionsArgIndex(), name)
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) or
      result = getOptionArgument(urlPropertyName())
    }

    override DataFlow::Node getHost() { result = getOptionArgument("host") }

    override DataFlow::Node getADataNode() {
      method = "request" and
      result = getOptionArgument(0, "data")
      or
      (method = "post" or method = "put" or method = "put") and
      (result = getArgument(1) or result = getOptionArgument(2, "data"))
      or
      exists(string name | name = "headers" or name = "params" |
        result = getOptionArgument([0 .. 2], name)
      )
    }

    /** Gets the response type from the options passed in. */
    string getResponseType() {
      exists(DataFlow::Node option | option = getOptionArgument("responseType") |
        option.mayHaveStringValue(result)
        or
        option.analyze().getAValue().isIndefinite(_) and
        result = ""
      )
      or
      not exists(getOptionArgument("responseType")) and
      result = "json"
      or
      getArgument(getOptionsArgIndex()).analyze().getAValue().isIndefinite(_) and
      result = ""
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = getResponseType() and
      promise = true and
      result = this
    }
  }

  /** An expression that is used as a credential in a request. */
  private class AuthorizationHeader extends CredentialsExpr {
    AuthorizationHeader() {
      exists(DataFlow::PropWrite write | write.getPropertyName().regexpMatch("(?i)authorization") |
        this = write.getRhs().asExpr()
      )
      or
      exists(DataFlow::MethodCallNode call | call.getMethodName() = ["append", "set"] |
        call.getNumArgument() = 2 and
        call.getArgument(0).getStringValue().regexpMatch("(?i)authorization") and
        this = call.getArgument(1).asExpr()
      )
    }

    override string getCredentialsKind() { result = "authorization header" }
  }

  /**
   * A model of a URL request made using an implementation of the `fetch` API.
   */
  class FetchUrlRequest extends ClientRequest::Range {
    DataFlow::Node url;

    FetchUrlRequest() {
      exists(DataFlow::SourceNode fetch |
        fetch = DataFlow::moduleImport(["node-fetch", "cross-fetch", "isomorphic-fetch"])
        or
        fetch = DataFlow::globalVarRef("fetch") // https://fetch.spec.whatwg.org/#fetch-api
      |
        this = fetch.getACall() and
        url = getArgument(0)
      )
    }

    override DataFlow::Node getUrl() { result = url }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "headers" or name = "body" | result = getOptionArgument(1, name))
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "fetch.response" and
      promise = true and
      result = this
    }
  }

  /**
   * Classes for modelling the url request library `needle`.
   */
  private module Needle {
    /**
     * A model of a URL request made using `require("needle")(...)`.
     */
    class PromisedNeedleRequest extends ClientRequest::Range {
      DataFlow::Node url;

      PromisedNeedleRequest() { this = DataFlow::moduleImport("needle").getACall() }

      override DataFlow::Node getUrl() { result = getArgument(1) }

      override DataFlow::Node getHost() { none() }

      override DataFlow::Node getADataNode() {
        result = getOptionArgument([2, 3], "headers")
        or
        result = getArgument(2)
      }

      override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
        responseType = "fetch.response" and
        promise = true and
        result = this
      }
    }

    /**
     * A model of a URL request made using `require("needle")[method](...)`.
     * E.g. `needle.get("http://example.org", (err, resp, body) => {})`.
     *
     * As opposed to the calls modeled in `PromisedNeedleRequest` these calls do not return promises.
     * Instead they take an optional callback as their last argument.
     */
    class NeedleMethodRequest extends ClientRequest::Range {
      boolean hasData;

      NeedleMethodRequest() {
        exists(string method |
          method = ["get", "head"] and hasData = false
          or
          method = ["post", "put", "patch", "delete"] and hasData = true
          or
          method = "request" and hasData = [true, false]
        |
          this = DataFlow::moduleMember("needle", method).getACall()
        )
      }

      override DataFlow::Node getUrl() { result = getArgument(0) }

      override DataFlow::Node getHost() { none() }

      override DataFlow::Node getADataNode() {
        hasData = true and
        (
          result = getArgument(1)
          or
          result = getOptionArgument(2, "headers")
        )
        or
        hasData = false and
        result = getOptionArgument(1, "headers")
      }

      override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
        promise = false and
        result = this.getABoundCallbackParameter(this.getNumArgument() - 1, 1) and
        responseType = "fetch.response"
        or
        promise = false and
        result = this.getABoundCallbackParameter(this.getNumArgument() - 1, 2) and
        responseType = "json"
      }
    }
  }

  /**
   * A model of a URL request made using the `got` library.
   */
  class GotUrlRequest extends ClientRequest::Range {
    GotUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        moduleName = "got" and
        (
          callee = DataFlow::moduleImport(moduleName) or
          callee = DataFlow::moduleMember(moduleName, "stream")
        )
      )
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) and
      not exists(getOptionArgument(1, "baseUrl"))
    }

    override DataFlow::Node getHost() {
      exists(string name |
        name = "host" or
        name = "hostname"
      |
        result = getOptionArgument(1, name)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "headers" or name = "body" or name = "query" |
        result = getOptionArgument(1, name)
      )
    }

    /** Holds if the result is a stream. */
    predicate isStream() {
      getOptionArgument(1, "stream").mayHaveBooleanValue(true)
      or
      this = DataFlow::moduleMember("got", "stream").getACall()
    }

    /** Holds if the result is a JSON object. */
    predicate isJson() { getOptionArgument(1, "json").mayHaveBooleanValue(true) }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      result = this and
      if isStream()
      then
        responseType = "stream" and
        promise = false
      else
        if isJson()
        then (
          responseType = "json" and
          promise = true
        ) else (
          responseType = "text" and
          promise = true
        )
    }
  }

  /**
   * Gets an instantiation `socket` of `require("net").Socket` type tracked using `t`.
   */
  private DataFlow::SourceNode netSocketInstantiation(
    DataFlow::TypeTracker t, DataFlow::NewNode socket
  ) {
    t.start() and
    socket = DataFlow::moduleMember("net", "Socket").getAnInstantiation() and
    result = socket
    or
    exists(DataFlow::TypeTracker t2 | result = netSocketInstantiation(t2, socket).track(t2, t))
  }

  /**
   * A model of a request made using `(new require("net").Socket()).connect(args);`.
   */
  class NetSocketRequest extends ClientRequest::Range {
    DataFlow::NewNode socket;

    NetSocketRequest() {
      this = netSocketInstantiation(DataFlow::TypeTracker::end(), socket).getAMethodCall("connect")
    }

    override DataFlow::Node getUrl() {
      result = getArgument([0, 1]) // there are multiple overrides of `connect`, and the URL can be in the first or second argument.
    }

    override DataFlow::Node getHost() { result = getOptionArgument(0, "host") }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "text" and
      promise = false and
      exists(DataFlow::CallNode call |
        call = netSocketInstantiation(DataFlow::TypeTracker::end(), socket).getAMemberCall("on") and
        call.getArgument(0).mayHaveStringValue("data") and
        result = call.getABoundCallbackParameter(1, 0)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(DataFlow::CallNode call |
        call = netSocketInstantiation(DataFlow::TypeTracker::end(), socket).getAMemberCall("write") and
        result = call.getArgument(0)
      )
    }
  }

  /**
   * A model of a URL request made using the `superagent` library.
   */
  class SuperAgentUrlRequest extends ClientRequest::Range {
    DataFlow::Node url;

    SuperAgentUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        moduleName = "superagent" and
        callee = DataFlow::moduleMember(moduleName, httpMethodName()) and
        url = getArgument(0)
      )
    }

    override DataFlow::Node getUrl() { result = url }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "set" or name = "send" or name = "query" |
        result = this.getAChainedMethodCall(name).getAnArgument()
      )
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "stream" and
      promise = true and
      result = this
      or
      exists(DataFlow::FunctionNode callback |
        callback = getAChainedMethodCall("end").getCallback(0) and
        promise = false and
        (
          responseType = "error" and result = callback.getParameter(0)
          or
          responseType = "stream" and result = callback.getParameter(1)
        )
      )
    }
  }

  /**
   * A model of a URL request made using the `XMLHttpRequest` browser class.
   *
   * Note: Prefer to use the `ClientRequest` class as it is more general.
   */
  class XMLHttpRequest extends ClientRequest::Range {
    XMLHttpRequest() {
      this = DataFlow::globalVarRef("XMLHttpRequest").getAnInstantiation()
      or
      // closure shim for XMLHttpRequest
      this = Closure::moduleImport("goog.net.XmlHttp").getAnInvocation()
    }

    override DataFlow::Node getUrl() { result = getAMethodCall("open").getArgument(1) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = getAMethodCall("send").getArgument(0) }

    private string getExplicitResponseType() {
      getAPropertyWrite("responseType").getRhs().mayHaveStringValue(result)
    }

    /**
     * Gets the response type corresponding to the `response` property,
     * but not the explicitly typed properties, `reponseText` and `responseXML`.
     */
    string getAssignedResponseType() {
      result = getExplicitResponseType()
      or
      not exists(getExplicitResponseType()) and
      result = "text"
    }

    /** Gets an event listener registered on this XHR object. */
    DataFlow::FunctionNode getAnEventListener() {
      result = getAPropertyWrite("on" + any(string s)).getRhs().getAFunctionValue()
      or
      result = getAMethodCall("addEventListener").getArgument(1).getAFunctionValue()
    }

    /**
     * Gets a node that refers to this XHR object.
     *
     * In particular, this can be the receiver of an event handler.
     */
    DataFlow::SourceNode getAnAlias() {
      result = this
      or
      // The value of `this` in an event listener refers to the XHR object
      result = getAnEventListener().getReceiver()
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      promise = false and
      (
        exists(string prop | result = getAnAlias().getAPropertyRead(prop) |
          prop = "response" and responseType = getAssignedResponseType()
          or
          prop = "responseText" and responseType = "text"
          or
          prop = "responseUrl" and responseType = "text"
          or
          prop = "statusText" and responseType = "text"
          or
          prop = "responseXML" and responseType = "document"
        )
        or
        exists(string method | result = getAnAlias().getAMethodCall(method) |
          method = "getAllResponseHeaders" and responseType = "headers"
          or
          method = "getResponseHeader" and responseType = "header"
        )
      )
    }
  }

  /**
   * A model of a URL request made using the `XhrIo` class from the closure library.
   */
  class ClosureXhrIoRequest extends ClientRequest::Range {
    DataFlow::SourceNode base;
    boolean static;

    ClosureXhrIoRequest() {
      exists(DataFlow::SourceNode xhrIo | xhrIo = Closure::moduleImport("goog.net.XhrIo") |
        static = true and
        base = xhrIo and
        this = xhrIo.getAMethodCall("send")
        or
        static = false and
        base = xhrIo.getAnInstantiation() and
        this = base.getAMethodCall("send")
      )
    }

    override DataFlow::Node getUrl() { result = getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = getArgument([2 .. 3]) }

    /** Gets an event listener with `this` bound to this object. */
    DataFlow::FunctionNode getAnEventListener() {
      static = true and
      result = getAnArgument().getAFunctionValue()
      or
      static = false and
      exists(DataFlow::MethodCallNode listen, string name |
        listen = base.getAMethodCall(name) and
        (name = "listen" or name = "listenOnce") and
        base.flowsTo(listen.getArgument(3)) and
        result = listen
      )
    }

    /**
     * Gets a node that refers to this XHR object.
     *
     * In particular, this can be the receiver of an event handler.
     */
    DataFlow::SourceNode getAnAlias() {
      static = false and
      result = base
      or
      result = getAnEventListener().getReceiver()
    }

    /**
     * Gets the response type corresponding to `getReponse()` but not
     * for explicitly typed calls like `getResponseJson()`.
     */
    string getAssignedResponseType() {
      getAMethodCall("setResponseType").getArgument(0).mayHaveStringValue(result)
      or
      not exists(getAMethodCall("setResponseType")) and
      result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      promise = false and
      exists(string method | result = getAnAlias().getAMethodCall(method) |
        method = "getResponse" and responseType = getAssignedResponseType()
        or
        method = "getResponseHeader" and responseType = "header"
        or
        method = "getResponseHeaders" and responseType = "headers"
        or
        method = "getResponseJson" and responseType = "json"
        or
        method = "getResponseText" and responseType = "text"
        or
        method = "getResponseXml" and responseType = "document"
        or
        method = "getStatusText" and responseType = "text"
      )
    }
  }

  /**
   * Gets a reference to an instance of `chrome-remote-interface`.
   *
   * An instantiation of `chrome-remote-interface` either accepts a callback or returns a promise.
   *
   * The `isPromise` parameter reflects whether the reference is a promise containing
   * an instance of `chrome-remote-interface`, or an instance of `chrome-remote-interface`.
   */
  private DataFlow::SourceNode chromeRemoteInterface(DataFlow::TypeTracker t) {
    exists(DataFlow::CallNode call |
      call = DataFlow::moduleImport("chrome-remote-interface").getAnInvocation()
    |
      // the client is inside in a promise.
      t.startInPromise() and result = call
      or
      // the client is accessed directly using a callback.
      t.start() and result = call.getCallback([0 .. 1]).getParameter(0)
    )
    or
    exists(DataFlow::TypeTracker t2 | result = chromeRemoteInterface(t2).track(t2, t))
  }

  /**
   * A call to navigate a browser controlled by `chrome-remote-interface` to a specific URL.
   */
  class ChromeRemoteInterfaceRequest extends ClientRequest::Range, DataFlow::CallNode {
    int optionsArg;

    ChromeRemoteInterfaceRequest() {
      exists(DataFlow::SourceNode instance |
        instance = chromeRemoteInterface(DataFlow::TypeTracker::end())
      |
        optionsArg = 0 and
        this = instance.getAPropertyRead("Page").getAMemberCall("navigate")
        or
        optionsArg = 1 and
        this = instance.getAMemberCall("send") and
        this.getArgument(0).mayHaveStringValue("Page.navigate")
      )
    }

    override DataFlow::Node getUrl() {
      result = getArgument(optionsArg).getALocalSource().getAPropertyWrite("url").getRhs()
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * A call to `nugget` that downloads one of more files to a destination determined by an options object given as the second argument.
   */
  class Nugget extends ClientRequest::Range, DataFlow::CallNode {
    Nugget() { this = DataFlow::moduleImport("nugget").getACall() }

    override DataFlow::Node getUrl() { result = getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }

    override DataFlow::Node getASavePath() {
      result = this.getArgument(1).getALocalSource().getAPropertyWrite("target").getRhs()
    }
  }

  /**
   * A shell execution of `curl` that downloads some file.
   */
  class CurlDownload extends ClientRequest::Range {
    SystemCommandExecution cmd;

    CurlDownload() {
      this = cmd and
      (
        cmd.getACommandArgument().getStringValue() = "curl" or
        cmd
            .getACommandArgument()
            .(StringOps::ConcatenationRoot)
            .getConstantStringParts()
            .regexpMatch("curl .*")
      )
    }

    override DataFlow::Node getUrl() {
      result = cmd.getArgumentList().getALocalSource().getAPropertyWrite().getRhs() or
      result = cmd.getACommandArgument().(StringOps::ConcatenationRoot).getALeaf()
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }
}
