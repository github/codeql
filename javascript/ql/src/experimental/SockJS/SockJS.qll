/**
 * Provides classes for working with [SockJS](http://sockjs.org).
 */

import javascript
import DataFlow::PathGraph

/**
 * A model of the `SockJS` websocket data handler (https://sockjs.org).
 */
module SockJS {
  class SourceFromSocketJS extends RemoteFlowSource {
    /**
     * Access to user-controlled data object received from websocket
     * For example:
     * ```
     * server.on('connection', function(conn) {
     *     conn.on('data', function(message) {
     *       ...
     *     });
     *  });
     * ```
     */
    SourceFromSocketJS() {
      exists(
        DataFlow::CallNode createServer, DataFlow::CallNode connNode,
        DataFlow::CallNode dataHandlerNode
      |
        createServer = appCreation() and
        connNode = createServer.getAMethodCall("on") and
        connNode.getArgument(0).getStringValue() = "connection" and
        dataHandlerNode = connNode.getCallback(1).getParameter(0).getAMethodCall("on") and
        dataHandlerNode.getArgument(0).getStringValue() = "data" and
        this = dataHandlerNode.getCallback(1).getParameter(0)
      )
    }

    override string getSourceType() { result = "input from SockJS WebSocket" }
  }

  /**
   * Gets a new SockJS server.
   */
  private DataFlow::CallNode appCreation() {
    result = DataFlow::moduleImport("sockjs").getAMemberCall("createServer")
  }
}
