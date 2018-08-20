/**
 * @name Potential ZipSlip vulnerability 
 * @description When extracting files from an archive, don't add archive item's path to the target file system path. Archive path can be relative and can lead to 
 * file system access outside of the expected file system target path, leading to malicious config changes and remote code execution via lay-and-wait technique 
 * @kind problem
 * @id cs/zipslip
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-022
 */

import csharp
import semmle.code.csharp.security.dataflow.ZipSlip::ZipSlip

from TaintTrackingConfiguration zipTaintTracking, DataFlow::Node source, DataFlow::Node sink
where zipTaintTracking.hasFlow(source, sink)
select sink, "Make sure to sanitize relative archive item path before creating path for file extraction if the source of $@ is untrusted", source, "zip archive"