/**
 * @name Timing attack against digest validation
 * @description When checking a signature over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid digest for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure
 *              both the message and the signature.
 *              A successful attack can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/timing-attack-against-signature
 * @tags security
 *       external/cwe/cwe-208
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import TimingAttack
import DataFlow::PathGraph

/**
 * A configuration that tracks data flow from cryptographic operations
 * to equality test
 */
class PossibleTimingAttackAgainstHash extends TaintTracking::Configuration {
  PossibleTimingAttackAgainstHash() { this = "PossibleTimingAttackAgainstHash" }

  override predicate isSource(DataFlow::Node source) {
    source = API::moduleImport("hmac").getMember("digest").getACall() or
    source =
      API::moduleImport("hmac")
          .getMember("new")
          .getReturn()
          .getMember(["digest", "hexdigest"])
          .getACall() or
    source =
      API::moduleImport("hashlib")
          .getMember([
              "new", "sha1", "sha224", "sha256", "sha384", "sha512", "blake2b", "blake2s", "md5"
            ])
          .getReturn()
          .getMember(["digest", "hexdigest"])
          .getACall()
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CompareSink }
}

from PossibleTimingAttackAgainstSignature config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible Timing attack against $@ validation.", source,
  source.getNode()
