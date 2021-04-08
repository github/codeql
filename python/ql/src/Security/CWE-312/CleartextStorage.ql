/**
 * @name Clear-text storage of sensitive information
 * @description Sensitive information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/clear-text-storage-sensitive-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import python
import semmle.python.security.Paths
import semmle.python.dataflow.TaintTracking
import semmle.python.security.SensitiveData
import semmle.python.security.ClearText

class CleartextStorageConfiguration extends TaintTracking::Configuration {
  CleartextStorageConfiguration() { this = "ClearTextStorage" }

  override predicate isSource(DataFlow::Node src, TaintKind kind) {
    src.asCfgNode().(SensitiveData::Source).isSourceOf(kind)
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) {
    sink.asCfgNode() instanceof ClearTextStorage::Sink and
    kind instanceof SensitiveData
  }
}

from CleartextStorageConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Sensitive data from $@ is stored here.", source.getSource(),
  source.getCfgNode().(SensitiveData::Source).repr()
