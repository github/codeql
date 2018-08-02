/**
 * @name Clear text storage of sensitive information
 * @description Sensitive information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/cleartext-storage-of-sensitive-information
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */
import csharp
import semmle.code.csharp.security.dataflow.CleartextStorage::CleartextStorage

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "Sensitive data returned by $@ is stored here.", source, source.toString()
