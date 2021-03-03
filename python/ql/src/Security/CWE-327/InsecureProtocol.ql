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

string sourceName(DataFlow::Node source) {
  result = "call to " + callName(source.asCfgNode().(CallNode).getFunction().getNode())
  or
  not source.asCfgNode() instanceof CallNode and
  not source instanceof ContextCreation and
  result = "context modification"
}

string verb(boolean specific) {
  specific = true and result = "specified"
  or
  specific = false and result = "allowed"
}

from DataFlow::Node creation, string insecure_version, DataFlow::Node source, boolean specific
where
  unsafe_connection_creation(creation, insecure_version, source, specific)
  or
  unsafe_context_creation(creation, insecure_version, source.asCfgNode()) and specific = true
select creation,
  "Insecure SSL/TLS protocol version " + insecure_version + " " + verb(specific) + " by $@ ",
  source, sourceName(source)
