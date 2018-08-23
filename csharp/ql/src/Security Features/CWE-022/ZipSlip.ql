/**
 * @name Arbitrary file write during zip extraction ("Zip Slip")
 * @description Extracting files from a malicious zip archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten.
 * @kind problem
 * @id cs/zipslip
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import csharp
import semmle.code.csharp.security.dataflow.ZipSlip::ZipSlip

from TaintTrackingConfiguration zipTaintTracking, DataFlow::Node source, DataFlow::Node sink
where zipTaintTracking.hasFlow(source, sink)
select sink, "Unsanitized zip archive $@, which may contain '..', is used in a file system operation.", source, "item path"