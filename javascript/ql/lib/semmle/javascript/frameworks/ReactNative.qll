/**
 * Provides classes for working with [React Native](https://facebook.github.io/react-native) code.
 */
overlay[local?]
module;

import javascript

module ReactNative {
  /** A `WebView` JSX element. */
  class WebViewElement extends DataFlow::ValueNode, DataFlow::SourceNode {
    override JsxElement astNode;

    WebViewElement() {
      DataFlow::moduleMember("react-native", "WebView").flowsToExpr(astNode.getNameExpr())
    }
  }
}
