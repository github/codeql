/**
 * @name CORS misconfiguration
 * @description If a CORS policy is configured to accept an origin value obtained from the request data,
 * 				or is set to `null`, and it allows credential sharing, then the users of the
 * 				application are vulnerable to the same range of attacks as in XSS (credential stealing, etc.).
 * @kind problem
 * @problem.severity warning
 * @id go/cors-misconfiguration
 * @tags security
 *       experimental
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
    result.regexpMatch("(?i).*(allow|match|check|debug|devel|insecure).*")
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
class AllowOriginHeaderWrite extends Http::HeaderWrite {
  AllowOriginHeaderWrite() { this.getHeaderName() = headerAllowOrigin() }
}

/**
 * An `Access-Control-Allow-Credentials` header write.
 */
class AllowCredentialsHeaderWrite extends Http::HeaderWrite {
  AllowCredentialsHeaderWrite() { this.getHeaderName() = headerAllowCredentials() }
}

module UntrustedToAllowOriginHeaderConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  additional predicate isSinkHW(DataFlow::Node sink, AllowOriginHeaderWrite hw) {
    sink = hw.getValue()
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(ControlFlow::ConditionGuardNode cgn |
      cgn.ensures(any(AllowedFlag f).getAFlag().getANode(), _)
    |
      cgn.dominates(node.getBasicBlock())
    )
  }

  predicate isSink(DataFlow::Node sink) { isSinkHW(sink, _) }
}

module UntrustedToAllowOriginConfigConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  additional predicate isSinkWrite(DataFlow::Node sink, GinCors::AllowOriginsWrite w) { sink = w }

  predicate isSink(DataFlow::Node sink) { isSinkWrite(sink, _) }
}

/**
 * Tracks taint flowfor reasoning about when a `ThreatModelFlowSource` flows to
 * a `HeaderWrite` that writes an `Access-Control-Allow-Origin` header's value.
 */
module UntrustedToAllowOriginHeaderFlow = TaintTracking::Global<UntrustedToAllowOriginHeaderConfig>;

/**
 * Tracks taint flowfor reasoning about when a `ThreatModelFlowSource` flows to
 * a `AllowOriginsWrite` that writes an `Access-Control-Allow-Origin` header's value.
 */
module UntrustedToAllowOriginConfigFlow = TaintTracking::Global<UntrustedToAllowOriginConfigConfig>;

/**
 * Holds if the provided `allowOriginHW` HeaderWrite's parent ResponseWriter
 * also has another HeaderWrite that sets a `Access-Control-Allow-Credentials`
 * header to `true`.
 */
predicate allowCredentialsIsSetToTrue(DataFlow::ExprNode allowOriginHW) {
  exists(AllowCredentialsHeaderWrite allowCredentialsHW |
    allowCredentialsHW.getHeaderValue().toLowerCase() = "true"
  |
    allowOriginHW.(AllowOriginHeaderWrite).getResponseWriter() =
      allowCredentialsHW.getResponseWriter()
  )
  or
  exists(GinCors::AllowCredentialsWrite allowCredentialsGin |
    allowCredentialsGin.getExpr().getBoolValue() = true
  |
    allowCredentialsGin.getConfig() = allowOriginHW.(GinCors::AllowOriginsWrite).getConfig() and
    not exists(GinCors::AllowAllOriginsWrite allowAllOrigins |
      allowAllOrigins.getExpr().getBoolValue() = true and
      allowCredentialsGin.getConfig() = allowAllOrigins.getConfig()
    )
    or
    allowCredentialsGin.getBase() = allowOriginHW.(GinCors::AllowOriginsWrite).getBase() and
    not exists(GinCors::AllowAllOriginsWrite allowAllOrigins |
      allowAllOrigins.getExpr().getBoolValue() = true and
      allowCredentialsGin.getBase() = allowAllOrigins.getBase()
    )
  )
}

/**
 * Holds if the provided `allowOriginHW` HeaderWrite's value is set using an
 * ThreatModelFlowSource.
 * The `message` parameter is populated with the warning message to be returned by the query.
 */
predicate flowsFromUntrustedToAllowOrigin(DataFlow::ExprNode allowOriginHW, string message) {
  exists(DataFlow::Node sink |
    UntrustedToAllowOriginHeaderFlow::flowTo(sink) and
    UntrustedToAllowOriginHeaderConfig::isSinkHW(sink, allowOriginHW)
    or
    UntrustedToAllowOriginConfigFlow::flowTo(sink) and
    UntrustedToAllowOriginConfigConfig::isSinkWrite(sink, allowOriginHW)
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
predicate allowOriginIsNull(DataFlow::ExprNode allowOriginHW, string message) {
  allowOriginHW.(AllowOriginHeaderWrite).getHeaderValue().toLowerCase() = "null" and
  message =
    headerAllowOrigin() + " header is set to `" +
      allowOriginHW.(AllowOriginHeaderWrite).getHeaderValue() + "`, and " + headerAllowCredentials()
      + " is set to `true`"
  or
  allowOriginHW
      .(GinCors::AllowOriginsWrite)
      .asExpr()
      .(SliceLit)
      .getAnElement()
      .getStringValue()
      .toLowerCase() = "null" and
  message =
    headerAllowOrigin() + " header is set to `" + "null" + "`, and " + headerAllowCredentials() +
      " is set to `true`"
}

/**
 * A read on a map type.
 */
class MapRead extends DataFlow::ElementReadNode {
  MapRead() { this.getBase().getType() instanceof MapType }
}

module FromUntrustedConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { isSinkCgn(sink, _) }

  additional predicate isSinkCgn(DataFlow::Node sink, ControlFlow::ConditionGuardNode cgn) {
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
 * Tracks taint flow for reasoning about when a `ThreatModelFlowSource` flows
 * somewhere.
 */
module FromUntrustedFlow = TaintTracking::Global<FromUntrustedConfig>;

/**
 * Holds if the provided `allowOriginHW` is also destination of a `ThreatModelFlowSource`.
 */
predicate flowsToGuardedByCheckOnUntrusted(DataFlow::ExprNode allowOriginHW) {
  exists(DataFlow::Node sink, ControlFlow::ConditionGuardNode cgn |
    FromUntrustedFlow::flowTo(sink) and FromUntrustedConfig::isSinkCgn(sink, cgn)
  |
    cgn.dominates(allowOriginHW.getBasicBlock())
  )
}

from DataFlow::ExprNode allowOriginHW, string message
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
