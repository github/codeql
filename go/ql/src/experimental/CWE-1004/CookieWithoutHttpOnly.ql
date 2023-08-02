/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/cookie-httponly-not-set
 * @tags security
 *       experimental
 *       external/cwe/cwe-1004
 */

import go
import AuthCookie

module NetHttpCookieTrackingFlow =
  DataFlow::MergePathGraph<NameToNetHttpCookieTrackingFlow::PathNode,
    BoolToNetHttpCookieTrackingFlow::PathNode, NameToNetHttpCookieTrackingFlow::PathGraph,
    BoolToNetHttpCookieTrackingFlow::PathGraph>;

module GorillaTrackingFlow =
  DataFlow::MergePathGraph3<GorillaCookieStoreSaveTrackingFlow::PathNode,
    GorillaSessionOptionsTrackingFlow::PathNode, BoolToGorillaSessionOptionsTrackingFlow::PathNode,
    GorillaCookieStoreSaveTrackingFlow::PathGraph, GorillaSessionOptionsTrackingFlow::PathGraph,
    BoolToGorillaSessionOptionsTrackingFlow::PathGraph>;

module MergedFlow =
  DataFlow::MergePathGraph3<NetHttpCookieTrackingFlow::PathNode,
    BoolToGinSetCookieTrackingFlow::PathNode, GorillaTrackingFlow::PathNode,
    NetHttpCookieTrackingFlow::PathGraph, BoolToGinSetCookieTrackingFlow::PathGraph,
    GorillaTrackingFlow::PathGraph>;

import MergedFlow::PathGraph

/** Holds if `HttpOnly` of `net/http.SetCookie` is set to `false` or not set (default value is used). */
predicate isNetHttpCookieFlow(
  NetHttpCookieTrackingFlow::PathNode source, NetHttpCookieTrackingFlow::PathNode sink
) {
  exists(
    NameToNetHttpCookieTrackingFlow::PathNode sensitiveName,
    NameToNetHttpCookieTrackingFlow::PathNode setCookieSink
  |
    NameToNetHttpCookieTrackingFlow::flowPath(sensitiveName, setCookieSink) and
    (
      not BoolToNetHttpCookieTrackingFlow::flowTo(sink.getNode()) and
      source.asPathNode1() = sensitiveName and
      sink.asPathNode1() = setCookieSink
      or
      BoolToNetHttpCookieTrackingFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
      source.getNode().getBoolValue() = false and
      setCookieSink.getNode() = sink.getNode()
    )
  )
}

/**
 * Holds if there is gorilla cookie store creation to `Save` path and
 * `HttpOnly` is set to `false` or not set (default value is used).
 */
predicate isGorillaSessionsCookieFlow(
  GorillaTrackingFlow::PathNode source, GorillaTrackingFlow::PathNode sink
) {
  exists(
    GorillaCookieStoreSaveTrackingFlow::PathNode cookieStoreCreate,
    GorillaCookieStoreSaveTrackingFlow::PathNode sessionSave
  |
    GorillaCookieStoreSaveTrackingFlow::flowPath(cookieStoreCreate, sessionSave) and
    (
      not GorillaSessionOptionsTrackingFlow::flowTo(sink.getNode()) and
      source.asPathNode1() = cookieStoreCreate and
      sink.asPathNode1() = sessionSave
      or
      exists(GorillaTrackingFlow::PathNode options, GorillaTrackingFlow::PathNode sessionSave2 |
        GorillaSessionOptionsTrackingFlow::flowPath(options.asPathNode2(),
          sessionSave2.asPathNode2()) and
        (
          not BoolToGorillaSessionOptionsTrackingFlow::flowTo(sink.getNode()) and
          sink = sessionSave2 and
          source = options and
          sessionSave.getNode() = sessionSave2.getNode()
          or
          BoolToGorillaSessionOptionsTrackingFlow::flowPath(source.asPathNode3(), sink.asPathNode3()) and
          source.getNode().getBoolValue() = false and
          sink.getNode() = sessionSave.getNode()
        )
      )
    )
  )
}

from MergedFlow::PathNode source, MergedFlow::PathNode sink
where
  isNetHttpCookieFlow(source.asPathNode1(), sink.asPathNode1()) or
  BoolToGinSetCookieTrackingFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) or
  isGorillaSessionsCookieFlow(source.asPathNode3(), sink.asPathNode3())
select sink.getNode(), source, sink, "Cookie attribute 'HttpOnly' is not set to true."
