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

string configName(DataFlow::Node protocolConfiguration) {
  result =
    "call to " + callName(protocolConfiguration.asCfgNode().(CallNode).getFunction().getNode())
  or
  not protocolConfiguration.asCfgNode() instanceof CallNode and
  not protocolConfiguration instanceof ContextCreation and
  result = "context modification"
}

string verb(boolean specific) {
  specific = true and result = "specified"
  or
  specific = false and result = "allowed"
}

from
  DataFlow::Node connectionCreation, string insecure_version, DataFlow::Node protocolConfiguration,
  boolean specific
where
  unsafe_connection_creation_with_context(connectionCreation, insecure_version,
    protocolConfiguration, specific)
  or
  unsafe_connection_creation_without_context(connectionCreation, insecure_version) and
  protocolConfiguration = connectionCreation and
  specific = true
  or
  unsafe_context_creation(protocolConfiguration, insecure_version) and
  connectionCreation = protocolConfiguration and
  specific = true
select connectionCreation,
  "Insecure SSL/TLS protocol version " + insecure_version + " " + verb(specific) + " by $@ ",
  protocolConfiguration, configName(protocolConfiguration)
