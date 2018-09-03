/**
 * Provides classes for modelling URL requests.
 *
 * Subclass `UrlRequest` to refine the behavior of the analysis on existing URL requests.
 * Subclass `CustomUrlRequest` to introduce new kinds of URL requests.
 */

import javascript

/**
 * A call that performs a request to a URL.
 */
class CustomUrlRequest extends DataFlow::CallNode {

  /**
   * Gets the URL of the request.
   */
  abstract DataFlow::Node getUrl();
}

/**
 * A call that performs a request to a URL.
 */
class UrlRequest extends DataFlow::CallNode {

  CustomUrlRequest custom;

  UrlRequest() {
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
 * A model of a URL request in the `request` library.
 */
private class RequestUrlRequest extends CustomUrlRequest {

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
 * A model of a URL request in the `axios` library.
 */
private class AxiosUrlRequest extends CustomUrlRequest {

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
        url = getOptionArgument([0..2], urlPropertyName()) // slightly over-approximate, in the name of simplicity
      )
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}

/**
 * A model of a URL request in an implementation of the `fetch` API.
 */
private class FetchUrlRequest extends CustomUrlRequest {

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
 * A model of a URL request in the Node.js `http` library.
 */
private class NodeHttpUrlRequest extends CustomUrlRequest {

  DataFlow::Node url;

  NodeHttpUrlRequest() {
    exists (string moduleName, DataFlow::SourceNode callee |
      this = callee.getACall() |
      (moduleName = "http" or moduleName = "https") and
      (
        callee = DataFlow::moduleMember(moduleName, httpMethodName())
        or
        callee = DataFlow::moduleMember(moduleName, "request") 
      ) and
      url = getArgument(0)
    )
  }

  override DataFlow::Node getUrl() {
    result = url
  }

}


/**
 * A model of a URL request in the `got` library.
 */
private class GotUrlRequest extends CustomUrlRequest {

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
 * A model of a URL request in the `superagent` library.
 */
private class SuperAgentUrlRequest extends CustomUrlRequest {

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
