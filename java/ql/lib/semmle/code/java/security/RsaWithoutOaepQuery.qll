/** Definitions for the RSA without OAEP query */

import java
import Encryption
import semmle.code.java.dataflow.DataFlow

/** A configuration for finding RSA ciphers initialized without using OAEP padding. */
class RsaWithoutOaepConfig extends DataFlow::Configuration {
  RsaWithoutOaepConfig() { this = "RsaWithoutOaepConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(CompileTimeConstantExpr specExpr, string spec |
      specExpr.getStringValue() = spec and
      specExpr = src.asExpr() and
      spec.matches("RSA/%") and
      not spec.matches("%OAEP%")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CryptoAlgoSpec cr | sink.asExpr() = cr.getAlgoSpec())
  }
}
