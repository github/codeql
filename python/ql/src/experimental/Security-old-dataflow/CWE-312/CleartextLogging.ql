/**
 * @name Clear-text logging of sensitive information
 * @description OLD QUERY: Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @id py/old/clear-text-logging-sensitive-data
 * @deprecated
 */

import python
import semmle.python.security.Paths
import semmle.python.dataflow.TaintTracking
import semmle.python.security.SensitiveData
import semmle.python.security.ClearText

class CleartextLoggingConfiguration extends TaintTracking::Configuration {
  CleartextLoggingConfiguration() { this = "ClearTextLogging" }

  override predicate isSource(DataFlow::Node src, TaintKind kind) {
    src.asCfgNode().(SensitiveData::Source).isSourceOf(kind)
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) {
    sink.asCfgNode() instanceof ClearTextLogging::Sink and
    kind instanceof SensitiveData
  }
}

from CleartextLoggingConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Sensitive data returned by $@ is logged here.",
  source.getSource(), source.getCfgNode().(SensitiveData::Source).repr()
