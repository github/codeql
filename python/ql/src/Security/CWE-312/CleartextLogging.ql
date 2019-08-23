/**
 * @name Clear-text logging of sensitive information
 * @description Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/clear-text-logging-sensitive-data
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


class CleartextLoggingConfiguration extends TaintTracking::Configuration {

    CleartextLoggingConfiguration() {  this = "ClearTextLogging" }

    override predicate isSource(TaintSource src) {
        src instanceof SensitiveData::Source
    }

    override predicate isSink(TaintSink sink) {
        sink instanceof ClearTextLogging::Sink
    }

}


from CleartextLoggingConfiguration config, TaintedPathSource source, TaintedPathSink sink
where config.hasFlowPath(source, sink)
select sink.getSink(), source, sink, "Sensitive data returned by $@ is logged here.",
  source.getSource(), source.getNode().(SensitiveData::Source).repr()
