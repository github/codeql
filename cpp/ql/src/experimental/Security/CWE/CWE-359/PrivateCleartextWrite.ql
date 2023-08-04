/**
 * @name Exposure of private information
 * @description If private information is written to an external location, it may be accessible by
 *              unauthorized persons.
 * @kind path-problem
 * @problem.severity error
 * @id cpp/private-cleartext-write
 * @tags security
 *       experimental
 *       external/cwe/cwe-359
 */

import cpp
import experimental.semmle.code.cpp.security.PrivateCleartextWrite
import experimental.semmle.code.cpp.security.PrivateCleartextWrite::PrivateCleartextWrite
import WriteFlow::PathGraph

from WriteFlow::PathNode source, WriteFlow::PathNode sink
where WriteFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This write into the external location '" + sink.getNode() +
    "' may contain unencrypted data from $@.", source, "this source of private data."
