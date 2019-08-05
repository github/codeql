/**
 * Provides classes for modelling the client-side of a URL request.
 *
 * Subclass `ClientRequest` to refine the behavior of the analysis on existing client requests.
 * Subclass `CustomClientRequest` to introduce new kinds of client requests.
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
    * (after resolving promises).
    *
    * The response type may be any of the values supported by
    * [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/responseType),
    * namely `arraybuffer`, `blob`, `document`, `json`, or `text`.
    *
    * Additionally, the `responseType` may have one of the following values:
    * - `fetch.response`: The result is a `Response` object as defined by the [fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Response).
    * - `stream`: The result is a Node.js stream
    * - `error`: The result is an error in an unspecified format, possibly containing information from the response
    *
    *
    * Custom implementations of `ClientRequest` may use other formats.
    * If the responseType is not known the convention is to use an empty string.
    */
  DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
    result = self.getAResponseDataNode(responseType, promise)
  }

  /**
   * Gets a node that refers to data from the response, possibly
   * wrapped in a promise object.
   */
  DataFlow::Node getAResponseDataNode() { result = getAResponseDataNode(_, _) }
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
     * See the decription of `responseType` in the corresponding predicate in `ClientRequest`.
     */
    DataFlow::Node getAResponseDataNode(string responseType, boolean promise) { none() }
  }

  /**
  * Gets name of an HTTP request method, in all-lowercase.
  */
  private string httpMethodName() { result = any(HTTP::RequestMethodName m).toLowerCase() }

  /**
  * A model of a URL request made using the `request` library.
  */
  class RequestUrlRequest extends ClientRequest::Range, DataFlow::CallNode {
    boolean promise;

    RequestUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        (
          promise = false and
          moduleName = "request"
          or
          promise = true and
          (
            moduleName = "request-promise" or
            moduleName = "request-promise-any" or
            moduleName = "request-promise-native"
          )
        ) and
        (
          callee = DataFlow::moduleImport(moduleName) or
          callee = DataFlow::moduleMember(moduleName, httpMethodName())
        )
      )
    }

    override DataFlow::Node getUrl() {
      result = getArgument(0) or
      result = getOptionArgument(0, urlPropertyName())
    }

    override DataFlow::Node getHost() { none() }

    string getResponseFormat() {
      if getOptionArgument(1, "json").mayHaveBooleanValue(true) then
        result = "json"
      else
        result = "text"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean pr) {
      responseType = getResponseFormat() and
      promise = true and
      pr = true and
      result = this
      or
      responseType = getResponseFormat() and
      promise = false and
      pr = false and
      (
        result = getCallback([1..2]).getParameter(2)
        or
        result = getCallback([1..2]).getParameter(1).getAPropertyRead("body")
      )
      or
      responseType = "error" and
      promise = false and
      pr = false and
      result = getCallback([1..2]).getParameter(0)
    }

    override DataFlow::Node getADataNode() { result = getArgument(1) }
  }

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

    private DataFlow::Node getOptionArgument(string name) {
      // depends on the method name and the call arity, over-approximating slightly in the name of simplicity
      result = getOptionArgument([0 .. 2], name)
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

    string getResponseFormat() {
      exists(DataFlow::Node option | option = getOptionArgument([0 .. 2], "responseType") |
        result = option.getStringValue()
        or
        not exists(option.getStringValue()) and
        result = ""
      )
      or
      not exists(getOptionArgument([0 .. 2], "responseType")) and
      result = "json"
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      responseType = getResponseFormat() and
      promise = true and
      result = this
    }
  }

  /**
  * A model of a URL request made using an implementation of the `fetch` API.
  */
  class FetchUrlRequest extends ClientRequest::Range {
    DataFlow::Node url;

    FetchUrlRequest() {
      exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
        (
          moduleName = "node-fetch" or
          moduleName = "cross-fetch" or
          moduleName = "isomorphic-fetch"
        ) and
        callee = DataFlow::moduleImport(moduleName) and
        url = getArgument(0)
      )
      or
      this = DataFlow::globalVarRef("fetch").getACall() and
      url = getArgument(0)
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

    predicate isStream() {
      getOptionArgument(1, "stream").mayHaveBooleanValue(true)
      or
      this = DataFlow::moduleMember("got", "stream").getACall()
    }

    predicate isJson() {
      getOptionArgument(1, "json").mayHaveBooleanValue(true)
    }

    override DataFlow::Node getAResponseDataNode(string responseType, boolean promise) {
      result = this and
      (
        isStream() and
        responseType = "stream" and
        promise = false
        or
        isJson() and
        responseType = "json" and
        promise = true
        or
        not isStream() and
        not isJson() and
        responseType = "text" and
        promise = true
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

    private string getAssignedResponseType() {
      result = getExplicitResponseType()
      or
      not exists(getExplicitResponseType()) and
      result = "text"
    }

    DataFlow::FunctionNode getAnEventListener() {
      result = getAPropertyWrite("on" + any(string s)).getRhs().getAFunctionValue()
      or
      result = getAMethodCall("addEventListener").getArgument(1).getAFunctionValue()
    }

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
          prop = "statusText" and responseType = "text"
          or
          prop = "responseXML" and responseType = "document"
        )
        or
        responseType = "text" and
        exists(string method | result = getAnAlias().getAMethodCall(method) |
          method = "getAllResponseHeaders" or
          method = "getResponseHeader"
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
      exists (DataFlow::SourceNode xhrIo | xhrIo = Closure::moduleImport("goog.net.XhrIo") |
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

    override DataFlow::Node getADataNode() {
      result = getArgument(2) or
      result = getArgument(3)
    }

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

    DataFlow::SourceNode getAnAlias() {
      static = false and
      result = base
      or
      result = getAnEventListener().getReceiver()
    }

    private string getAssignedResponseType() {
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
        method = "getResponseHeader" and responseType = "text"
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

}
