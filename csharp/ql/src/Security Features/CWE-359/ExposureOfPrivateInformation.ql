/**
 * @name Exposure of private information
 * @description If private information is written to an external location, it may be accessible by
 *              unauthorized persons.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/exposure-of-sensitive-information
 * @tags security
 *       external/cwe/cwe-359
 */
import csharp
import semmle.code.csharp.security.dataflow.ExposureOfPrivateInformation::ExposureOfPrivateInformation

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "Private data returned by $@ is written to an external location.", source, source.toString()
