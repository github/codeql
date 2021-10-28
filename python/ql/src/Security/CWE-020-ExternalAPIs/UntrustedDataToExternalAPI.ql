/**
 * @name Untrusted data passed to external API
 * @description Data provided remotely is used in this external API without sanitization, which could be a security risk.
 * @id python/untrusted-data-to-external-api
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @security-severity 7.8
 * @tags security external/cwe/cwe-20
 */

import python
import ExternalAPIs
import DataFlow::PathGraph

from
  UntrustedDataToExternalAPIConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
  ExternalAPIUsedWithUntrustedData externalAPI
where
  sink.getNode() = externalAPI.getUntrustedDataNode() and
  config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Call to " + externalAPI.toString() + " with untrusted data from $@.", source.getNode(),
  source.toString()
