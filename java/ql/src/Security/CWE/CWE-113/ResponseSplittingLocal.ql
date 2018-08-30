/**
 * @name HTTP response splitting from local source
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/http-response-splitting-local
 * @tags security
 *       external/cwe/cwe-113
 */
import java
import semmle.code.java.dataflow.FlowSources
import ResponseSplitting

class ResponseSplittingLocalConfig extends TaintTracking::Configuration {
  ResponseSplittingLocalConfig() { this = "ResponseSplittingLocalConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }
}

from HeaderSplittingSink sink, LocalUserInput source, ResponseSplittingLocalConfig conf
where conf.hasFlow(source, sink)
select sink, "Response-splitting vulnerability due to this $@.",
  source, "user-provided value"
