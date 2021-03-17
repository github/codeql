/**
 * @name Insecure Cipher Suites and Protocols in Tomcat Server Configuration
 * @description Obsolete TLS/SSL protocols, and obsolete cipher suites or null cipher is configured
 * in the Tomcat server, which offers insufficient transport layer protection.
 * @kind problem
 * @id java/insecure-tomcat-cipher-config
 * @tags security
 *       external/cwe-327
 *       external/cwe-310
 */

import java
import ServerXML

/**
 * Holds if obsolete protocols are allowed. `TLSv1.2` & `TLSv1.3` is expected to be explicitly enabled.
 * `TLSv1.1` may also be accepted since the protocol itself doesn't have known security issues. The
 * check excludes SSLv2, SSLv3, and TLSv1 using regex for explicitly specified obsolete protocols without
 * the starting "-".
 */
predicate allowInsecureProtocol(ServerConnector connector) {
  exists(string protocol |
    (
      protocol = connector.getJseeSslProtocol()
      or
      protocol = connector.getEnabledJseeSslProtocols()
      or
      protocol = connector.getEnabledAprSslProtocols()
      or
      exists(ServerSSLHostConfig hostConfig |
        hostConfig.getParent() = connector and protocol = hostConfig.getProtocols()
      )
    ) and
    (
      protocol = "all" // SSLv2Hello,TLSv1,TLSv1.1,TLSv1.2,TLSv1.3
      or
      protocol.regexpMatch(".*(?<!-)(SSLv2|SSLv3|TLSv1([^.]|$)).*") // e.g. all -TLSv1.1 -TLSv1 -SSLv2 -SSLv3
    )
  )
}

/**
 * Holds if insecure TLS/SSL cipher suites are enabled. The simple check excludes null/RC4/3DES/CBC
 * encryption algorithms and MD5/SHA-1 hash algorithms using a regex for explicitly specified weak
 * cipher suites without the starting "-" or "!".
 */
predicate allowInsecureCipherSuites(ServerConnector connector) {
  exists(string ciphers |
    (
      ciphers = connector.getJseeCiphers() // e.g. TLS_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_NULL_SHA
      or
      ciphers = connector.getAprCiphers() // e.g. ALL:+HIGH:!ADH:!EXP:!SSLv2:!SSLv3:!MEDIUM:!LOW:!NULL:!aNULL
      or
      exists(ServerSSLHostConfig hostConfig |
        hostConfig.getParent() = connector and ciphers = hostConfig.getCiphers()
      )
    ) and
    ciphers
        .regexpMatch([
            ".*(?<![-!])\\b(?:\\w+(?:NULL|RC4|3DES|CBC)\\w+|\\w+(MD5|SHA))\\b(?:,.*|$)",
            ".*(?<![-!])\\b(NULL|SSLv2|SSLv3)\\b(?::.*|$)"
          ])
  )
}

/**
 * Holds if the `ServerXMLFile` serverFile is a non-production deployment file indicated by:
 *    a) in a non-production directory
 *    b) with a non-production file name
 */
predicate isNonProdConfig(ServerXMLFile serverFile) {
  serverFile.getFile().getAbsolutePath().matches(["%dev%", "%test%", "%sample%"])
}

from ServerConnector connector
where
  (
    connector.isHttpsScheme() and
    connector.isSecure()
    or
    connector.isSSLEnabled()
  ) and
  (
    allowInsecureProtocol(connector) or
    allowInsecureCipherSuites(connector)
  ) and
  not connector.isProxy() and
  (
    not isNonProdConfig(connector.getFile()) or
    connector.getFile().getAbsolutePath().matches("%codeql%") // CodeQL test cases
  )
select connector,
  "Tomcat server configuration should not allow obsolete protocols and/or weak cipher suites"
