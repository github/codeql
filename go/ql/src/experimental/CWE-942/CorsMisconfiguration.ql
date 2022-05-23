/**
 * @name CORS misconfiguration
 * @description If a CORS policy is configured to accept an origin value obtained from the request data,
 * 				or is set to `null`, and it allows credential sharing, then the users of the
 * 				application are vulnerable to the same range of attacks as in XSS (credential stealing, etc.).
 * @kind problem
 * @problem.severity warning
 * @id go/cors-misconfiguration
 * @tags security
 *       external/cwe/cwe-942
 *       external/cwe/cwe-346
 */

import go
import semmle.go.security.InsecureFeatureFlag::InsecureFeatureFlag

/**
 * A flag indicating a check for satisfied permissions or test configuration.
 */
class AllowedFlag extends FlagKind {
  AllowedFlag() { this = "allowed" }

  bindingset[result]
  override string getAFlagName() {
    result
        .toLowerCase()
        .matches("%" + ["allow", "match", "check", "debug", "devel", "insecure"] + "%")
  }
}

/**
 * Provides the name of the `Access-Control-Allow-Origin` header key.
 */
string headerAllowOrigin() { result = "Access-Control-Allow-Origin".toLowerCase() }

/**
 * Provides the name of the `Access-Control-Allow-Credentials` header key.
 */
string headerAllowCredentials() { result = "Access-Control-Allow-Credentials".toLowerCase() }

/**
 * An `Access-Control-Allow-Origin` header write.
 */
class AllowOriginHeaderWrite extends HTTP::HeaderWrite {
  AllowOriginHeaderWrite() { this.getHeaderName() = headerAllowOrigin() }
}

/**
 * An `Access-Control-Allow-Credentials` header write.
 */
class AllowCredentialsHeaderWrite extends HTTP::HeaderWrite {
  AllowCredentialsHeaderWrite() { this.getHeaderName() = headerAllowCredentials() }
}

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows to a HeaderWrite that writes an `Access-Control-Allow-Origin` header's value.
 */
class FlowsUntrustedToAllowOriginHeader extends TaintTracking::Configuration {
  FlowsUntrustedToAllowOriginHeader() { this = "from-untrusted-to-allow-origin-header-value" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isSink(DataFlow::Node sink, AllowOriginHeaderWrite hw) { sink = hw.getValue() }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(ControlFlow::ConditionGuardNode cgn |
      cgn.ensures(any(AllowedFlag f).getAFlag().getANode(), _)
    |
      cgn.dominates(node.getBasicBlock())
    )
  }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite's parent ResponseWriter
 * also has another HeaderWrite that sets a `Access-Control-Allow-Credentials`
 * header to `true`.
 */
predicate allowCredentialsIsSetToTrue(AllowOriginHeaderWrite allowOriginHW) {
  exists(AllowCredentialsHeaderWrite allowCredentialsHW |
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
predicate flowsFromUntrustedToAllowOrigin(AllowOriginHeaderWrite allowOriginHW, string message) {
  exists(FlowsUntrustedToAllowOriginHeader cfg, DataFlow::Node sink |
    cfg.hasFlowTo(sink) and
    cfg.isSink(sink, allowOriginHW)
  |
    message =
      headerAllowOrigin() + " header is set to a user-defined value, and " +
        headerAllowCredentials() + " is set to `true`"
  )
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite is for a `Access-Control-Allow-Origin`
 * header and the value is set to `null`.
 */
predicate allowOriginIsNull(AllowOriginHeaderWrite allowOriginHW, string message) {
  allowOriginHW.getHeaderValue().toLowerCase() = "null" and
  message =
    headerAllowOrigin() + " header is set to `" + allowOriginHW.getHeaderValue() + "`, and " +
      headerAllowCredentials() + " is set to `true`"
}

/**
 * A read on a map type.
 */
class MapRead extends DataFlow::ElementReadNode {
  MapRead() { this.getBase().getType() instanceof MapType }
}

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows somewhere.
 */
class FlowsFromUntrusted extends TaintTracking::Configuration {
  FlowsFromUntrusted() { this = "from-untrusted" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { this.isSink(sink, _) }

  predicate isSink(DataFlow::Node sink, ControlFlow::ConditionGuardNode cgn) {
    exists(IfStmt ifs |
      exists(Expr operand |
        operand = ifs.getCond().getAChildExpr*() and
        (
          exists(DataFlow::CallExpr call | call = operand |
            call.getTarget().hasQualifiedName("strings", "HasSuffix") and
            sink.asExpr() = call.getArgument(0)
          )
          or
          exists(MapRead mapRead |
            operand = mapRead.asExpr() and
            sink = mapRead.getIndex().getAPredecessor*()
            // TODO: add _, ok : map[untrusted]; ok
          )
          or
          exists(EqlExpr comp |
            operand = comp and
            (
              sink.asExpr() = comp.getLeftOperand() and
              not comp.getRightOperand().(StringLit).getStringValue() = ""
              or
              sink.asExpr() = comp.getRightOperand() and
              not comp.getLeftOperand().(StringLit).getStringValue() = ""
            )
          )
        )
      )
    |
      cgn.getCondition() = ifs.getCond()
    )
  }
}

/**
 * Holds if the provided `dst` is also destination of a `UntrustedFlowSource`.
 */
predicate flowsToGuardedByCheckOnUntrusted(AllowOriginHeaderWrite allowOriginHW) {
  exists(FlowsFromUntrusted cfg, DataFlow::Node sink, ControlFlow::ConditionGuardNode cgn |
    cfg.hasFlowTo(sink) and cfg.isSink(sink, cgn)
  |
    cgn.dominates(allowOriginHW.getBasicBlock())
  )
}

from AllowOriginHeaderWrite allowOriginHW, string message
where
  allowCredentialsIsSetToTrue(allowOriginHW) and
  (
    flowsFromUntrustedToAllowOrigin(allowOriginHW, message)
    or
    allowOriginIsNull(allowOriginHW, message)
  ) and
  not flowsToGuardedByCheckOnUntrusted(allowOriginHW) and
  not exists(ControlFlow::ConditionGuardNode cgn |
    cgn.ensures(any(AllowedFlag f).getAFlag().getANode(), _)
  |
    cgn.dominates(allowOriginHW.getBasicBlock())
  )
select allowOriginHW, message
