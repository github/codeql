/**
 * @name Disabling certificate validation
 * @description Disabling cryptographic certificate validation can cause security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision very-high
 * @id js/disabling-certificate-validation
 * @tags security
 *       external/cwe/cwe-295
 *       external/cwe/cwe-297
 */

import javascript

/** Gets options argument for a potential TLS connection */
DataFlow::InvokeNode tlsInvocation() {
  result instanceof ClientRequest
  or
  result = DataFlow::moduleMember("https", "Agent").getAnInstantiation()
  or
  result = DataFlow::moduleMember("https", "createServer").getACall()
  or
  exists(DataFlow::NewNode new |
    new = DataFlow::moduleMember("tls", "TLSSocket").getAnInstantiation()
  |
    result = new or
    result = new.getAMethodCall("renegotiate")
  )
  or
  result = DataFlow::moduleMember("tls", ["connect", "createServer"]).getACall()
}

/** Gets an options object for a TLS connection. */
DataFlow::ObjectLiteralNode tlsOptions() { result.flowsTo(tlsInvocation().getAnArgument()) }

from DataFlow::PropWrite disable
where
  exists(DataFlow::SourceNode env |
    env = NodeJSLib::process().getAPropertyRead("env") and
    disable = env.getAPropertyWrite("NODE_TLS_REJECT_UNAUTHORIZED") and
    disable.getRhs().mayHaveStringValue("0")
  )
  or
  (
    disable = tlsOptions().getAPropertyWrite("rejectUnauthorized")
    or
    // the same thing, but with API-nodes if they happen to be available
    exists(API::Node tlsInvk | tlsInvk.getAnInvocation() = tlsInvocation() |
      disable.getRhs() = tlsInvk.getAParameter().getMember("rejectUnauthorized").asSink()
    )
  ) and
  disable.getRhs().(AnalyzedNode).getTheBooleanValue() = false
select disable, "Disabling certificate validation is strongly discouraged."
