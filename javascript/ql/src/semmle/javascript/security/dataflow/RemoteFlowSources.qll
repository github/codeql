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
  
/** A source of content download via NodeJS require.get(), considered as a flow source for code injection. */
private class NodeJSRequireSource extends RemoteFlowSource {
  NodeJSRequireSource() { 
    this.asExpr() = getRequireHttpGetCallbackArg ()
  }
 
  override string getSourceType() {
    result = "require(\"http(s)\").get(\"callback\")"
  }
}