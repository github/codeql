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
  }
}

deprecated class CustomClientRequest = ClientRequest::Range;

/**
 * Gets name of an HTTP request method, in all-lowercase.
 */
private string httpMethodName() { result = any(HTTP::RequestMethodName m).toLowerCase() }

/**
 * Gets the name of a property that likely contains a URL value.
 */
private string urlPropertyName() {
  result = "uri" or
  result = "url"
}

/**
 * A model of a URL request made using the `request` library.
 */
private class RequestUrlRequest extends ClientRequest::Range {
  RequestUrlRequest() {
    exists(string moduleName, DataFlow::SourceNode callee | this = callee.getACall() |
      (
        moduleName = "request" or
        moduleName = "request-promise" or
        moduleName = "request-promise-any" or
        moduleName = "request-promise-native"
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

  override DataFlow::Node getADataNode() { result = getArgument(1) }
}

/**
 * A model of a URL request made using the `axios` library.
 */
private class AxiosUrlRequest extends ClientRequest::Range {
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
}

/**
 * A model of a URL request made using an implementation of the `fetch` API.
 */
private class FetchUrlRequest extends ClientRequest::Range {
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
}

/**
 * A model of a URL request made using the `got` library.
 */
private class GotUrlRequest extends ClientRequest::Range {
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
}

/**
 * A model of a URL request made using the `superagent` library.
 */
private class SuperAgentUrlRequest extends ClientRequest::Range {
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
}

/**
 * A model of a URL request made using the `XMLHttpRequest` browser class.
 */
private class XMLHttpRequest extends ClientRequest::Range {
  XMLHttpRequest() {
    this = DataFlow::globalVarRef("XMLHttpRequest").getAnInstantiation()
    or
    // closure shim for XMLHttpRequest
    this = Closure::moduleImport("goog.net.XmlHttp").getAnInstantiation()
  }

  override DataFlow::Node getUrl() { result = getAMethodCall("open").getArgument(1) }

  override DataFlow::Node getHost() { none() }

  override DataFlow::Node getADataNode() { result = getAMethodCall("send").getArgument(0) }
}

/**
 * A model of a URL request made using the `XhrIo` class from the closure library.
 */
private class ClosureXhrIoRequest extends ClientRequest::Range {
  ClosureXhrIoRequest() {
    exists(DataFlow::SourceNode xhrIo | xhrIo = Closure::moduleImport("goog.net.XhrIo") |
      this = xhrIo.getAMethodCall("send")
      or
      this = xhrIo.getAnInstantiation().getAMethodCall("send")
    )
  }

  override DataFlow::Node getUrl() { result = getArgument(0) }

  override DataFlow::Node getHost() { none() }

  override DataFlow::Node getADataNode() {
    result = getArgument(2) or
    result = getArgument(3)
  }
}
