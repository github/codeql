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
 *       external/cwe/cwe-020
 */

import javascript
import semmle.javascript.security.dataflow.DOM

/**
 * A method call for the insecure functions used to verify the `MessageEvent.origin`.
 */
class InsufficientOriginChecks extends DataFlow::Node {
  InsufficientOriginChecks() {
    exists(DataFlow::Node node |
      this.(StringOps::StartsWith).getSubstring() = node or
      this.(StringOps::Includes).getSubstring() = node or
      this.(StringOps::EndsWith).getSubstring() = node
    )
  }
}

/**
 * A function handler for the `MessageEvent`.
 */
class PostMessageHandler extends DataFlow::FunctionNode {
  PostMessageHandler() { this.getFunction() instanceof PostMessageEventHandler }
}

/**
 * The `MessageEvent` parameter received by the handler
 */
class PostMessageEvent extends DataFlow::SourceNode {
  PostMessageEvent() { exists(PostMessageHandler handler | this = handler.getParameter(0)) }

  /**
   * Holds if an access on `MessageEvent.origin` is in an `EqualityTest` and there is no call of an insufficient verification method on `MessageEvent.origin`
   */
  predicate hasOriginChecked() {
    exists(EqualityTest test |
      this.getAPropertyRead(["origin", "source"]).flowsToExpr(test.getAnOperand())
    )
  }

  /**
   * Holds if there is an insufficient method call (i.e indexOf) used to verify `MessageEvent.origin`
   */
  predicate hasOriginInsufficientlyChecked() {
    exists(InsufficientOriginChecks insufficientChecks |
      this.getAPropertyRead("origin").getAMethodCall*() = insufficientChecks
    )
  }
}

from PostMessageEvent event
where not event.hasOriginChecked() or event.hasOriginInsufficientlyChecked()
select event, "Missing or unsafe origin verification."
