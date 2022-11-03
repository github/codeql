/**
 * @name OLD QUERY: Deserializing untrusted input
 * @description Deserializing user-controlled data may allow attackers to execute arbitrary code.
 * @kind path-problem
 * @id py/old/unsafe-deserialization
 * @problem.severity error
 */

import python
import semmle.python.security.Paths
// Sources -- Any untrusted input
import semmle.python.web.HttpRequest
// Flow -- untrusted string
import semmle.python.security.strings.Untrusted
// Sink -- Unpickling and other deserialization formats.
import semmle.python.security.injection.Pickle
import semmle.python.security.injection.Marshal
import semmle.python.security.injection.Yaml

class UnsafeDeserializationConfiguration extends TaintTracking::Configuration {
  UnsafeDeserializationConfiguration() { this = "Unsafe deserialization configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof DeserializationSink }
}

from UnsafeDeserializationConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Deserializing of $@.", src.getSource(), "untrusted input"
