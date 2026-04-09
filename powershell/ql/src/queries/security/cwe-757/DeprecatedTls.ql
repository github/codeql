/**
 * @name Use of deprecated TLS/SSL version
 * @description Using deprecated TLS/SSL versions (SSL3, TLS 1.0, TLS 1.1) weakens transport security.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/microsoft/security/deprecated-tls
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-757
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow

/**
 * Holds if `protocolName` is a deprecated TLS/SSL protocol (lowercase).
 */
predicate isDeprecatedProtocol(string protocolName) {
  protocolName = ["ssl3", "tls", "tls11"]
}

/**
 * Gets the human-readable name for a deprecated protocol.
 */
bindingset[protocolName]
string getProtocolDisplayName(string protocolName) {
  protocolName = "ssl3" and result = "SSL 3.0"
  or
  protocolName = "tls" and result = "TLS 1.0"
  or
  protocolName = "tls11" and result = "TLS 1.1"
}

/**
 * A reference to a deprecated SecurityProtocolType enum value, e.g.
 * [Net.SecurityProtocolType]::Ssl3
 */
class DeprecatedSecurityProtocolType extends DataFlow::Node {
  string protocolName;

  DeprecatedSecurityProtocolType() {
    exists(API::Node node |
      (
        node =
          API::getTopLevelMember("system")
              .getMember("net")
              .getMember("securityprotocoltype")
              .getMember(protocolName)
        or
        node =
          API::getTopLevelMember("net")
              .getMember("securityprotocoltype")
              .getMember(protocolName)
      ) and
      this = node.asSource() and
      isDeprecatedProtocol(protocolName)
    )
  }

  string getProtocolName() { result = protocolName }
}

/**
 * A reference to a deprecated SslProtocols enum value, e.g.
 * [System.Security.Authentication.SslProtocols]::Tls
 */
class DeprecatedSslProtocols extends DataFlow::Node {
  string protocolName;

  DeprecatedSslProtocols() {
    exists(API::Node node |
      node =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("authentication")
            .getMember("sslprotocols")
            .getMember(protocolName) and
      this = node.asSource() and
      isDeprecatedProtocol(protocolName)
    )
  }

  string getProtocolName() { result = protocolName }
}

from DataFlow::Node node, string protocolName
where
  exists(DeprecatedSecurityProtocolType d |
    node = d and protocolName = d.getProtocolName()
  )
  or
  exists(DeprecatedSslProtocols d | node = d and protocolName = d.getProtocolName())
select node,
  "Use of deprecated protocol " + getProtocolDisplayName(protocolName) +
    ". Use TLS 1.2 or TLS 1.3 instead."
