/**
 * @name CORS misconfiguration
 * @description If a CORS policy is configured to accept an origin value obtained from the request data,
 * 				or is set to `*` or `null`, and it allows credential sharing, then the users of the
 * 				application are vulnerable to the same range of attacks as in XSS (credential stealing, etc.).
 * @kind problem
 * @problem.severity warning
 * @id go/cors-misconfiguration
 * @tags security
 *       external/cwe/cwe-942
 *       external/cwe/cwe-346
 */

import go

/**
 * Provides the name of the `Access-Control-Allow-Origin` header key.
 */
string headerAllowOrigin() { result = "Access-Control-Allow-Origin".toLowerCase() }

/**
 * Provides the name of the `Access-Control-Allow-Credentials` header key.
 */
string headerAllowCredentials() { result = "Access-Control-Allow-Credentials".toLowerCase() }

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows to a HeaderWrite that writes an `Access-Control-Allow-Origin` header's value.
 */
class FlowsUntrustedToAllowOriginHeader extends TaintTracking::Configuration {
  FlowsUntrustedToAllowOriginHeader() { this = "from-untrusted-to-allow-origin-header-value" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isSink(DataFlow::Node sink, HTTP::HeaderWrite hw) {
    hw.getHeaderName() = headerAllowOrigin() and sink = hw.getValue()
  }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite's parent ResponseWriter
 * also has another HeaderWrite that sets a `Access-Control-Allow-Credentials`
 * header to `true`.
 */
predicate allowCredentialsIsSetToTrue(HTTP::HeaderWrite allowOriginHW) {
  exists(HTTP::HeaderWrite allowCredentialsHW |
    allowCredentialsHW.getHeaderName() = headerAllowCredentials() and
    allowCredentialsHW.getHeaderValue().toLowerCase() = "true"
  |
    allowOriginHW.getResponseWriter() = allowCredentialsHW.getResponseWriter()
  )
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite's value is set using an
 * UntrustedFlowSource.
 * The `message` parameter is populated with the warning message to be returned by the query.
 */
predicate flowsFromUntrustedToAllowOrigin(HTTP::HeaderWrite allowOriginHW, string message) {
  exists(FlowsUntrustedToAllowOriginHeader cfg, DataFlow::PathNode source, DataFlow::PathNode sink |
    cfg.hasFlowPath(source, sink) and
    cfg.isSink(sink.getNode(), allowOriginHW)
  |
    message =
      headerAllowOrigin() + " header is set to a user-defined value, and " +
        headerAllowCredentials() + " is set to `true`"
  )
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite is for a `Access-Control-Allow-Origin`
 * header and the value is set to `*` or `null`.
 */
predicate allowOriginIsWildcardOrNull(HTTP::HeaderWrite allowOriginHW, string message) {
  allowOriginHW.getHeaderName() = headerAllowOrigin() and
  allowOriginHW.getHeaderValue().toLowerCase() = ["*", "null"] and
  message =
    headerAllowOrigin() + " header is set to `" + allowOriginHW.getHeaderValue() + "`, and " +
      headerAllowCredentials() + " is set to `true`"
}

from HTTP::HeaderWrite allowOriginHW, string message
where
  allowCredentialsIsSetToTrue(allowOriginHW) and
  (
    flowsFromUntrustedToAllowOrigin(allowOriginHW, message)
    or
    allowOriginIsWildcardOrNull(allowOriginHW, message)
  )
select allowOriginHW, message
