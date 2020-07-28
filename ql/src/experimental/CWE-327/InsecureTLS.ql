/**
 * @name Insecure TLS configuration
 * @description If an application supports insecure TLS versions or ciphers, it may be vulnerable to
 *              man-in-the-middle and other attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision very-high
 * @id go/insecure-tls
 * @tags security
 *       external/cwe/cwe-327
 */

import go
import DataFlow::PathGraph
import semmle.go.security.InsecureFeatureFlag::InsecureFeatureFlag

/**
 * Check whether the file where the node is located is a test file.
 */
predicate isTestFile(DataFlow::Node node) {
  // Exclude results in test files:
  exists(File file | file = node.getRoot().getFile() |
    file instanceof TestFile or file.getPackageName() = "tests"
  )
}

/**
 * Holds if it is insecure to assign TLS version `val` named `named` to `tls.Config` field `fieldName`
 */
predicate isInsecureTlsVersion(int val, string name, string fieldName) {
  (fieldName = "MinVersion" or fieldName = "MaxVersion") and
  // tls.VersionSSL30
  (
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
    val = 0 and name = "" and fieldName = "MinVersion"
  )
}

/**
 * Holds if `node` refers to a value returned alongside a non-nil error value.
 *
 * For example, `0` in `func tryGetInt() (int, error) { return 0, errors.New("no good") }`
 */
predicate isReturnedWithError(DataFlow::Node node) {
  exists(ReturnStmt ret |
    ret.getExpr(0) = node.asExpr() and
    ret.getNumExpr() = 2 and
    ret.getExpr(1).getType().implements(Builtin::error().getType().getUnderlyingType()) and
    ret.getExpr(1) != Builtin::nil().getAReference()
  )
}

/**
 * Flow of TLS versions into a `tls.Config` struct, to the `MinVersion` and `MaxVersion` fields.
 */
class TlsVersionFlowConfig extends TaintTracking::Configuration {
  TlsVersionFlowConfig() { this = "TlsVersionFlowConfig" }

  /**
   * Holds if `source` is a TLS version source yielding value `val`.
   */
  predicate isSource(DataFlow::Node source, int val) {
    val = source.getIntValue() and
    not isReturnedWithError(source)
  }

  /**
   * Holds if `fieldWrite` writes `sink` to `base`.`fld`, where `fld` is a TLS version field.
   */
  predicate isSink(DataFlow::Node sink, Field fld, DataFlow::Node base, Write fieldWrite) {
    fld.hasQualifiedName("crypto/tls", "Config", ["MinVersion", "MaxVersion"]) and
    fieldWrite.writesField(base, fld, sink)
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _, _, _) }
}

/**
 * Holds if `config` exhibits a secure TLS version flowing from `source` to `sink`, which flows into `fld`.
 */
predicate secureTlsVersionFlow(
  TlsVersionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink, Field fld
) {
  exists(int version |
    config.hasFlowPath(source, sink) and
    config.isSource(source.getNode(), version) and
    not isInsecureTlsVersion(version, _, fld.getName())
  )
}

/**
 * Holds if a secure TLS version reaches `sink`, which flows into `fld`.
 */
predicate secureTlsVersionFlowsToSink(DataFlow::PathNode sink, Field fld) {
  secureTlsVersionFlow(_, _, sink, fld)
}

/**
 * Holds if a secure TLS version may reach `base`.`fld`
 */
predicate secureTlsVersionFlowsToField(SsaWithFields accessPath, Field fld) {
  exists(
    TlsVersionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
    DataFlow::Node base
  |
    secureTlsVersionFlow(config, source, sink, fld) and
    config.isSink(sink.getNode(), fld, base, _) and
    accessPath.getAUse() = base
  )
}

/**
 * Returns `node` or an implicit-deref node referring to it
 */
DataFlow::Node nodeOrDeref(DataFlow::Node node) {
  result = node or
  result.asInstruction() = IR::implicitDerefInstruction(node.asExpr())
}

/**
 * Holds if an insecure TLS version flows from `source` to `sink`, which is in turn written
 * to a field of `base`. `message` describes the specific problem found.
 */
predicate isInsecureTlsVersionFlow(
  DataFlow::PathNode source, DataFlow::PathNode sink, string message, DataFlow::Node base
) {
  exists(TlsVersionFlowConfig cfg, int version, Field fld |
    cfg.hasFlowPath(source, sink) and
    cfg.isSource(source.getNode(), version) and
    cfg.isSink(sink.getNode(), fld, base, _) and
    isInsecureTlsVersion(version, _, fld.getName()) and
    // Exclude cases where a secure TLS version can also flow to the same
    // sink, or to different sinks that refer to the same base and field,
    // which suggests a configurable security mode.
    not secureTlsVersionFlowsToSink(sink, fld) and
    not exists(SsaWithFields insecureAccessPath, SsaWithFields secureAccessPath |
      nodeOrDeref(insecureAccessPath.getAUse()) = base and
      secureAccessPath = insecureAccessPath.similar()
    |
      secureTlsVersionFlowsToField(secureAccessPath, fld)
    )
  |
    version = 0 and
    message = "Using lowest TLS version for " + fld + "."
    or
    version != 0 and
    exists(string name | isInsecureTlsVersion(version, name, _) |
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

  /**
   * Holds if `source` reads an insecure TLS cipher suite named `suiteName`.
   */
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

  /**
   * Holds if `source` represents the result of `tls.InsecureCipherSuites()`.
   */
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

  /**
   * Holds if `fieldWrite` writes `sink` to `base`.`fld`, and `fld` is `tls.Config.CipherSuites`.
   */
  predicate isSink(DataFlow::Node sink, Field fld, DataFlow::Node base, Write fieldWrite) {
    fld.hasQualifiedName("crypto/tls", "Config", "CipherSuites") and
    fieldWrite.writesField(base, fld, sink)
  }

  override predicate isSink(DataFlow::Node sink) { isSink(sink, _, _, _) }

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
 * Holds if an insecure TLS cipher suite flows from `source` to `sink`, where `sink`
 * is written to the CipherSuites list of a `tls.Config` instance. `message` describes
 * the exact problem found.
 */
predicate isInsecureTlsCipherFlow(DataFlow::PathNode source, DataFlow::PathNode sink, string message) {
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
    isInsecureTlsVersionFlow(source, sink, message, _) or
    isInsecureTlsCipherFlow(source, sink, message)
  ) and
  // Exclude sources or sinks guarded by a feature or legacy flag
  not [getAFeatureFlagCheck(), getALegacyVersionCheck()]
      .dominatesNode([source, sink].getNode().asInstruction()) and
  // Exclude sources or sinks that occur lexically within a block related to a feature or legacy flag
  not astNodeIsFlag([source, sink].getNode().asExpr().getParent*(), [featureFlag(), legacyFlag()]) and
  // Exclude results in functions whose name documents insecurity
  not exists(FuncDef fn | fn = sink.getNode().asInstruction().getRoot() |
    isFeatureFlagName(fn.getEnclosingFunction*().getName()) or
    isLegacyFlagName(fn.getEnclosingFunction*().getName())
  ) and
  // Exclude results in test code:
  not isTestFile(sink.getNode())
select sink.getNode(), source, sink, message
