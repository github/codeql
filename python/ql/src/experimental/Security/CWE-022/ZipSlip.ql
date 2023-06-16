/**
 * @name Arbitrary file access during archive extraction ("Zip Slip")
 * @description Accessing filesystem paths built from the name of an archive entry without
 *              validating that the destination file path is within the destination directory
 *              can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @id py/zipslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       experimental
 *       external/cwe/cwe-022
 */

import python
import experimental.semmle.python.security.ZipSlip
import DataFlow::PathGraph

from ZipSlipConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "This unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
