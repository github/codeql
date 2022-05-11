/**
 * Provides classes for modeling the client-side of a URL request.
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
class ClientRequest extends DataFlow::InvokeNode instanceof ClientRequest::Range {
  /**
   * Gets the URL of the request.
   */
  DataFlow::Node getUrl() { result = super.getUrl() }

  /**
   * Gets the host of the request.
   */
  DataFlow::Node getHost() { result = super.getHost() }

  /**
   * Gets a node that contributes to the data-part this request.
   */
  DataFlow::Node getADataNode() { result = super.getADataNode() }

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
    result = super.getAResponseDataNode(responseType, promise)
  }

  /**
   * Gets a node that refers to data from the response, possibly
   * wrapped in a promise object.
   */
  DataFlow::Node getAResponseDataNode() { result = this.getAResponseDataNode(_, _) }

  /**
   * Gets a data-flow node that determines where in the file-system the result of the request should be saved.
   */
  DataFlow::Node getASavePath() { result = super.getASavePath() }
}

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
      result = this.getArgument(0) or
      result = this.getOptionArgument(0, urlPropertyName())
    }

    override DataFlow::Node getHost() { none() }

    /** Gets the response type from the options passed in. */
    string getResponseType() {
      if this.getOptionArgument(1, "json").mayHaveBooleanValue(true)
      then result = "json"
      else result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean pr) {
      responseType = this.getResponseType() and
      promise = true and
      pr = true and
      result = this
      or
      responseType = this.getResponseType() and
      promise = false and
      pr = false and
      (
        result = this.getCallback([1 .. 2]).getParameter(2)
        or
        result = this.getCallback([1 .. 2]).getParameter(1).getAPropertyRead("body")
      )
      or
      responseType = "error" and
      promise = false and
      pr = false and
      result = this.getCallback([1 .. 2]).getParameter(0)
    }

    override DataFlow::Node getADataNode() { result = this.getArgument(1) }

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
  class AxiosUrlRequest extends ClientRequest::Range, API::CallNode {
    string method;

    AxiosUrlRequest() {
      this = API::moduleImport("axios").getACall() and method = "request"
      or
      this = API::moduleImport("axios").getMember(method).getACall() and
      method = [httpMethodName(), "request"]
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
      result = this.getOptionArgument(this.getOptionsArgIndex(), name)
    }

    override DataFlow::Node getUrl() {
      result = this.getArgument(0) or
      result = this.getOptionArgument(urlPropertyName())
    }

    override DataFlow::Node getHost() { result = this.getOptionArgument("host") }

    override DataFlow::Node getADataNode() {
      method = "request" and
      result = this.getOptionArgument(0, "data")
      or
      method = ["post", "put"] and
      result = [this.getArgument(1), this.getOptionArgument(2, "data")]
      or
      result = this.getOptionArgument([0 .. 2], ["headers", "params"])
    }

    /** Gets the response type from the options passed in. */
    string getResponseType() {
      exists(DataFlow::Node option | option = this.getOptionArgument("responseType") |
        option.mayHaveStringValue(result)
        or
        option.analyze().getAValue().isIndefinite(_) and
        result = ""
      )
      or
      not exists(this.getOptionArgument("responseType")) and
      result = "json"
      or
      this.getArgument(this.getOptionsArgIndex()).analyze().getAValue().isIndefinite(_) and
      result = ""
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = this.getResponseType() and
      promise = true and
      result = this
      or
      responseType = this.getResponseType() and
      promise = false and
      result = this.getReturn().getPromisedError().getMember("response").getAnImmediateUse()
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
        fetch = DataFlow::moduleMember("whatwg-fetch", "fetch")
        or
        fetch = DataFlow::globalVarRef("fetch") // https://fetch.spec.whatwg.org/#fetch-api
      |
        this = fetch.getACall() and
        url = this.getArgument(0)
      )
    }

    override DataFlow::Node getUrl() { result = url }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "headers" or name = "body" |
        result = this.getOptionArgument(1, name)
      )
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "fetch.response" and
      promise = true and
      result = this
    }
  }

  /**
   * Classes for modeling the url request library `needle`.
   */
  private module Needle {
    /**
     * A model of a URL request made using `require("needle")(...)`.
     */
    class PromisedNeedleRequest extends ClientRequest::Range {
      DataFlow::Node url;

      PromisedNeedleRequest() { this = DataFlow::moduleImport("needle").getACall() }

      override DataFlow::Node getUrl() { result = this.getArgument(1) }

      override DataFlow::Node getHost() { none() }

      override DataFlow::Node getADataNode() {
        result = this.getOptionArgument([2, 3], "headers")
        or
        result = this.getArgument(2)
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

      override DataFlow::Node getUrl() { result = this.getArgument(0) }

      override DataFlow::Node getHost() { none() }

      override DataFlow::Node getADataNode() {
        hasData = true and
        (
          result = this.getArgument(1)
          or
          result = this.getOptionArgument(2, "headers")
        )
        or
        hasData = false and
        result = this.getOptionArgument(1, "headers")
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
      exists(API::Node callee, API::Node got | this = callee.getACall() |
        got = [API::moduleImport("got"), API::moduleImport("got").getMember("extend").getReturn()] and
        callee = [got, got.getMember(["stream", "get", "post", "put", "patch", "head", "delete"])]
      )
    }

    override DataFlow::Node getUrl() {
      result = this.getArgument(0) and
      not exists(this.getOptionArgument(1, "baseUrl"))
    }

    override DataFlow::Node getHost() {
      exists(string name |
        name = "host" or
        name = "hostname"
      |
        result = this.getOptionArgument(1, name)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(string name | name = "headers" or name = "body" or name = "query" |
        result = this.getOptionArgument(1, name)
      )
    }

    /** Holds if the result is a stream. */
    predicate isStream() {
      this.getOptionArgument(1, "stream").mayHaveBooleanValue(true)
      or
      this = DataFlow::moduleMember("got", "stream").getACall()
    }

    /** Holds if the result is a JSON object. */
    predicate isJson() { this.getOptionArgument(1, "json").mayHaveBooleanValue(true) }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      result = this and
      if this.isStream()
      then
        responseType = "stream" and
        promise = false
      else
        if this.isJson()
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
   * Gets an instantiation `socket` of `require("net").Socket`.
   */
  private API::Node netSocketInstantiation(DataFlow::NewNode socket) {
    result = API::moduleImport("net").getMember("Socket").getInstance() and
    socket = result.getAnImmediateUse()
  }

  /**
   * A model of a request made using `(new require("net").Socket()).connect(args);`.
   */
  class NetSocketRequest extends ClientRequest::Range {
    DataFlow::NewNode socket;

    NetSocketRequest() { this = netSocketInstantiation(socket).getMember("connect").getACall() }

    override DataFlow::Node getUrl() {
      result = this.getArgument([0, 1]) // there are multiple overrides of `connect`, and the URL can be in the first or second argument.
    }

    override DataFlow::Node getHost() { result = this.getOptionArgument(0, "host") }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = "text" and
      promise = false and
      exists(DataFlow::CallNode call |
        call = netSocketInstantiation(socket).getMember("on").getACall() and
        call.getArgument(0).mayHaveStringValue("data") and
        result = call.getABoundCallbackParameter(1, 0)
      )
    }

    override DataFlow::Node getADataNode() {
      exists(DataFlow::CallNode call |
        call = netSocketInstantiation(socket).getMember("write").getACall() and
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
        url = this.getArgument(0)
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
        callback = this.getAChainedMethodCall("end").getCallback(0) and
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
  class XmlHttpRequest extends ClientRequest::Range {
    XmlHttpRequest() {
      this = DataFlow::globalVarRef("XMLHttpRequest").getAnInstantiation()
      or
      // closure shim for XMLHttpRequest
      this = Closure::moduleImport("goog.net.XmlHttp").getAnInvocation()
    }

    override DataFlow::Node getUrl() { result = this.getAMethodCall("open").getArgument(1) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = this.getAMethodCall("send").getArgument(0) }

    private string getExplicitResponseType() {
      this.getAPropertyWrite("responseType").getRhs().mayHaveStringValue(result)
    }

    /**
     * Gets the response type corresponding to the `response` property,
     * but not the explicitly typed properties, `reponseText` and `responseXML`.
     */
    string getAssignedResponseType() {
      result = this.getExplicitResponseType()
      or
      not exists(this.getExplicitResponseType()) and
      result = "text"
    }

    /** Gets an event listener registered on this XHR object. */
    DataFlow::FunctionNode getAnEventListener() {
      result = this.getAPropertyWrite("on" + any(string s)).getRhs().getAFunctionValue()
      or
      result = this.getAMethodCall("addEventListener").getArgument(1).getAFunctionValue()
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
      result = this.getAnEventListener().getReceiver()
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      promise = false and
      (
        exists(string prop | result = this.getAnAlias().getAPropertyRead(prop) |
          prop = "response" and responseType = this.getAssignedResponseType()
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
        exists(string method | result = this.getAnAlias().getAMethodCall(method) |
          method = "getAllResponseHeaders" and responseType = "headers"
          or
          method = "getResponseHeader" and responseType = "header"
        )
      )
    }
  }

  /** DEPRECATED: Alias for XmlHttpRequest */
  deprecated class XMLHttpRequest = XmlHttpRequest;

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

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { result = this.getArgument([2 .. 3]) }

    /** Gets an event listener with `this` bound to this object. */
    DataFlow::FunctionNode getAnEventListener() {
      static = true and
      result = this.getAnArgument().getAFunctionValue()
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
      result = this.getAnEventListener().getReceiver()
    }

    /**
     * Gets the response type corresponding to `getReponse()` but not
     * for explicitly typed calls like `getResponseJson()`.
     */
    string getAssignedResponseType() {
      this.getAMethodCall("setResponseType").getArgument(0).mayHaveStringValue(result)
      or
      not exists(this.getAMethodCall("setResponseType")) and
      result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      promise = false and
      exists(string method | result = this.getAnAlias().getAMethodCall(method) |
        method = "getResponse" and responseType = this.getAssignedResponseType()
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
   */
  private API::Node chromeRemoteInterface() {
    exists(API::CallNode call | call = API::moduleImport("chrome-remote-interface").getACall() |
      // the client is inside in a promise.
      result = call.getReturn().getPromised()
      or
      // the client is accessed directly using a callback.
      result = call.getParameter([0 .. 1]).getParameter(0)
    )
  }

  /**
   * A call to navigate a browser controlled by `chrome-remote-interface` to a specific URL.
   */
  class ChromeRemoteInterfaceRequest extends ClientRequest::Range, DataFlow::CallNode {
    int optionsArg;

    ChromeRemoteInterfaceRequest() {
      exists(API::Node instance | instance = chromeRemoteInterface() |
        optionsArg = 0 and
        this = instance.getMember("Page").getMember("navigate").getACall()
        or
        optionsArg = 1 and
        this = instance.getMember("send").getACall() and
        this.getArgument(0).mayHaveStringValue("Page.navigate")
      )
    }

    override DataFlow::Node getUrl() {
      result = this.getArgument(optionsArg).getALocalSource().getAPropertyWrite("url").getRhs()
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * A call to `nugget` that downloads one of more files to a destination determined by an options object given as the second argument.
   */
  class Nugget extends ClientRequest::Range, DataFlow::CallNode {
    Nugget() { this = DataFlow::moduleImport("nugget").getACall() }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

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
        cmd.getACommandArgument()
            .(StringOps::ConcatenationRoot)
            .getConstantStringParts()
            .matches("curl %")
      )
    }

    override DataFlow::Node getUrl() {
      result = cmd.getArgumentList().getALocalSource().getAPropertyWrite().getRhs() or
      result = cmd.getACommandArgument().(StringOps::ConcatenationRoot).getALeaf()
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * A model of a URL request made using `jsdom.fromUrl()`.
   */
  class JSDomFromUrl extends ClientRequest::Range {
    JSDomFromUrl() {
      this = API::moduleImport("jsdom").getMember("JSDOM").getMember("fromURL").getACall()
    }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }

  /** DEPRECATED: Alias for JSDomFromUrl */
  deprecated class JSDOMFromUrl = JSDomFromUrl;

  /**
   * Classes and predicates modeling the `apollo-client` library.
   */
  private module ApolloClient {
    /**
     * Gets a function from `apollo-client` that accepts an options object that may contain a `uri` property.
     */
    API::Node apolloUriCallee() {
      result = API::moduleImport("apollo-link-http").getMember(["HttpLink", "createHttpLink"])
      or
      result =
        API::moduleImport(["apollo-boost", "apollo-client", "apollo-client-preset"])
            .getMember(["ApolloClient", "HttpLink", "createNetworkInterface"])
      or
      result = API::moduleImport("apollo-link-ws").getMember("WebSocketLink")
    }

    /**
     * A model of a URL request made using apollo-client.
     */
    class ApolloClientRequest extends ClientRequest::Range, API::InvokeNode {
      ApolloClientRequest() { this = apolloUriCallee().getAnInvocation() }

      override DataFlow::Node getUrl() { result = this.getParameter(0).getMember("uri").getARhs() }

      override DataFlow::Node getHost() { none() }

      override DataFlow::Node getADataNode() { none() }
    }
  }

  /**
   * A model of a URL request made using [form-data](https://www.npmjs.com/package/form-data).
   */
  class FormDataRequest extends ClientRequest::Range, API::InvokeNode {
    API::Node form;

    FormDataRequest() {
      form = API::moduleImport("form-data").getInstance() and
      this = form.getMember("submit").getACall()
    }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override DataFlow::Node getHost() { result = this.getParameter(0).getMember("host").getARhs() }

    override DataFlow::Node getADataNode() {
      result = form.getMember("append").getACall().getParameter(1).getARhs()
    }
  }
}
