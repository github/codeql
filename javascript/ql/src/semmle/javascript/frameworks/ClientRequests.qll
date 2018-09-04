/**
 * Provides classes for modelling the client-side of a URL request.
 *
 * Subclass `ClientRequest` to refine the behavior of the analysis on existing client requests.
 * Subclass `CustomClientRequest` to introduce new kinds of client requests.
 */

import javascript

/**
 * A call that performs a request to a URL.
 */
abstract class CustomClientRequest extends DataFlow::InvokeNode {

  /**
   * Gets the URL of the request.
   */
  abstract DataFlow::Node getUrl();
}

/**
 * A call that performs a request to a URL.
 */
class ClientRequest extends DataFlow::InvokeNode {

  CustomClientRequest custom;

  ClientRequest() {
    this = custom
  }

  /**
   * Gets the URL of the request.
   */
  DataFlow::Node getUrl() {
    result = custom.getUrl()
  }
}

/**
 * Gets name of an HTTP request method, in all-lowercase.
 */
private string httpMethodName() {
  result = any(HTTP::RequestMethodName m).toLowerCase()
}

/**
 * Gets the name of a property that likely contains a  URL value.
 */
private string urlPropertyName() {
  result = "uri" or
  result = "url"
}

/**
 * A model of a URL request made using the `request` library.
 */
private class RequestUrlRequest extends CustomClientRequest {

  DataFlow::Node url;

  RequestUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      (
        moduleName = "request" or
        moduleName = "request-promise" or
        moduleName = "request-promise-any" or
        moduleName = "request-promise-native"
      ) and
      (
        callee = DataFlow::moduleImport(moduleName) or
        callee = DataFlow::moduleMember(moduleName, httpMethodName())
      ) and
      (
        url = getArgument(0) or
        url = getOptionArgument(0, urlPropertyName())
      )
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}

/**
 * A model of a URL request made using the `axios` library.
 */
private class AxiosUrlRequest extends CustomClientRequest {

  DataFlow::Node url;

  AxiosUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      moduleName = "axios" and
      (
        callee = DataFlow::moduleImport(moduleName) or
        callee = DataFlow::moduleMember(moduleName, httpMethodName()) or
        callee = DataFlow::moduleMember(moduleName, "request")
      ) and
      (
        url = getArgument(0) or
        // depends on the method name and the call arity, over-approximating slightly in the name of simplicity
        url = getOptionArgument([0..2], urlPropertyName())
      )
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}

/**
 * A model of a URL request made using an implementation of the `fetch` API.
 */
private class FetchUrlRequest extends CustomClientRequest {

  DataFlow::Node url;

  FetchUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      (
        moduleName = "node-fetch" or
        moduleName = "cross-fetch" or
        moduleName = "isomorphic-fetch"
      ) and
      callee = DataFlow::moduleImport(moduleName) and
      url = getArgument(0)
    )
    or
    (
      this = DataFlow::globalVarRef("fetch").getACall() and
      url = getArgument(0)
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}

/**
 * A model of a URL request made using the `got` library.
 */
private class GotUrlRequest extends CustomClientRequest {

  DataFlow::Node url;

  GotUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      moduleName = "got" and
      (
        callee = DataFlow::moduleImport(moduleName) or
        callee = DataFlow::moduleMember(moduleName, "stream")
      ) and
      url = getArgument(0) and not exists (getOptionArgument(1, "baseUrl"))
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}

/**
 * A model of a URL request made using the `superagent` library.
 */
private class SuperAgentUrlRequest extends CustomClientRequest {

  DataFlow::Node url;

  SuperAgentUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      moduleName = "superagent" and
      callee = DataFlow::moduleMember(moduleName, httpMethodName()) and
      url = getArgument(0)
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}
