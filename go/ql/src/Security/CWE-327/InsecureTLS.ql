/**
 * @name Insecure TLS configuration
 * @description If an application supports insecure TLS versions or ciphers, it may be vulnerable to
 *              machine-in-the-middle and other attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision very-high
 * @id go/insecure-tls
 * @tags security
 *       external/cwe/cwe-327
 */

import go
import semmle.go.security.InsecureFeatureFlag::InsecureFeatureFlag

/**
 * Holds if it is insecure to assign TLS version `val` named `name` to `tls.Config` field `fieldName`.
 */
predicate isInsecureTlsVersion(int val, string name, string fieldName) {
  (fieldName = "MinVersion" or fieldName = "MaxVersion") and
  (
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
    val = 0 and name = "" and fieldName = "MinVersion"
  )
}

/**
 * Returns integers that may represent a secure TLS version.
 */
int getASecureTlsVersion() {
  result in [771, 772] // TLS 1.2 and 1.3 respectively
}

/**
 * Returns integers that may represent a TLS version.
 *
 * Integer values corresponding to versions are defined at https://golang.org/pkg/crypto/tls/#pkg-constants
 * Zero means the default version; at the time of writing, TLS 1.0.
 */
int getATlsVersion() { result = getASecureTlsVersion() or isInsecureTlsVersion(result, _, _) }

module TlsVersionFlowConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is a TLS version source yielding value `val`.
   */
  additional predicate intIsSource(DataFlow::Node source, int val) {
    val = source.getIntValue() and
    val = getATlsVersion() and
    not DataFlow::isReturnedWithError(source)
  }

  /**
   * Holds if `fieldWrite` writes `sink` to `base`.`fld`, where `fld` is a TLS version field.
   */
  additional predicate isSink(DataFlow::Node sink, Field fld, DataFlow::Node base, Write fieldWrite) {
    fld.hasQualifiedName("crypto/tls", "Config", ["MinVersion", "MaxVersion"]) and
    fieldWrite.writesField(base, fld, sink)
  }

  predicate isSource(DataFlow::Node source) { intIsSource(source, _) }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _, _, _) }
}

/**
 * Tracks taint flow from TLS versions to the `tls.Config.MinVersion` and
 * `tls.Config.MaxVersion` fields.
 */
module TlsVersionFlow = TaintTracking::Global<TlsVersionFlowConfig>;

/**
 * Holds if `config` exhibits a secure TLS version flowing from `source` to `sink`, which flows into `fld`.
 */
predicate secureTlsVersionFlow(DataFlow::Node source, DataFlow::Node sink, Field fld) {
  exists(int version |
    TlsVersionFlow::flow(source, sink) and
    TlsVersionFlowConfig::intIsSource(source, version) and
    not isInsecureTlsVersion(version, _, fld.getName())
  )
}

/**
 * Holds if a secure TLS version reaches `sink`, which flows into `fld`.
 */
predicate secureTlsVersionFlowsToSink(DataFlow::Node sink, Field fld) {
  secureTlsVersionFlow(_, sink, fld)
}

/**
 * Holds if a secure TLS version may reach `accessPath`.`fld`
 */
