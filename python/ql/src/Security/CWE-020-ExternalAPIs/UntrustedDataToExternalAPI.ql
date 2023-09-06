/**
 * @name Untrusted data passed to external API
 * @description Data provided remotely is used in this external API without sanitization, which could be a security risk.
 * @id py/untrusted-data-to-external-api
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @security-severity 7.8
 * @tags security external/cwe/cwe-20
 */

import python
import ExternalAPIs
import UntrustedDataToExternalApiFlow::PathGraph

from
  UntrustedDataToExternalApiFlow::PathNode source, UntrustedDataToExternalApiFlow::PathNode sink,
  ExternalApiUsedWithUntrustedData externalApi
where
  sink.getNode() = externalApi.getUntrustedDataNode() and
  UntrustedDataToExternalApiFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Call to " + externalApi.toString() + " with untrusted data from $@.", source.getNode(),
  source.toString()
