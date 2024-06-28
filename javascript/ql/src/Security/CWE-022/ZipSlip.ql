/**
 * @name Arbitrary file access during archive extraction ("Zip Slip")
 * @description Extracting files from a malicious ZIP file, or similar type of archive, without
 *              validating that the destination file path is within the destination directory
 *              can allow an attacker to unexpectedly gain access to resources.
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
import DataFlow::DeduplicatePathGraph<ZipSlipFlow::PathNode, ZipSlipFlow::PathGraph>

from PathNode source, PathNode sink
where ZipSlipFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode())
select source.getNode(), source, sink,
  "Unsanitized archive entry, which may contain '..', is used in a $@.", sink.getNode(),
  "file system operation"
