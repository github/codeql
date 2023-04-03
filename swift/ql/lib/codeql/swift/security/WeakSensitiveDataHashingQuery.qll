/**
 * Provides a taint tracking configuration to find use of broken or weak
 * cryptographic hashing algorithms on sensitive data.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.WeakSensitiveDataHashingExtensions

module WeakHashingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof WeakHashingConfigImpl::Source }

  predicate isSink(DataFlow::Node node) { node instanceof WeakHashingConfigImpl::Sink }
}

module WeakHashingFlow = TaintTracking::Global<WeakHashingConfig>;

module WeakHashingConfigImpl {
  class Source extends DataFlow::Node {
    Source() { this.asExpr() instanceof SensitiveExpr }
  }

  abstract class Sink extends DataFlow::Node {
    abstract string getAlgorithm();
  }

  class CryptoHash extends Sink {
    string algorithm;

    CryptoHash() {
      exists(ApplyExpr call, FuncDecl func |
        call.getAnArgument().getExpr() = this.asExpr() and
        call.getStaticTarget() = func and
        func.getName().matches(["hash(%", "update(%"]) and
        algorithm = func.getEnclosingDecl().(ClassOrStructDecl).getName() and
        algorithm = ["MD5", "SHA1"]
      )
    }

    override string getAlgorithm() { result = algorithm }
  }
}
