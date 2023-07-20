/**
 * Provides classes and predicates for working with the [http-proxy](https://www.npmjs.com/package/http-proxy) library.
 */

import javascript

/**
 * Provides classes and predicates modeling the [http-proxy](https://www.npmjs.com/package/http-proxy) library.
 */
private module HttpProxy {
  /**
   * A call that creates a http proxy.
   */
  class CreateServerCall extends API::CallNode, ClientRequest::Range {
    CreateServerCall() {
      this =
        API::moduleImport("http-proxy")
            .getMember(["createServer", "createProxyServer", "createProxy"])
            .getACall()
    }

    override DataFlow::Node getUrl() { result = this.getParameter(0).getMember("target").asSink() }

    override DataFlow::Node getHost() {
      result = this.getParameter(0).getMember("target").getMember("host").asSink()
    }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * A call that proxies a request to some target.
   */
  class ProxyCall extends API::CallNode, ClientRequest::Range {
    string method;

    ProxyCall() {
      method = ["ws", "web"] and
      this = any(CreateServerCall server).getReturn().getMember(method).getACall()
    }

    private API::Node getOptionsObject() {
      exists(int optionsIndex |
        method = "web" and optionsIndex = 2
        or
        method = "ws" and optionsIndex = 3
      |
        result = this.getParameter(optionsIndex)
      )
    }

    override DataFlow::Node getUrl() {
      result = this.getOptionsObject().getMember("target").asSink()
    }

    override DataFlow::Node getHost() {
      result = this.getOptionsObject().getMember("target").getMember("host").asSink()
    }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * Holds if an event handler for `event` has a HTTP request parameter at `req` and a HTTP response parameter at `res`.
   */
  predicate routeHandlingEventHandler(string event, int req, int res) {
    event = ["start", "end"] and req = 0 and res = 1
    or
    event = ["proxyReq", "proxyRes", "econnreset"] and req = 1 and res = 2
    or
    event = "proxyReqWs" and req = 1 and res = -10 // -10 for non-existent.
  }

  /**
   * An http proxy event handler.
   */
  class ProxyListenerCallback extends NodeJSLib::RouteHandler, DataFlow::FunctionNode {
    string event;

    ProxyListenerCallback() {
      exists(API::CallNode call |
        call = any(CreateServerCall server).getReturn().getMember(["on", "once"]).getACall() and
        call.getParameter(0).asSink().mayHaveStringValue(event) and
        this = call.getParameter(1).asSink().getAFunctionValue()
      )
    }

    override DataFlow::ParameterNode getRequestParameter() {
      exists(int req | routeHandlingEventHandler(event, req, _) | result = this.getParameter(req))
    }

    override DataFlow::ParameterNode getResponseParameter() {
      exists(int res | routeHandlingEventHandler(event, _, res) | result = this.getParameter(res))
    }
  }
}
