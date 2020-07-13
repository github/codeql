/**
 * @name Exposure of private information
 * @description If private information is written to an external location, it may be accessible by
 *              unauthorized persons.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/exposure-of-sensitive-information
 * @tags security
 *       external/cwe/cwe-359
 */


import cpp
import experimental.semmle.code.cpp.security.PrivateCleartextWrite
import experimental.semmle.code.cpp.security.PrivateCleartextWrite::PrivateCleartextWrite

from WriteConfig b, DataFlow::Node source, DataFlow::Node sink
where b.hasFlow(source, sink)
select sink, "This write may contain unencrypted data"
