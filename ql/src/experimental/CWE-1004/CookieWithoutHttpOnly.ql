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
  exists(DataFlow::PathNode cookieCreate, DataFlow::PathNode setCookieSink |
    exists(NetHttpCookieTrackingConfiguration cfg | cfg.hasFlowPath(cookieCreate, setCookieSink)) and
    (
      not exists(getValueForFieldWrite(cookieCreate.getNode().asExpr(), "HttpOnly")) and
      source = cookieCreate and
      sink = setCookieSink
      or
      exists(BoolToNetHttpCookieTrackingConfiguration cfg, DataFlow::PathNode setCookieSink2 |
        cfg.hasFlowPath(source, setCookieSink2) and
        setCookieSink2.getNode() = setCookieSink.getNode() and
        sink = setCookieSink2
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
      not exists(GorillaSessionOptionsTrackingConfiguration cfg, DataFlow::PathNode sessionSave2 |
        sessionSave2.getNode() = sessionSave.getNode() and
        cfg.hasFlowPath(_, sessionSave2)
      ) and
      source = cookieStoreCreate and
      sink = sessionSave
      or
      exists(
        GorillaSessionOptionsTrackingConfiguration cfg, DataFlow::PathNode options,
        DataFlow::PathNode sessionSave2
      |
        cfg.hasFlowPath(options, sessionSave2) and
        (
          not exists(DataFlow::Node rhs |
            rhs = getValueForFieldWrite(options.getNode().asExpr(), "HttpOnly")
          ) and
          sessionSave2.getNode() = sessionSave.getNode() and
          sink = sessionSave2 and
          source = options
          or
          exists(
            BoolToGorillaSessionOptionsTrackingConfiguration boolCfg,
            DataFlow::PathNode sessionSave3
          |
            boolCfg.hasFlowPath(source, sessionSave3) and
            sessionSave3.getNode() = sessionSave.getNode() and
            sink = sessionSave3
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
