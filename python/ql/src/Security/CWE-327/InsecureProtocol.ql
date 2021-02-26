/**
 * @name Use of insecure SSL/TLS version
 * @description Using an insecure SSL/TLS version may leave the connection vulnerable to attacks.
 * @id py/insecure-protocol
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import FluentApiModel

string callName(AstNode call) {
  result = call.(Name).getId()
  or
  exists(Attribute a | a = call | result = callName(a.getObject()) + "." + a.getName())
}

from DataFlow::Node node, string insecure_version, CallNode call
where
  unsafe_connection_creation(node, insecure_version, call)
  or
  unsafe_context_creation(node, insecure_version, call)
select node, "Insecure SSL/TLS protocol version " + insecure_version + " specified in $@ ", call,
  "call to " + callName(call.getFunction().getNode())
//+ " specified in call to " + method_name + "."
