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
 *       external/cwe/cwe-1004
 */

import go
import AuthCookie
import DataFlow::PathGraph

/** Holds if `HttpOnly` of `net/http.SetCookie` is set to `false` or not set (default value is used). */
predicate isNetHttpCookieFlow(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(DataFlow::PathNode sensitiveName, DataFlow::PathNode setCookieSink |
    exists(NameToNetHttpCookieTrackingConfiguration cfg |
      cfg.hasFlowPath(sensitiveName, setCookieSink)
    ) and
    (
      not any(BoolToNetHttpCookieTrackingConfiguration cfg).hasFlowTo(setCookieSink.getNode()) and
      source = sensitiveName and
      sink = setCookieSink
      or
      exists(BoolToNetHttpCookieTrackingConfiguration cfg |
        cfg.hasFlow(source.getNode(), setCookieSink.getNode()) and
        source.getNode().getBoolValue() = false and
        sink = setCookieSink
      )
    )
  )
}

/**
 * Holds if there is gorilla cookie store creation to `Save` path and
 * `HttpOnly` is set to `false` or not set (default value is used).
 */
predicate isGorillaSessionsCookieFlow(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(DataFlow::PathNode cookieStoreCreate, DataFlow::PathNode sessionSave |
    any(GorillaCookieStoreSaveTrackingConfiguration cfg).hasFlowPath(cookieStoreCreate, sessionSave) and
    (
      not any(GorillaSessionOptionsTrackingConfiguration cfg).hasFlowTo(sessionSave.getNode()) and
      source = cookieStoreCreate and
      sink = sessionSave
      or
      exists(GorillaSessionOptionsTrackingConfiguration cfg, DataFlow::PathNode options |
        cfg.hasFlow(options.getNode(), sessionSave.getNode()) and
        (
          not any(BoolToGorillaSessionOptionsTrackingConfiguration boolCfg)
              .hasFlowTo(sessionSave.getNode()) and
          sink = sessionSave and
          source = options
          or
          exists(BoolToGorillaSessionOptionsTrackingConfiguration boolCfg |
            boolCfg.hasFlow(source.getNode(), sessionSave.getNode()) and
            source.getNode().getBoolValue() = false and
            sink = sessionSave
          )
        )
      )
    )
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  isNetHttpCookieFlow(source, sink) or
  any(BoolToGinSetCookieTrackingConfiguration cfg).hasFlowPath(source, sink) or
  isGorillaSessionsCookieFlow(source, sink)
select sink.getNode(), source, sink, "Cookie attribute 'HttpOnly' is not set to true."
