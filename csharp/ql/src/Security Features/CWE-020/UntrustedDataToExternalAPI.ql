/**
 * @name Untrusted data passed to external API
 * @description Data provided remotely is used in this external API without sanitization, which could be a security risk.
 * @id csharp/untrusted-data-to-external-api
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @tags security external/cwe/cwe-20
 */

import csharp
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.security.dataflow.ExternalAPIs
import DataFlow::PathGraph

from UntrustedDataToExternalAPIConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "Call to " + sink.getNode().(ExternalAPIDataNode).getCallableDescription() +
    " with untrusted data from $@.", source, source.toString()
