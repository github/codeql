/**
 * @name Clear text storage of sensitive information
 * @description Sensitive information stored without encryption or hashing can expose it to an
 *              attacker.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/clear-text-storage-of-sensitive-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.security.dataflow.CleartextStorage::CleartextStorage

from Configuration cleartextStorage, Source source, DataFlow::Node sink
where cleartextStorage.hasFlow(source, sink)
select sink, "Sensitive data returned by $@ is stored here.", source, source.describe()
