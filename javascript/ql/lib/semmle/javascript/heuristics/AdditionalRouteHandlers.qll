/**
 * Provides classes that heuristically increase the extent of `HTTP::RouteHandler`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript
private import semmle.javascript.frameworks.ConnectExpressShared

/**
 * Add `NodeJSLib::RouteHandlerCandidate` to the extent of `NodeJSLib::RouteHandler`.
 */
private class PromotedNodeJSLibCandidate extends NodeJSLib::RouteHandler,
  Http::Servers::StandardRouteHandler {
  PromotedNodeJSLibCandidate() { this instanceof NodeJSLib::RouteHandlerCandidate }
}

/**
 * Add `Hapi::RouteHandlerCandidate` to the extent of `Hapi::RouteHandler`.
 */
private class PromotedHapiCandidate extends Hapi::RouteHandler, Http::Servers::StandardRouteHandler {
  PromotedHapiCandidate() { this instanceof Hapi::RouteHandlerCandidate }
}

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Express::RouteHandler`.
 */
private class PromotedExpressCandidate extends Express::RouteHandler,
  Http::Servers::StandardRouteHandler {
  PromotedExpressCandidate() { this instanceof ConnectExpressShared::RouteHandlerCandidate }

  override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(this, kind)
  }
}

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Connect::RouteHandler`.
 */
private class PromotedConnectCandidate extends Connect::RouteHandler,
  Http::Servers::StandardRouteHandler {
  PromotedConnectCandidate() { this instanceof ConnectExpressShared::RouteHandlerCandidate }

  override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(this, kind)
  }
}
