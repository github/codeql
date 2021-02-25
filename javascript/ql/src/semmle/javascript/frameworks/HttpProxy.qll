/**
 * Provides classes and predicates for working with the [http-proxy](https://www.npmjs.com/package/http-proxy) library.
 */

import javascript

/**
 * Provides classes and predicates modelling the [http-proxy](https://www.npmjs.com/package/http-proxy) library.
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

    override DataFlow::Node getUrl() { result = getParameter(0).getMember("target").getARhs() }

    override DataFlow::Node getHost() { none() }

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

    override DataFlow::Node getUrl() {
      exists(int optionsIndex |
        method = "web" and optionsIndex = 2
        or
        method = "ws" and optionsIndex = 3
      |
        result = getParameter(optionsIndex).getMember("target").getARhs()
      )
    }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }
}
