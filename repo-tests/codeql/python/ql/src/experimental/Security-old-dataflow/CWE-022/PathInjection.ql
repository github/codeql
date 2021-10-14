/**
 * @name OLD QUERY: Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @id py/old/path-injection
 */

import python
import semmle.python.security.Paths
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import semmle.python.security.injection.Path

class PathInjectionConfiguration extends TaintTracking::Configuration {
  PathInjectionConfiguration() { this = "Path injection configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof OpenNode }

  override predicate isSanitizer(Sanitizer sanitizer) {
    sanitizer instanceof PathSanitizer or
    sanitizer instanceof NormalizedPathSanitizer
  }

  override predicate isExtension(TaintTracking::Extension extension) {
    extension instanceof AbsPath
  }
}

from PathInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "This path depends on $@.", src.getSource(),
  "a user-provided value"
