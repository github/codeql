/**
 * Provides a class for modelling sources of remote user input.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.dataflow.DOM

/** A data flow source of remote user input. */
abstract class RemoteFlowSource extends DataFlow::Node {
  /** Gets a string that describes the type of this remote flow source. */
  abstract string getSourceType();

  /**
   * Holds if this flow source comes from an incoming request, and this part of the
   * request can be controlled by a third party, that is, an actor other than the one
   * sending the request.
   *
   * Any web site can redirect the visitor's browser to any other domain, and in doing so control
   * the entire URL and POST body. In this scenario, these values are technically sent by the
   * user's browser, but the user is not in direct control of these values, so they are considered
   * third-party controllable.
   */
  predicate isThirdPartyControllable() { none() }
}

/**
 * An access to `document.cookie`, viewed as a source of remote user input.
 */
private class DocumentCookieSource extends RemoteFlowSource, DataFlow::ValueNode {
  DocumentCookieSource() {
    isDocument(astNode.(PropAccess).getBase()) and
    astNode.(PropAccess).getPropertyName() = "cookie"
  }

  override string getSourceType() {
    result = "document.cookie"
  }
}
