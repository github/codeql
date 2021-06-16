/**
 * @name Use of insecure SSL/TLS version
 * @description Using an insecure SSL/TLS version may leave the connection vulnerable to attacks.
 * @id py/insecure-protocol
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.2
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

  AstNode getNode() { result = this.asCfgNode().(CallNode).getFunction().getNode() }
}

// Helper for pretty printer `callName`.
// This is a consequence of missing pretty priting.
// We do not want to evaluate our bespoke pretty printer
// for all `AstNode`s so we define a sub class of interesting ones.
//
// Note that AstNode is abstract and AstNode_ is a library class, so
// we have to extend @py_ast_node.
class Nameable extends @py_ast_node {
  Nameable() {
    this = any(ProtocolConfiguration pc).getNode()
    or
    exists(Nameable attr | this = attr.(Attribute).getObject())
  }

  string toString() { result = "AstNode" }
}

string callName(Nameable call) {
  result = call.(Name).getId()
  or
  exists(Attribute a | a = call | result = callName(a.getObject()) + "." + a.getName())
}

string configName(ProtocolConfiguration protocolConfiguration) {
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
