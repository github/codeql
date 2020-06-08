/**
 * @name Missing `MessageEvent.origin` verification in `postMessage` handlers
 * @description Missing the `MessageEvent.origin` verification in `postMessage` handlers, allows any windows to send arbitrary data to the `MessageEvent` listener.
 * This could lead to unexpected behaviour, especially when `MessageEvent.data` is used in an unsafe way.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/missing-postmessageorigin-verification
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript

/**
 * A call to a `window` event listener
 */
class WindowListeners extends DataFlow::CallNode {
  WindowListeners() {
    exists(DataFlow::SourceNode source |
      source = DataFlow::globalVarRef("window") and
      this = source.getAMethodCall("addEventListener")
    )
  }
}

/**
 * A call to a `window` event listener for the `MessageEvent`
 */
class PostMessageListeners extends DataFlow::CallNode {
  PostMessageListeners() {
    exists(WindowListeners listener |
      listener.getArgument(0).mayHaveStringValue("message") and
      this = listener
    )
  }
}

/**
 * A function handler for the `MessageEvent`. It is the second argument of a `MessageEvent` listener
 */
class PostMessageHandler extends DataFlow::FunctionNode {
  PostMessageHandler() {
    exists(PostMessageListeners listener | this = listener.getArgument(1).getAFunctionValue())
  }
}

/**
 * The `MessageEvent` received by the handler
 */
class PostMessageEvent extends DataFlow::SourceNode {
  PostMessageEvent() { exists(PostMessageHandler handler | this = handler.getParameter(0)) }

  /**
   * Holds if a call to a method on `MessageEvent.origin` or a read of `MessageEvent.origin` is in an `if` statement
   */
  predicate isOriginChecked() {
    exists(IfStmt ifStmt |
      ifStmt = this.getAPropertyRead("origin").getAMethodCall*().asExpr().getEnclosingStmt() or
      ifStmt = this.getAPropertyRead("origin").asExpr().getEnclosingStmt()
    )
  }
}

from PostMessageEvent event, PostMessageHandler handler
where
  event = handler.getParameter(0) and
  not event.isOriginChecked()
select "The `MessageEvent.origin` property is not checked.", event, handler
