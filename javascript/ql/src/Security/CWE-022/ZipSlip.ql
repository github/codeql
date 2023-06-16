/**
 * @name Arbitrary file access during archive extraction ("Zip Slip")
 * @description Accessing filesystem paths built from the name of an archive entry without
 *              validating that the destination file path is within the destination directory
 *              can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @id js/zipslip
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import javascript
import semmle.javascript.security.dataflow.ZipSlipQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
