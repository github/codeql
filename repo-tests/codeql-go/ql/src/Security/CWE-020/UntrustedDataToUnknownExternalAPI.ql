/**
 * @name Untrusted data passed to unknown external API
 * @description Data provided remotely is used in this unknown external API without sanitization, which could be a security risk.
 * @id go/untrusted-data-to-unknown-external-api
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @security-severity 7.8
 * @tags security external/cwe/cwe-20
 */

import go
import semmle.go.security.ExternalAPIs
import DataFlow::PathGraph

from
  UntrustedDataToUnknownExternalAPIConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "Call to " + sink.getNode().(UnknownExternalAPIDataNode).getFunctionDescription() +
    " with untrusted data from $@.", source, source.toString()
