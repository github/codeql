/**
 * @name Disabling certificate validation
 * @description Disabling cryptographic certificate validation can cause security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id js/disabling-certificate-validation
 * @tags security
 *       external/cwe-295
 */

import javascript

from DataFlow::PropWrite disable
where
  exists(DataFlow::SourceNode env |
    env = NodeJSLib::process().getAPropertyRead("env") and
    disable = env.getAPropertyWrite("NODE_TLS_REJECT_UNAUTHORIZED") and
    disable.getRhs().mayHaveStringValue("0")
  )
  or
  exists(DataFlow::ObjectLiteralNode options, DataFlow::InvokeNode invk |
    options.flowsTo(invk.getAnArgument()) and
    disable = options.getAPropertyWrite("rejectUnauthorized") and
    disable.getRhs().(AnalyzedNode).getTheBooleanValue() = false
  |
    invk instanceof NodeJSLib::NodeJSClientRequest
    or
    invk = DataFlow::moduleMember("https", "Agent").getAnInstantiation()
    or
    exists(DataFlow::NewNode new |
      new = DataFlow::moduleMember("tls", "TLSSocket").getAnInstantiation()
    |
      invk = new or
      invk = new.getAMethodCall("renegotiate")
    )
    or
    invk = DataFlow::moduleMember("tls", ["connect", "createServer"]).getACall()
  )
select disable, "Disabling certificate validation is strongly discouraged."
