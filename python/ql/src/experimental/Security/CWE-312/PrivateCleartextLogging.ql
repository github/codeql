/**
 * @name Clear-text logging of private information
 * @description Logging private information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/clear-text-logging-private-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import python
import semmle.python.security.Paths
import semmle.python.security.TaintTracking
import experimental.semmle.python.security.PrivateData
import semmle.python.security.ClearText

class CleartextLoggingConfiguration extends TaintTracking::Configuration {
  CleartextLoggingConfiguration() { this = "ClearTextLogging" }

  override predicate isSource(DataFlow::Node src, TaintKind kind) {
    src.asCfgNode().(PrivateData::Source).isSourceOf(kind)
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) {
    sink.asCfgNode() instanceof ClearTextLogging::Sink and
    kind instanceof PrivateData
  }
}

from CleartextLoggingConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Private data returned by $@ is logged here.",
  source.getSource(), source.getCfgNode().(PrivateData::Source).repr()
