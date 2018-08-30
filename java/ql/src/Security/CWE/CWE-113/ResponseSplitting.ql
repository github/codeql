/**
 * @name HTTP response splitting
 * @description Writing user input directly to an HTTP header
 *              makes code vulnerable to attack by header splitting.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/http-response-splitting
 * @tags security
 *       external/cwe/cwe-113
 */
import java
import ResponseSplitting

class ResponseSplittingConfig extends TaintTracking::Configuration {
  ResponseSplittingConfig() { this = "ResponseSplittingConfig" }
  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteUserInput and
    not source instanceof WhitelistedSource
  }
  override predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }
}

from HeaderSplittingSink sink, RemoteUserInput source, ResponseSplittingConfig conf
where conf.hasFlow(source, sink)
select sink, "Response-splitting vulnerability due to this $@.",
  source, "user-provided value"
