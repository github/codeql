/**
 * @name Insecure randomness
 * @description Using a cryptographically insecure pseudo-random number generator to generate a
 *              security-sensitive value may allow an attacker to predict what value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id cpp/insecure-randomness
 * @tags security
 *       external/cwe/cwe-330
 *       external/cwe/cwe-338
 */

import cpp
import experimental.quantum.Language
import InsecureRandomnessFlow::PathGraph

/**
 * A taint-tracking configuration for flow from a cryptographically insecure
 * random number generator to security-sensitive value such as a key, IV, or nonce.
 */
module InsecureRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Crypto::RandomNumberGenerationInstance generator |
      not generator.isCryptographicallySecure() and
      source = generator.getOutputNode()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::KeyOperationInstance op).getKeyConsumer()
    or
    sink = any(Crypto::KeyOperationInstance op).getNonceConsumer()
    or
    sink = any(Crypto::KeyGenerationOperationInstance op).getKeyValueConsumer()
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module InsecureRandomnessFlow = TaintTracking::Global<InsecureRandomnessConfig>;

from InsecureRandomnessFlow::PathNode source, InsecureRandomnessFlow::PathNode sink
where InsecureRandomnessFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This security-sensitive value depends on $@, which is not cryptographically secure.",
  source.getNode(), "a randomly generated number"
