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
  Http::Servers::StandardRouteHandler instanceof NodeJSLib::RouteHandlerCandidate
{ }

/**
 * Add `Hapi::RouteHandlerCandidate` to the extent of `Hapi::RouteHandler`.
 */
private class PromotedHapiCandidate extends Hapi::RouteHandler, Http::Servers::StandardRouteHandler instanceof Hapi::RouteHandlerCandidate
{ }

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Express::RouteHandler`.
 */
private class PromotedExpressCandidate extends Express::RouteHandler,
  Http::Servers::StandardRouteHandler instanceof ConnectExpressShared::RouteHandlerCandidate
{
  override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(this, kind)
  }
}

/**
 * Add `ConnectExpressShared::RouteHandlerCandidate` to the extent of `Connect::RouteHandler`.
 */
private class PromotedConnectCandidate extends Connect::RouteHandler,
  Http::Servers::StandardRouteHandler instanceof ConnectExpressShared::RouteHandlerCandidate
{
  override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
    result = ConnectExpressShared::getRouteHandlerParameter(this, kind)
  }
}

/**
 * Add `Restify::RouteHandlerCandidate` to the extent of `Restify::RouteHandler`.
 */
private class PromotedRestifyCandidate extends Restify::RouteHandler,
  Http::Servers::StandardRouteHandler
{
  PromotedRestifyCandidate() { this instanceof Restify::RouteHandlerCandidate }
}

/**
 * Add `Spife::RouteHandlerCandidate` to the extent of `Spife::RouteHandler`.
 */
private class PromotedSpifeCandidate extends Spife::RouteHandler,
  Http::Servers::StandardRouteHandler
{
  PromotedSpifeCandidate() { this instanceof Spife::RouteHandlerCandidate }
}
