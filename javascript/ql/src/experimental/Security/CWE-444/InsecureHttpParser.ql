/**
 * @name Insecure http parser
 * @description Using an insecure http parser can lead to http smuggling attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.0
 * @precision high
 * @id js/insecure-http-parser
 * @tags security
 *       external/cwe/cwe-444
 */

import javascript

/** Gets options argument for a potential http or https connection */
DataFlow::InvokeNode nodeInvocation() {
  result instanceof ClientRequest
  or
  result instanceof Http::ServerDefinition
}

/** Gets an options object for an http or https connection. */
DataFlow::ObjectLiteralNode nodeOptions() { result.flowsTo(nodeInvocation().getAnArgument()) }

from DataFlow::PropWrite disable
where
  exists(DataFlow::SourceNode env |
    env = NodeJSLib::process().getAPropertyRead("env") and
    disable = env.getAPropertyWrite("NODE_OPTIONS") and
    disable.getRhs().getStringValue().matches("%--insecure-http-parser%")
  )
  or
  (
    disable = nodeOptions().getAPropertyWrite("insecureHTTPParser")
    or
    // the same thing, but with API-nodes if they happen to be available
    exists(API::Node nodeInvk | nodeInvk.getAnInvocation() = nodeInvocation() |
      disable.getRhs() = nodeInvk.getAParameter().getMember("insecureHTTPParser").asSink()
    )
  ) and
  disable.getRhs().(AnalyzedNode).getTheBooleanValue() = true
select disable, "Allowing invalid HTTP headers is strongly discouraged."
