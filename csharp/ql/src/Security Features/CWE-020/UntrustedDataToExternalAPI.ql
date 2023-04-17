/**
 * @name Untrusted data passed to external API
 * @description Data provided remotely is used in this external API without sanitization, which could be a security risk.
 * @id cs/untrusted-data-to-external-api
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @security-severity 7.8
 * @tags security external/cwe/cwe-20
 */

import csharp
import semmle.code.csharp.commons.QualifiedName
import semmle.code.csharp.security.dataflow.ExternalAPIsQuery
import RemoteSourceToExternalApi::PathGraph

from
  RemoteSourceToExternalApi::PathNode source, RemoteSourceToExternalApi::PathNode sink,
  string qualifier, string name
where
  RemoteSourceToExternalApi::flowPath(source, sink) and
  sink.getNode().(ExternalApiDataNode).hasQualifiedName(qualifier, name)
select sink, source, sink,
  "Call to " + getQualifiedName(qualifier, name) + " with untrusted data from $@.", source,
  source.toString()
