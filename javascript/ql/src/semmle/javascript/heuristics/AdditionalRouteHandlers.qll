/**
 * Provides classes that heuristically increase the extent of `https::RouteHandler`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript
private import semmle.javascript.frameworks.ConnectExpressShared

/**
 * Add `NodeJSLib::RouteHandlerCandidate` to the extent of `NodeJSLib::RouteHandler`.
 */
private class PromotedNodeJSLibCandidate extends NodeJSLib::RouteHandler,
  https::Servers::StandardRouteHandler {
  PromotedNodeJSLibCandidate() { this instanceof NodeJSLib::RouteHandlerCandidate }
}

/**
 * Add `Hapi::RouteHandlerCandidate` to the extent of `Hapi::RouteHandler`.
 */
private class PromotedHapiCandidate extends Hapi::RouteHandler, https::Servers::StandardRouteHandler {
  PromotedHapiCandidate() { this instanceof Hapi::RouteHandlerCandidate }
}

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Express::RouteHandler`.
 */
private class PromotedExpressCandidate extends Express::RouteHandler,
  https::Servers::StandardRouteHandler {
  PromotedExpressCandidate() { this instanceof ConnectExpressShared::RouteHandlerCandidate }

  override Parameter getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(getAstNode(), kind)
  }
}

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Connect::RouteHandler`.
 */
private class PromotedConnectCandidate extends Connect::RouteHandler,
  https::Servers::StandardRouteHandler {
  PromotedConnectCandidate() { this instanceof ConnectExpressShared::RouteHandlerCandidate }

  override Parameter getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(getAstNode(), kind)
  }
}
