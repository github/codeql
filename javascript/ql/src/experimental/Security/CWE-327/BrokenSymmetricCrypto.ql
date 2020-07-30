/**
 * @name Broken symmetric crypto
 * @description Incorrect usage of crypto algorithms or usage of weak algorithms could let attacker
 *              to decrypt encrypted data via chosen plaintext attack
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id js/broken-symmetric-crypto
 * @tags security
 *       external/cwe/cwe-327
 */

import javascript
import DataFlow
import DataFlow::PathGraph

class BrokenSymmetricCryptoConfiguration extends TaintTracking::Configuration {
  BrokenSymmetricCryptoConfiguration() { this = "BrokenSymmetricCryptoConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof BrokenSymmetricCryptoSink }
}

abstract class BrokenSymmetricCryptoSink extends DataFlow::Node { }

class ECBUsageSink extends BrokenSymmetricCryptoSink {
  ECBUsageSink() {
    exists(MethodCallNode call, string alg |
      call = moduleImport("crypto").getAMethodCall("createCipheriv") and
      alg = call.getArgument(0).getStringValue()
    |
      alg.matches(["%aes-___-ecb%", "%des-____-ecb%"]) and
      this = call.getAMethodCall("update").getArgument(0)
    )
  }
}

class ConstIVSink extends BrokenSymmetricCryptoSink {
  ConstIVSink() {
    exists(MethodCallNode call, string alg |
      call = moduleImport("crypto").getAMethodCall("createCipheriv") and
      alg = call.getArgument(0).getStringValue()
    |
      call.getContainer() != call.getArgument(2).getALocalSource().getContainer() and
      alg.matches(["%aes-___-ofb%", "%aes-___-ctr%"]) and
      this = call.getAMethodCall("update").getArgument(0)
    )
    or
    exists(MethodCallNode call | call = moduleImport("crypto").getAMethodCall("createCipheriv") |
      call.getNumArgument() < 3 and
      this = call.getAMethodCall("update").getArgument(0)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BrokenSymmetricCryptoConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to here and unsafely encrypted", source.getNode(),
  "User-provided value"
