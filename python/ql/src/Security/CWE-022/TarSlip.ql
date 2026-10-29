/**
 * @name Arbitrary file write during tarfile extraction
 * @description Extracting files from a malicious tar archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id py/tarslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *       external/cwe/cwe-022
 */

import python
import semmle.python.security.dataflow.TarSlipQuery
import TarSlipFlow::PathGraph

from TarSlipFlow::PathNode source, TarSlipFlow::PathNode sink
where TarSlipFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
