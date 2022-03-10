/**
 * @name Clear-text storage of sensitive information
 * @description Storing sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rb/clear-text-storage-sensitive-data
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-359
 *       external/cwe/cwe-532
 */

import ruby
import codeql.ruby.security.CleartextStorageQuery
import codeql.ruby.security.CleartextStorageCustomizations::CleartextStorage
import codeql.ruby.DataFlow
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Sensitive data returned by $@ is stored $@.",
  source.getNode(), source.getNode().(Source).describe(), sink.getNode(), "here"
