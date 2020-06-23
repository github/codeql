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
  exists(File fl | fl = node.getRoot().getFile() |
    fl instanceof TestFile or fl.getPackageName() = "tests"
  )
}

/**
 * Returns the name of the write target field.
 */
string getSinkTargetFieldName(DataFlow::PathNode sink) {
  result = any(DataFlow::Field fld | fld.getAWrite().getRhs() = sink.getNode()).getName()
}

/**
 * Returns the name of a ValueEntity.
 */
string getSourceValueEntityName(DataFlow::PathNode source) {
  result =
    any(DataFlow::ValueEntity val | source.getNode().(DataFlow::ReadNode).reads(val)).getName()
}

predicate isUnsafeTlsVersionInt(int val) {
  // tls.VersionSSL30
  val = 768
  or
  // tls.VersionTLS10
  val = 769
  or
  // tls.VersionTLS11
  val = 770
}

string tlsVersionIntToString(int val) {
  // tls.VersionSSL30
  val = 768 and result = "VersionSSL30"
  or
  // tls.VersionTLS10
  val = 769 and result = "VersionTLS10"
  or
  // tls.VersionTLS11
  val = 770 and result = "VersionTLS11"
}

/**
 * Flow of unsecure TLS versions into a `tls.Config` struct,
 * to the `MinVersion` and `MaxVersion` fields.
 */
class TlsVersionFlowConfig extends TaintTracking::Configuration {
  TlsVersionFlowConfig() { this = "TlsVersionFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() =
      any(DataFlow::ValueExpr val |
        val.getIntValue() = 0 or isUnsafeTlsVersionInt(val.getIntValue())
      )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Write write |
      write =
        any(DataFlow::Field fld |
          fld.hasQualifiedName("crypto/tls", "Config", ["MinVersion", "MaxVersion"])
        ).getAWrite() and
      // The write must NOT happen inside a switch statement:
      not exists(ExpressionSwitchStmt switch |
        switch.getBody().getAChildStmt().getChild(0) =
          any(Assignment asign | asign.getRhs() = sink.asExpr())
      )
    |
      sink = write.getRhs()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { isTestFile(node) }
}

/**
 * Find insecure TLS versions.
 */
predicate checkTlsVersions(DataFlow::PathNode source, DataFlow::PathNode sink, string message) {
  exists(TlsVersionFlowConfig cfg |
    cfg.hasFlowPath(source, sink) and
    // Exclude tls.Config.Max = 0 (which is OK):
    not exists(Write write, DataFlow::ValueExpr v0 | write.getRhs() = sink.getNode() |
      v0 = source.getNode().asExpr() and
      v0.getIntValue() = 0 and
      getSinkTargetFieldName(sink) = "MaxVersion"
    )
  |
    message =
      "TLS version too low for " + getSinkTargetFieldName(sink) + ": " +
        tlsVersionIntToString(any(DataFlow::ValueExpr val |
            val = sink.getNode().asExpr() and
            val.getIntValue() != 0
          ).getIntValue())
    or
    message = "Using lowest TLS version for " + getSinkTargetFieldName(sink) and
    exists(DataFlow::ValueExpr v0 |
      v0 = sink.getNode().asExpr() and
      v0.getIntValue() = 0
    )
  )
}

/**
 * Flow of unsecure TLS cipher suites into a `tls.Config` struct,
 * to the `CipherSuites` field.
 */
class TlsInsecureCipherSuitesFlowConfig extends TaintTracking::Configuration {
  TlsInsecureCipherSuitesFlowConfig() { this = "TlsInsecureCipherSuitesFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    // TODO: source can also be result of tls.InsecureCipherSuites()[0].ID
    source =
      any(Function insecureCipherSuites |
        insecureCipherSuites.hasQualifiedName("crypto/tls", "InsecureCipherSuites")
      ).getACall().getResult()
    or
    source =
      any(DataFlow::ValueEntity val |
        val
            .hasQualifiedName("crypto/tls",
              any(string suiteName |
                suiteName = "TLS_RSA_WITH_RC4_128_SHA" or
                suiteName = "TLS_RSA_WITH_AES_128_CBC_SHA256" or
                suiteName = "TLS_ECDHE_ECDSA_WITH_RC4_128_SHA" or
                suiteName = "TLS_ECDHE_RSA_WITH_RC4_128_SHA" or
                suiteName = "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256" or
                suiteName = "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
              ))
      ).getARead()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink =
      any(DataFlow::Field fld | fld.hasQualifiedName("crypto/tls", "Config", "CipherSuites"))
          .getAWrite()
          .getRhs()
  }

  override predicate isSanitizer(DataFlow::Node node) { isTestFile(node) }
}

/**
 * Find insecure TLS cipher suites.
 */
predicate checkTlsInsecureCipherSuites(
  DataFlow::PathNode source, DataFlow::PathNode sink, string message
) {
  exists(TlsInsecureCipherSuitesFlowConfig cfg | cfg.hasFlowPath(source, sink) |
    message = "Use of an insecure cipher suite: " + getSourceValueEntityName(source)
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string message
where
  checkTlsVersions(source, sink, message) or
  checkTlsInsecureCipherSuites(source, sink, message)
select sink.getNode(), source, sink, message