predicate secureTlsVersionFlowsToField(SsaWithFields accessPath, Field fld) {
  exists(DataFlow::Node sink, DataFlow::Node base |
    secureTlsVersionFlow(_, sink, fld) and
    TlsVersionFlowConfig::isSink(sink, fld, base, _) and
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
  TlsVersionFlow::PathNode source, TlsVersionFlow::PathNode sink, string message,
  DataFlow::Node base
) {
  exists(int version, Field fld |
    TlsVersionFlow::flowPath(source, sink) and
    TlsVersionFlowConfig::intIsSource(source.getNode(), version) and
    TlsVersionFlowConfig::isSink(sink.getNode(), fld, base, _) and
    isInsecureTlsVersion(version, _, fld.getName()) and
    // Exclude cases where a secure TLS version can also flow to the same
    // sink, or to different sinks that refer to the same base and field,
    // which suggests a configurable security mode.
    not secureTlsVersionFlowsToSink(sink.getNode(), fld) and
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

module TlsInsecureCipherSuitesFlowConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` reads an insecure TLS cipher suite named `suiteName`.
   */
  additional predicate isSourceValueEntity(DataFlow::Node source, string suiteName) {
    exists(DataFlow::ValueEntity val |
      val.hasQualifiedName("crypto/tls", suiteName) and
      suiteName =
        [
          "TLS_RSA_WITH_RC4_128_SHA", "TLS_RSA_WITH_AES_128_CBC_SHA256",
          "TLS_ECDHE_ECDSA_WITH_RC4_128_SHA", "TLS_ECDHE_RSA_WITH_RC4_128_SHA",
          "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
        ]
    |
      source = val.getARead()
    )
  }

  /**
   * Holds if `source` represents the result of `tls.InsecureCipherSuites()`.
   */
  additional predicate isSourceInsecureCipherSuites(DataFlow::Node source) {
    exists(Function insecureCipherSuites |
      insecureCipherSuites.hasQualifiedName("crypto/tls", "InsecureCipherSuites")
    |
      source = insecureCipherSuites.getACall().getResult()
    )
  }

  predicate isSource(DataFlow::Node source) {
    isSourceInsecureCipherSuites(source)
    or
    isSourceValueEntity(source, _)
  }

  /**
   * Holds if `fieldWrite` writes `sink` to `base`.`fld`, and `fld` is `tls.Config.CipherSuites`.
   */
  additional predicate isSink(DataFlow::Node sink, Field fld, DataFlow::Node base, Write fieldWrite) {
    fld.hasQualifiedName("crypto/tls", "Config", "CipherSuites") and
    fieldWrite.writesField(base, fld, sink)
  }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _, _, _) }

  /**
   * Declare sinks as out-sanitizers in order to avoid producing superfluous paths where a cipher
   * is written to CipherSuites, then the list is further extended with either safe or tainted
   * suites.
   */
  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }
}

/**
 * Tracks taint flow from insecure TLS cipher suites into the `CipherSuites`
 * field of a `tls.Config` struct.
 */
module TlsInsecureCipherSuitesFlow = TaintTracking::Global<TlsInsecureCipherSuitesFlowConfig>;

/**
 * Holds if an insecure TLS cipher suite flows from `source` to `sink`, where `sink`
 * is written to the CipherSuites list of a `tls.Config` instance. `message` describes
 * the exact problem found.
 */
predicate isInsecureTlsCipherFlow(
  TlsInsecureCipherSuitesFlow::PathNode source, TlsInsecureCipherSuitesFlow::PathNode sink,
  string message
) {
  TlsInsecureCipherSuitesFlow::flowPath(source, sink) and
  (
    exists(string name |
      TlsInsecureCipherSuitesFlowConfig::isSourceValueEntity(source.getNode(), name)
    |
      message = "Use of an insecure cipher suite: " + name + "."
    )
    or
    TlsInsecureCipherSuitesFlowConfig::isSourceInsecureCipherSuites(source.getNode()) and
    message = "Use of an insecure cipher suite."
  )
}

/**
 * A flag suggesting support for an old or legacy TLS version.
 *
 * We accept 'intermediate' because it appears to be common for TLS users
 * to define three profiles: modern, intermediate, legacy/old, perhaps based
 * on https://wiki.mozilla.org/Security/Server_Side_TLS (though note the
 * 'intermediate' used there would now pass muster according to this query)
 */
class LegacyTlsVersionFlag extends FlagKind {
  LegacyTlsVersionFlag() { this = "legacyTlsVersion" }

  bindingset[result]
  override string getAFlagName() { result.regexpMatch("(?i).*(old|intermediate|legacy).*") }
}

/**
 * Gets a control-flow node that represents a (likely) flag controlling TLS version selection.
 */
ControlFlow::ConditionGuardNode getALegacyTlsVersionCheck() {
  result.ensures(any(LegacyTlsVersionFlag f).getAFlag().getANode(), _)
}

/**
 * Returns flag kinds relevant to this query: a generic security feature flag, or one
 * specifically controlling TLS version selection.
 */
FlagKind securityOrTlsVersionFlag() {
  result = any(SecurityFeatureFlag f) or
  result = any(LegacyTlsVersionFlag f)
}

module Flow =
  DataFlow::MergePathGraph<TlsVersionFlow::PathNode, TlsInsecureCipherSuitesFlow::PathNode,
    TlsVersionFlow::PathGraph, TlsInsecureCipherSuitesFlow::PathGraph>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink, string message
where
  (
    isInsecureTlsVersionFlow(source.asPathNode1(), sink.asPathNode1(), message, _) or
    isInsecureTlsCipherFlow(source.asPathNode2(), sink.asPathNode2(), message)
  ) and
  // Exclude sources or sinks guarded by a feature or legacy flag
  not [getASecurityFeatureFlagCheck(), getALegacyTlsVersionCheck()]
      .dominatesNode([source, sink].getNode().asInstruction()) and
  // Exclude sources or sinks that occur lexically within a block related to a feature or legacy flag
  not astNodeIsFlag([source, sink].getNode().asExpr().getParent*(), securityOrTlsVersionFlag()) and
  // Exclude results in functions whose name documents insecurity
  not exists(FuncDef fn | fn = sink.getNode().getRoot().getEnclosingFunction*() |
    fn.getName() = securityOrTlsVersionFlag().getAFlagName()
  )
select sink.getNode(), source, sink, message
