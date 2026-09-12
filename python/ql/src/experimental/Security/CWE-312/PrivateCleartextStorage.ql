/**
 * @name Clear-text storage of private information
 * @description Private information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind path-problem
 * @problem.severity error
 * @id py/clear-text-storage-private-data
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

class CleartextStorageConfiguration extends TaintTracking::Configuration {
  CleartextStorageConfiguration() { this = "PrivateClearTextStorage" }

  override predicate isSource(DataFlow::Node src, TaintKind kind) {
    src.asCfgNode().(PrivateData::Source).isSourceOf(kind)
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) {
    sink.asCfgNode() instanceof ClearTextStorage::Sink and
    kind instanceof PrivateData
  }
}

from CleartextStorageConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Private data from $@ is stored here.", source.getSource(),
  source.getCfgNode().(PrivateData::Source).repr()
