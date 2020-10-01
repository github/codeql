/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id py/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import python
import semmle.python.security.Paths
import semmle.python.security.SensitiveData
import semmle.python.security.Crypto

class BrokenCryptoConfiguration extends TaintTracking::Configuration {
  BrokenCryptoConfiguration() { this = "Broken crypto configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof SensitiveDataSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof WeakCryptoSink }
}

from BrokenCryptoConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ is used in a broken or weak cryptographic algorithm.",
  src.getSource(), "Sensitive data"
