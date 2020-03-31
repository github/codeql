/**
 * @name Arbitrary file write during zip extraction ("Zip Slip")
 * @description Extracting files from a malicious zip archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind path-problem
 * @id cs/zipslip
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import csharp
import semmle.code.csharp.security.dataflow.ZipSlip::ZipSlip
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration zipTaintTracking, DataFlow::PathNode source, DataFlow::PathNode sink
where zipTaintTracking.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
