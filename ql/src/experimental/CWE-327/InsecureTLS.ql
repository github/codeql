/**
 * @name Insecure TLS configuration
 * @description If an application supports insecure TLS versions or ciphers, it may be vulnerable to
 *              man-in-the-middle and other attacks.
 * @kind path-problem
 * @problem.severity warning
 * @id go/insecure-tls
 * @tags security
 *       external/cwe/cwe-327
 */

import go
import DataFlow::PathGraph

/**
 * Check whether the file where the node is located is a test file.
 */
predicate isTestFile(DataFlow::Node node) {
  // Exclude results in test files:
  exists(File file | file = node.getRoot().getFile() |
    file instanceof TestFile or file.getPackageName() = "tests"
  )
}

predicate unsafeTlsVersion(int val, string name) {
  // tls.VersionSSL30
  val = 768 and name = "VersionSSL30"
  or
  // tls.VersionTLS10
  val = 769 and name = "VersionTLS10"
  or
  // tls.VersionTLS11
  val = 770 and name = "VersionTLS11"
  or
  // Zero indicates the lowest available version setting for MinVersion,
  // or the highest available version setting for MaxVersion.
  val = 0 and name = ""
}

/**
 * Flow of unsecure TLS versions into a `tls.Config` struct,
 * to the `MinVersion` and `MaxVersion` fields.
 */
class TlsVersionFlowConfig extends TaintTracking::Configuration {
  TlsVersionFlowConfig() { this = "TlsVersionFlowConfig" }

  predicate isSource(DataFlow::Node source, int val) {
    val = source.getIntValue() and
    unsafeTlsVersion(val, _)
  }

  predicate isSink(DataFlow::Node sink, Field fld) {
    fld.hasQualifiedName("crypto/tls", "Config", ["MinVersion", "MaxVersion"]) and
    sink = fld.getAWrite().getRhs()
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

/**
 * Find insecure TLS versions.
 */
predicate checkTlsVersions(DataFlow::PathNode source, DataFlow::PathNode sink, string message) {
  exists(TlsVersionFlowConfig cfg, int version, Field fld |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), version) and
    cfg.isSink(sink.getNode(), fld) and
    // Exclude tls.Config.Max = 0 (which is OK):
    not (version = 0 and fld.getName() = "MaxVersion")
  |
    version = 0 and
    message = "Using lowest TLS version for " + fld + "."
    or
    version != 0 and
    exists(string name | unsafeTlsVersion(version, name) |
      message = "Using insecure TLS version " + name + " for " + fld + "."
    )
  )
}

/**
 * Flow of unsecure TLS cipher suites into a `tls.Config` struct,
 * to the `CipherSuites` field.
 */
class TlsInsecureCipherSuitesFlowConfig extends TaintTracking::Configuration {
  TlsInsecureCipherSuitesFlowConfig() { this = "TlsInsecureCipherSuitesFlowConfig" }

  predicate isSourceValueEntity(DataFlow::Node source, string suiteName) {
    exists(DataFlow::ValueEntity val |
      val.hasQualifiedName("crypto/tls", suiteName) and
      suiteName =
        ["TLS_RSA_WITH_RC4_128_SHA", "TLS_RSA_WITH_AES_128_CBC_SHA256",
            "TLS_ECDHE_ECDSA_WITH_RC4_128_SHA", "TLS_ECDHE_RSA_WITH_RC4_128_SHA",
            "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"]
    |
      source = val.getARead()
    )
  }

  predicate isSourceInsecureCipherSuites(DataFlow::Node source) {
    exists(Function insecureCipherSuites |
      insecureCipherSuites.hasQualifiedName("crypto/tls", "InsecureCipherSuites")
    |
      source = insecureCipherSuites.getACall().getResult()
    )
  }

  override predicate isSource(DataFlow::Node source) {
    // TODO: source can also be result of tls.InsecureCipherSuites()[0].ID
    isSourceInsecureCipherSuites(source)
    or
    isSourceValueEntity(source, _)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::Field fld | fld.hasQualifiedName("crypto/tls", "Config", "CipherSuites") |
      sink = fld.getAWrite().getRhs()
    )
  }

  /**
   * Declare sinks as out-sanitizers in order to avoid producing superfluous paths where a cipher
   * is written to CipherSuites, then the list is further extended with either safe or tainted
   * suites.
   */
  override predicate isSanitizerOut(DataFlow::Node node) {
    super.isSanitizerOut(node) or isSink(node)
  }
}

/**
 * Find insecure TLS cipher suites.
 */
predicate checkTlsInsecureCipherSuites(
  DataFlow::PathNode source, DataFlow::PathNode sink, string message
) {
  exists(TlsInsecureCipherSuitesFlowConfig cfg | cfg.hasFlowPath(source, sink) |
    exists(string name | cfg.isSourceValueEntity(source.getNode(), name) |
      message = "Use of an insecure cipher suite: " + name + "."
    )
    or
    cfg.isSourceInsecureCipherSuites(source.getNode()) and
    message = "Use of an insecure cipher suite from InsecureCipherSuites()."
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string message
where
  (
    checkTlsVersions(source, sink, message) or
    checkTlsInsecureCipherSuites(source, sink, message)
  ) and
  // Exclude results in test code:
  not isTestFile(sink.getNode())
select sink.getNode(), source, sink, message
