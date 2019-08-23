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

import semmle.python.security.TaintTracking
import semmle.python.security.SensitiveData
import semmle.python.security.ClearText

class CleartextStorageConfiguration extends TaintTracking::Configuration {

    CleartextStorageConfiguration() {  this = "ClearTextStorage" }

    override predicate isSource(TaintSource src) {
        src instanceof SensitiveData::Source
    }

    override predicate isSink(TaintSink sink) {
        sink instanceof ClearTextStorage::Sink
    }

}


from CleartextStorageConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Sensitive data from $@ is stored here.",
  source.getSource(), source.getNode().(SensitiveData::Source).repr()
