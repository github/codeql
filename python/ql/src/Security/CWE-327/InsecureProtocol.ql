/**
 * @name Use of insecure SSL/TLS version
 * @description Using an insecure SSL/TLS version may leave the connection vulnerable to attacks.
 * @id py/insecure-protocol
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import semmle.python.dataflow.new.DataFlow
import FluentApiModel

// Helper for pretty printer `configName`.
// This is a consequence of missing pretty priting.
// We do not want to evaluate our bespoke pretty printer
// for all `DataFlow::Node`s so we define a sub class of interesting ones.
class ProtocolConfiguration extends DataFlow::Node {
  ProtocolConfiguration() {
    unsafe_connection_creation_with_context(_, _, this, _)
    or
    unsafe_connection_creation_without_context(this, _)
    or
    unsafe_context_creation(this, _)
  }

  DataFlow::Node getNode() { result = this.(DataFlow::CallCfgNode).getFunction() }
}

// Helper for pretty printer `callName`.
// This is a consequence of missing pretty priting.
// We do not want to evaluate our bespoke pretty printer
// for all `DataFlow::Node`s so we define a sub class of interesting ones.
class Nameable extends DataFlow::Node {
  Nameable() {
    this = any(ProtocolConfiguration pc).getNode()
    or
    this = any(Nameable attr).(DataFlow::AttrRef).getObject()
  }
}

string callName(Nameable call) {
  result = call.asExpr().(Name).getId()
  or
  exists(DataFlow::AttrRef a | a = call |
    result = callName(a.getObject()) + "." + a.getAttributeName()
  )
}

string configName(ProtocolConfiguration protocolConfiguration) {
  result = "call to " + callName(protocolConfiguration.(DataFlow::CallCfgNode).getFunction())
  or
  not protocolConfiguration instanceof DataFlow::CallCfgNode and
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
