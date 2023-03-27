/**
 * @name Clear text storage of sensitive information
 * @description Sensitive information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/cleartext-storage-of-sensitive-information
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import csharp
import semmle.code.csharp.security.dataflow.CleartextStorageQuery
import CleartextStorage::PathGraph

from CleartextStorage::PathNode source, CleartextStorage::PathNode sink
where CleartextStorage::flowPath(source, sink)
select sink.getNode(), source, sink, "This stores sensitive data returned by $@ as clear text.",
  source.getNode(), source.toString()
