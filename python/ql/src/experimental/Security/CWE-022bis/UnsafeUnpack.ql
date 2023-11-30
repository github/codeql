/**
 * @name Arbitrary file write during a tarball extraction from a user controlled source
 * @description Extracting files from a potentially malicious tarball using `shutil.unpack_archive()` without validating
 *              that the destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten. More precisely, if the tarball comes from a user controlled
 *              location either a remote one or cli argument.
 * @kind path-problem
 * @id py/unsafe-unpacking
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       experimental
 *       external/cwe/cwe-022
 */

import python
import experimental.Security.UnsafeUnpackQuery
import UnsafeUnpackFlow::PathGraph

from UnsafeUnpackFlow::PathNode source, UnsafeUnpackFlow::PathNode sink
where UnsafeUnpackFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Unsafe extraction from a malicious tarball retrieved from a remote location."
