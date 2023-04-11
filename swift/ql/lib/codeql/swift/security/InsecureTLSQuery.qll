/**
 * Provides a taint tracking configuration to find insecure TLS
 * configurations.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.InsecureTLSExtensions

/**
 * A taint config to detect insecure configuration of `NSURLSessionConfiguration`.
 */
module InsecureTlsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSource }

  predicate isSink(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(InsecureTlsExtensionsAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from fields of an `URLSessionConfiguration` at the sink,
    // for example in `sessionConfig.tlsMaximumSupportedProtocolVersion = tls_protocol_version_t.TLSv10`.
    isSink(node) and
    exists(NominalTypeDecl d, Decl cx |
      d.getType().getABaseType*().getUnderlyingType().getName() = "URLSessionConfiguration" and
      cx.asNominalTypeDecl() = d and
      c.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
    )
  }
}

module InsecureTlsFlow = TaintTracking::Global<InsecureTlsConfig>;
